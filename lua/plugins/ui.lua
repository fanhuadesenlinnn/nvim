return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- 启动页就是 LazyVim 打开时那个友好的欢迎页面。
      dashboard = {
        enabled = true,
        preset = {
          header = [[
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
          keys = {
            -- f 留给普通编辑界面的可见区跳转；启动页用 p 打开文件查找，避免同键不同作用。
            { icon = " ", key = "p", desc = "查找文件", action = ":Telescope find_files" },
            { icon = " ", key = "n", desc = "新建文件", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "全文搜索",
              action = function()
                if vim.fn.executable("rg") == 0 then
                  vim.notify("全文搜索需要 ripgrep。\nmacOS: brew install ripgrep\nUbuntu/Debian: sudo apt install ripgrep", vim.log.levels.WARN, { title = "缺少 rg" })
                  return
                end
                require("telescope.builtin").live_grep()
              end,
            },
            { icon = " ", key = "r", desc = "最近文件", action = ":Telescope oldfiles" },
            {
              icon = " ",
              key = "c",
              desc = "编辑配置",
              action = function()
                require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
              end,
            },
            { icon = "󰒲 ", key = "l", desc = "插件管理", action = ":Lazy" },
            { icon = " ", key = "q", desc = "退出", action = ":qa" },
          },
        },
      },
      -- 友好输入框和通知组件，让提示信息更清楚。
      input = { enabled = true },
      notifier = { enabled = true },
    },
  },
  {
    -- which-key 会在你按下 <Space> 后弹出快捷键提示，新手记快捷键会轻松很多。
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 250,
      spec = {
        { "<leader>b", group = "已打开文件操作" },
        { "<leader>f", group = "查找/搜索" },
        { "<leader>g", group = "Git 操作" },
        { "<leader>l", group = "Lazy/LSP 工具" },
        { "<leader>s", group = "分屏操作" },
        { "<leader>u", group = "界面/工具开关" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "显示当前文件快捷键",
      },
    },
  },
  {
    -- lualine 是底部状态栏：显示当前文件、模式、Git 分支、诊断等信息。
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        -- 全局状态栏让底部只显示一条状态信息，更清爽。
        theme = "tokyonight",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
    },
  },
}
