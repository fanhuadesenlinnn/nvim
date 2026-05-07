local M = {}
local uv = vim.uv or vim.loop

local function executable(name)
  return vim.fn.executable(name) == 1
end

local function notify_missing(title, lines)
  vim.schedule(function()
    vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN, { title = title })
  end)
end

function M.check()
  local system = uv.os_uname().sysname

  if not executable("git") then
    notify_missing("缺少 git", {
      "lazy.nvim 和大多数插件都需要 git。",
      "macOS: brew install git",
      "Ubuntu/Debian: sudo apt install git",
      "Fedora: sudo dnf install git",
      "Arch Linux: sudo pacman -S git",
      "Windows: winget install --id Git.Git -e",
    })
  end

  if not executable("rg") then
    notify_missing("缺少 ripgrep", {
      "Telescope 的全文搜索 <Space>fg 需要 rg。",
      "macOS: brew install ripgrep",
      "Ubuntu/Debian: sudo apt install ripgrep",
      "Fedora: sudo dnf install ripgrep",
      "Arch Linux: sudo pacman -S ripgrep",
      "Windows: winget install --id BurntSushi.ripgrep.MSVC -e",
    })
  end

  -- C 编译器和 tree-sitter CLI 只在安装/更新原生插件或 parser 时才需要。
  -- 为了平时启动不打扰，这两个依赖放到真正 build 时再提示。

  if system == "Linux" and vim.fn.has("clipboard") == 0 then
    notify_missing("系统剪贴板不可用", {
      "Linux 终端下复制粘贴可能需要额外工具。",
      "Wayland: sudo apt install wl-clipboard",
      "X11: sudo apt install xclip",
    })
  end
end

-- 等界面启动后再提示，避免启动过程被通知打断。
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("user_dependency_health", { clear = true }),
  once = true,
  callback = function()
    M.check()
  end,
})

return M
