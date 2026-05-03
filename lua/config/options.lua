local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.hlsearch = true

opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = "menu,menuone,noselect"

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.list = true
opt.listchars = {
  tab = "  ",
  trail = ".",
  nbsp = "+",
}

if vim.fn.has("clipboard") == 1 then
  opt.clipboard = "unnamedplus"
end
