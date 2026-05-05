local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

-- lazypath 是 lazy.nvim 插件管理器安装到本机的位置。
-- stdpath("data") 通常是 ~/.local/share/nvim；这样配置仓库本身不会混入下载下来的插件。
-- 如果本机还没有 lazy.nvim，就自动从 GitHub 克隆稳定版。
if not uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    repo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "克隆 lazy.nvim 失败，请确认已经安装 git 且网络可以访问 GitHub：\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n按任意键退出..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 把 lazy.nvim 加进 runtimepath 后，Neovim 才能 require("lazy")。
vim.opt.rtp:prepend(lazypath)

-- 插件列表统一从 lua/config/plugins.lua 进入；想关闭一组插件时，注释对应 import 行即可。
require("lazy").setup({
  spec = require("config.plugins"),
  defaults = {
    -- 默认直接加载，少量插件在各自文件里用 event/cmd/keys 做懒加载。
    lazy = false,
    version = false,
  },
  install = {
    -- 如果主题插件还没装好，lazy.nvim 会先尝试用这些主题兜底，避免启动界面太难看。
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    -- 自动检查插件更新，但不频繁弹通知打扰你。
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      -- 关闭一些 Neovim 自带但这套配置暂时不用的运行时插件，减少启动负担。
      -- netrwPlugin 被 nvim-tree 替代，所以这里也关掉。
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
