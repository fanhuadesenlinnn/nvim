-- init.lua 是 Neovim 启动入口；这里按顺序加载各个配置模块。
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.gui")
require("config.lazy")
require("config.health")
