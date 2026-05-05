-- init.lua 是 Neovim 启动入口；这里按顺序加载各个配置模块。
-- 这套配置的思路是：通用设置先加载，图形界面设置自动判断 Neovide，最后再交给 lazy.nvim 管插件。
-- 以后如果你新增配置文件，通常也会在这里 require 一下。
require("config.options")
require("config.keymaps")
require("config.autocmds")
-- gui.lua 内部会判断 vim.g.neovide；普通终端 Neovim 会直接跳过，不会受 Neovide 配置影响。
require("config.gui")
-- lazy.lua 会自动安装 lazy.nvim，并加载 lua/config/plugins.lua 里的插件列表。
require("config.lazy")
-- health.lua 会在启动后检查 git、rg、tree-sitter 等常见依赖，缺少时给出安装提示。
require("config.health")
