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
    return {
      label = "zig cc",
      cc = "zig cc",
    }
  end

  if executable("gcc") then
    return {
      label = "gcc",
      cc = "gcc",
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
  vim.env.CC = compiler.cc

  local ok, result = pcall(callback, compiler)
  vim.env.CC = old_cc

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
