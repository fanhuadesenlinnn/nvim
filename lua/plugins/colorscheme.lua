local function apply_tokyonight(background)
  background = background or vim.o.background

  require("tokyonight").setup({
    style = background == "light" and "day" or "moon",
    light_style = "day",
    terminal_colors = true,
    styles = {
      sidebars = background == "light" and "light" or "dark",
      floats = background == "light" and "light" or "dark",
    },
    plugins = {
      auto = true,
    },
  })

  vim.cmd.colorscheme("tokyonight")
end

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      apply_tokyonight()

      vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("user_theme", { clear = true }),
        pattern = "background",
        callback = function()
          apply_tokyonight(vim.v.option_new)
        end,
      })
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
    event = "VeryLazy",
    opts = {
      update_interval = 3000,
      fallback = "dark",
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        apply_tokyonight("dark")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        apply_tokyonight("light")
      end,
    },
  },
}
