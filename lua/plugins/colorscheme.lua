local function apply_tokyonight()
  vim.o.background = "dark"
  require("tokyonight").setup({
    style = "moon",
    terminal_colors = true,
    styles = {
      sidebars = "dark",
      floats = "dark",
    },
    plugins = {
      auto = true,
    },
  })

  require("tokyonight").load()
end

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      apply_tokyonight()
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      integrations = {
        blink_cmp = true,
        flash = true,
        mason = true,
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      update_interval = 3000,
      fallback = "dark",
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        apply_tokyonight()
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        apply_tokyonight()
      end,
    },
  },
}
