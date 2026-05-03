local function apply_tokyonight()
  -- LazyVim 默认使用 TokyoNight Moon，这里固定暗色，避免新手被系统主题切换影响。
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

  -- 使用 TokyoNight 官方推荐的 load 入口，和 LazyVim 默认主题加载方式保持一致。
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
    -- Catppuccin 暂时不启用，只作为以后想换主题时的备选。
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
    -- 保留自动明暗插件，但默认关闭，避免偏离 LazyVim 的默认暗色主题。
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
