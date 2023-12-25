-- 安装加载lazy
local lazypath = vim.fn.stdpath("config") .. "/lazy/"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct




require("lazy").setup({
  -- 主题
  {"folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  { "folke/which-key.nvim", lazy = true },

  -- 文件树
  {"nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require('neo-tree').setup({
        source_selector = {
	  winbar = true,
	  statusline = true
        }
      })
    end,
    keys = {
      { "<leader>e", '<cmd>Neotree<cr>'},
    },

  },


  -- 自动扩展当前窗口的宽度,最大化并恢复当前窗口。
  {"anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
       vim.o.winwidth = 10
       vim.o.winminwidth = 10
       vim.o.equalalways = false
       require('windows').setup()
    end
  },


  -- 选择窗口
  {'numToStr/Navigator.nvim',
    config = function()
      require('Navigator').setup()
    end,
    keys = {
      {'<C-h>', '<CMD>NavigatorLeft<CR>'},
      {'<C-l>', '<CMD>NavigatorRight<CR>'},
      {'<C-k>', '<CMD>NavigatorUp<CR>'},
      {'<C-j>', '<CMD>NavigatorDown<CR>'},
      {'<C-p>', '<CMD>NavigatorPrevious<CR>'},
    },
  },



  -- -- 智能补全
  -- {'ZhiyuanLck/smart-pairs',
  --   event = 'InsertEnter',
  --   config = function()
  --     require('pairs').setup()
  --   end
  -- },


  -- 状态栏
  {"nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup()
    end,
  },


  -- 自动保存
  {
     "https://git.sr.ht/~nedia/auto-save.nvim",
     event = { "BufReadPre" },
     opts = {
       events = { 'InsertLeave', 'BufLeave' },
       silent = false,
       exclude_ft = { 'neo-tree' },
     },
  },


  -- 预览行
  {'nacro90/numb.nvim',
    config = function ()
      require('numb').setup()
    end
  },


  -- 高亮
  {'yamatsum/nvim-cursorline',
    cursorline = {
      enable = true,
      timeout = 10,
      number = true,
    },
    cursorword = {
      enable = true,
      min_length = 3,
      hl = { underline = true },
    },
    config = function ()
      require('nvim-cursorline').setup()
    end,
  },


  -- 九头蛇
  {"anuvyklack/hydra.nvim",

  },


  -- 多路复用tab
  {"nanozuki/tabby.nvim",
    config = function()
      require('tabby').setup()
    end

  },

  -- 可视化缩进
  { 'echasnovski/mini.indentscope',
    version = '*',
    config = function()
      require('mini.indentscope').setup()
    end
  },


  -- -- 高亮
  -- {"shellRaining/hlchunk.nvim",
  --   event = { "UIEnter" },
  --   config = function()
  --     require("hlchunk").setup({
  --       indent = {
  --         chars = { "│", "¦", "┆", "┊", }, -- more code can be found in https://unicodeplus.com/
  --         style = {
  --             "#8B00FF",
  --         },
  --       },
  --       blank = {
  --           enable = false,
  --       },
  --   })
  --   end
  -- },


  -- 自动tab

  -- -- 高度实验性的插件，完全取代了消息、cmdline 和弹出菜单的 UI。
  -- {"folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  -- },


  -- 搜索
  {"FabianWirth/search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require('search').setup()
    end,
  },


  -- 寄存器交互
  {"tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    config = function()
      require('registers').setup()
    end,
  },


  -- lsp-显示错误
  {"chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { useDefaultKeymaps = true },
  },


  -- lsp
  {"williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
          }
        }
      })
    end,
  },


  -- lsp 快速浏览
  {'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },


  -- 实时预览命令
  {"smjonas/live-command.nvim",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },


  -- 移动 复制
  {'booperlv/nvim-gomove',

  },


  -- 去除空白
  {"mcauley-penney/tidy.nvim",
    config = true,
  },

  -- 跳转
  {"folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

})
