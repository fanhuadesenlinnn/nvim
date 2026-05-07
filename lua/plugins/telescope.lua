return {
  {
    -- Telescope 是社区非常流行的模糊查找插件，用来找文件、搜文本、查帮助。
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    -- 只有执行 :Telescope 或按下面这些快捷键时才加载。
    cmd = "Telescope",
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
      {
        "<leader>fg",
        function()
          -- live_grep 依赖 ripgrep；这里提前提示安装方式，比直接报错更友好。
          if vim.fn.executable("rg") == 0 then
            vim.notify("全文搜索需要 ripgrep。\nmacOS: brew install ripgrep\nUbuntu/Debian: sudo apt install ripgrep\nArch Linux: sudo pacman -S ripgrep\nWindows: winget install --id BurntSushi.ripgrep.MSVC -e", vim.log.levels.WARN, { title = "缺少 rg" })
            return
          end
          require("telescope.builtin").live_grep()
        end,
        desc = "全文搜索",
      },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "查找已打开文件" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "查找帮助文档" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "查找最近文件" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        -- 没有 make 时跳过原生加速扩展，Telescope 本体仍然可以使用。
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = {
      -- Telescope 是“搜索/选择器”，常用来找文件、找文字、找帮助。
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "> ",
        path_display = { "smart" },
        sorting_strategy = "ascending",
        -- Telescope 预览窗口是临时工具窗口，不是真正进入编辑的代码页面。
        -- 这里关闭预览器内部 Treesitter，避免旧版 Telescope 调用 Neovim 0.12 已移除的接口。
        preview = {
          treesitter = {
            enable = false,
          },
        },
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          -- true 表示查找文件时也显示隐藏文件，例如 .gitignore、.env。
          hidden = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- fzf-native 是可选加速扩展；缺失时 pcall 会静默跳过。
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
