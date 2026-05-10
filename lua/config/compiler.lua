local M = {}

local notified = {}

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function system_name()
  return (vim.uv or vim.loop).os_uname().sysname
end

local function notify_once(key, title, lines)
  if notified[key] then
    return
  end
  notified[key] = true

  vim.schedule(function()
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, { title = title })
  end)
end

local function path_separator()
  return system_name() == "Windows_NT" and ";" or ":"
end

local function prepend_path(dir)
  local old_path = vim.env.PATH
  local old_Path = vim.env.Path
  local current_path = vim.env.PATH or vim.env.Path or ""
  local new_path = dir .. path_separator() .. current_path

  -- Windows 的环境变量名大小写不敏感，但不同外部程序读取 PATH/Path 的行为不完全一致。
  -- 两个都设置可以避免 tree-sitter/cc-rs 或 make 子进程拿不到 wrapper 所在目录。
  vim.env.PATH = new_path
  vim.env.Path = new_path

  return function()
    vim.env.PATH = old_path
    vim.env.Path = old_Path
  end
end

local function write_file(path, lines)
  vim.fn.writefile(lines, path)
end

local function make_executable(path)
  if system_name() == "Windows_NT" then
    return
  end

  pcall((vim.uv or vim.loop).fs_chmod, path, tonumber("755", 8))
end

local function ensure_zig_wrappers()
  local dir = vim.fn.stdpath("cache") .. "/compiler"
  vim.fn.mkdir(dir, "p")

  if system_name() == "Windows_NT" then
    local cc_name = "nvim-zigcc.cmd"
    local cxx_name = "nvim-zigcxx.cmd"

    write_file(dir .. "/" .. cc_name, {
      "@echo off",
      "zig cc -target x86_64-windows-gnu %*",
    })

    write_file(dir .. "/" .. cxx_name, {
      "@echo off",
      "zig c++ -target x86_64-windows-gnu %*",
    })

    return {
      dir = dir,
      cc = cc_name,
      cxx = cxx_name,
    }
  end

  local cc_name = "nvim-zigcc"
  local cxx_name = "nvim-zigcxx"
  local cc_path = dir .. "/" .. cc_name
  local cxx_path = dir .. "/" .. cxx_name

  write_file(cc_path, {
    "#!/usr/bin/env sh",
    "exec zig cc \"$@\"",
  })

  write_file(cxx_path, {
    "#!/usr/bin/env sh",
    "exec zig c++ \"$@\"",
  })

  make_executable(cc_path)
  make_executable(cxx_path)

  return {
    dir = dir,
    cc = cc_name,
    cxx = cxx_name,
  }
end

local function install_lines()
  local system = system_name()

  if system == "Windows_NT" then
    return {
      "需要 C 编译器时会优先使用 zig cc，其次使用 gcc。",
      "推荐安装 Zig:",
      "  winget install zig.zig",
      "如果你更想使用 GCC，可以安装 MSYS2，然后在 MSYS2 里安装 mingw-w64-ucrt-x86_64-gcc。",
    }
  end

  if system == "Darwin" then
    return {
      "需要 C 编译器时会优先使用 zig cc，其次使用 gcc。",
      "macOS 推荐安装 Zig:",
      "  brew install zig",
      "或者安装 GCC:",
      "  brew install gcc",
    }
  end

  return {
    "需要 C 编译器时会优先使用 zig cc，其次使用 gcc。",
    "Ubuntu/Debian:",
    "  sudo apt install zig gcc",
    "Fedora:",
    "  sudo dnf install zig gcc",
    "Arch:",
    "  sudo pacman -S zig gcc",
  }
end

function M.resolve()
  if executable("zig") then
    local wrappers = ensure_zig_wrappers()

    return {
      label = "zig cc",
      cc = wrappers.cc,
      cxx = wrappers.cxx,
      path_dir = wrappers.dir,
    }
  end

  if executable("gcc") then
    return {
      label = "gcc",
      cc = "gcc",
      cxx = "g++",
    }
  end

  return nil
end

function M.notify_missing(context)
  local lines = install_lines()
  table.insert(lines, 1, ("当前操作需要 C 编译器：%s"):format(context))
  notify_once("compiler:" .. context, "缺少 C 编译器", lines)
end

function M.with_compiler(context, callback)
  local compiler = M.resolve()
  if not compiler then
    M.notify_missing(context)
    return false
  end

  local old_cc = vim.env.CC
  local old_cxx = vim.env.CXX
  local restore_path = compiler.path_dir and prepend_path(compiler.path_dir) or nil

  -- tree-sitter build 会读取 CC/CXX。这里不要直接写 "zig cc"，因为 Windows 下
  -- cc-rs/tree-sitter 可能只执行到 zig.exe，导致 Zig 打印 Usage 而不是进入 cc 子命令。
  -- 使用 wrapper 命令名 + 临时 PATH 更稳，也能避开用户目录带空格时的路径解析问题。
  vim.env.CC = compiler.cc
  vim.env.CXX = compiler.cxx

  local ok, result = pcall(callback, compiler)

  vim.env.CC = old_cc
  vim.env.CXX = old_cxx
  if restore_path then
    restore_path()
  end

  if not ok then
    error(result)
  end

  return result == nil and true or result
end

function M.notify_missing_make(context)
  notify_once("make:" .. context, "缺少 make", {
    ("当前操作需要 make：%s"):format(context),
    "macOS:",
    "  xcode-select --install",
    "Ubuntu/Debian:",
    "  sudo apt install make",
    "Fedora:",
    "  sudo dnf install make",
    "Windows:",
    "  推荐安装 CMake 或 MSYS2/MinGW 提供的 make。",
  })
end

function M.make(plugin, context)
  local compiler = M.resolve()
  if not compiler then
    M.notify_missing(context)
    return false
  end

  if not executable("make") then
    M.notify_missing_make(context)
    return false
  end

  return M.with_compiler(context, function(active_compiler)
    compiler = active_compiler
    vim.notify(("正在使用 %s 编译 %s"):format(compiler.label, context), vim.log.levels.INFO, { title = "C 编译器" })

    if vim.system then
      local result = vim.system({ "make", "CC=" .. compiler.cc }, {
        cwd = plugin.dir,
        text = true,
      }):wait()

      if result.code ~= 0 then
        error(result.stderr ~= "" and result.stderr or result.stdout)
      end

      return true
    end

    local cwd = vim.fn.getcwd()
    vim.fn.chdir(plugin.dir)
    local output = vim.fn.system({ "make", "CC=" .. compiler.cc })
    local ok = vim.v.shell_error == 0
    vim.fn.chdir(cwd)

    if not ok then
      error(output)
    end

    return true
  end)
end

return M
