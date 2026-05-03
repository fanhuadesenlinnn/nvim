return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 250,
      spec = {
        { "<leader>b", group = "buffers" },
        { "<leader>f", group = "find" },
        { "<leader>l", group = "lazy/lsp" },
        { "<leader>s", group = "splits" },
        { "<leader>u", group = "ui/tools" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
    },
  },
}
