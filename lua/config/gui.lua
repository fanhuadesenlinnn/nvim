if not vim.g.neovide then
  return
end

vim.o.guifont = "JetBrainsMono Nerd Font Mono:h15"

vim.g.neovide_scale_factor = 1.0
vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.1
vim.g.neovide_pixel_geometry = "RGBH"
vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_left = 8
vim.g.neovide_padding_right = 8

vim.g.neovide_opacity = 0.95
vim.g.neovide_normal_opacity = 0.95
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_corner_radius = 0.15

vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_short_animation_length = 0.03
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_scroll_animation_far_lines = 1

vim.g.neovide_refresh_rate = 120
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_no_idle = false
vim.g.neovide_remember_window_size = true
vim.g.neovide_theme = "auto"

vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_confirm_quit = true
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_message_area_drag_selection = false
vim.g.neovide_input_macos_option_key_is_meta = "only_left"
vim.g.neovide_highlight_matching_pair = true
vim.g.neovide_proxy_icon = true

-- 较新的 Neovide 可以在可用时使用 Neovim 的鼠标网格检测能力。
if vim.fn.has("nvim-0.12") == 1 then
  vim.g.neovide_has_mouse_grid_detection = true
end

local function set_ime(args)
  vim.g.neovide_input_ime = args.event:match("Enter$") ~= nil
end

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CmdlineEnter", "CmdlineLeave" }, {
  group = vim.api.nvim_create_augroup("neovide_ime", { clear = true }),
  pattern = "*",
  callback = set_ime,
})

vim.keymap.set({ "n", "v" }, "<D-s>", "<cmd>write<cr>", { desc = "Write file" })
vim.keymap.set({ "n", "v" }, "<D-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" })
