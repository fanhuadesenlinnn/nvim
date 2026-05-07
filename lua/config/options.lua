local opt = vim.opt

-- <Space> 是整套配置的“总入口键”，很多快捷键都会以它开头。
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基础显示：行号、当前行高亮和左侧符号列能让新手更容易定位光标和错误提示。
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- 默认使用 2 个空格缩进，适合 Lua、前端和大多数配置文件。
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- 搜索体验：默认忽略大小写，但你输入大写字母时自动切成大小写敏感。
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.hlsearch = true

-- 分屏总是向右、向下打开，方向更符合直觉。
opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = "menu,menuone,noselect"

-- 保留撤销历史，关闭 swap/backup 文件，减少配置目录里的临时文件噪音。
opt.undofile = true
opt.swapfile = false
opt.backup = false
-- 文件被外部程序修改后，Neovim 检测到时自动重新读取未改动的 buffer。
opt.autoread = true

-- 显示不可见字符，方便发现行尾多余空格。
opt.list = true
opt.listchars = {
  tab = "  ",
  trail = ".",
  nbsp = "+",
}

-- 只有系统剪贴板可用时才开启，避免在精简 Linux 服务器上启动报错。
if vim.fn.has("clipboard") == 1 then
  opt.clipboard = "unnamedplus"
end
