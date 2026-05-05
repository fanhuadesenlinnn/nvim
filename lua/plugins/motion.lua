return {
  {
    -- flash.nvim 是 LazyVim 也常用的跳转插件；这里用它实现你要的 f 全窗口可见字符跳转。
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- 标签字母优先放左手常用键，跳转时更顺手。想换标签顺序可以改这个字符串。
      labels = "asdfghjklqwertyuiopzxcvbnm",
      modes = {
        char = {
          -- f 使用 lua/config/jump.lua 中包装后的 Flash 跳转。
          -- 这里关闭 Flash 自带的 f/F/t/T 字符模式，避免两个逻辑同时抢同一个按键。
          enabled = false,
        },
      },
    },
    keys = {
      {
        "f",
        mode = "n",
        function()
          -- 自定义逻辑放在 lua/config/jump.lua，避免 motion.lua 变得太复杂。
          require("config.jump").visible()
        end,
        desc = "当前 tab 可见窗口按字符跳转",
      },
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "快速跳转到可见位置",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "按语法结构跳转",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "远程选择操作目标",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "按语法结构搜索",
      },
    },
  },
}
