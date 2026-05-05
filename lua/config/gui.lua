if not vim.g.neovide then
  return
end

-- 这个文件只在 Neovide 中生效。
-- 终端 Neovim 不会执行下面的设置，所以可以放心使用 Neovide 专属功能。
local system = (vim.uv or vim.loop).os_uname().sysname

-- 字体只影响 Neovide。没有安装这个字体时，Neovide 会回退到系统默认字体。
-- 想换字体，通常只改这里的字体名和 h 后面的字号。
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h15"

-- 缩放和文字渲染。scale_factor 可以临时调大/调小整体界面。
vim.g.neovide_scale_factor = 1.0
vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.1
vim.g.neovide_pixel_geometry = "RGBH"

-- 窗口内边距。喜欢内容贴边可以调小，喜欢留白可以调大。
vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_left = 8
vim.g.neovide_padding_right = 8

-- 透明、模糊和浮动窗口阴影是 Neovide 的图形界面体验增强。
-- 如果在老机器上觉得卡，可以优先把 window_blurred 改成 false。
vim.g.neovide_opacity = 0.95
vim.g.neovide_normal_opacity = 0.95
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_corner_radius = 0.15

-- LazyVim 默认不额外改 Neovide 光标动画；这里显式使用 Neovide 官方默认值。
vim.g.neovide_cursor_animation_length = 0.150
vim.g.neovide_cursor_short_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 1.0
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_smooth_blink = false
-- LazyVim 默认不会在 Neovide 中打开粒子特效；空字符串表示关闭气泡、鱼雷等粒子效果。
vim.g.neovide_cursor_vfx_mode = ""

-- 滚动动画。数值越小滚动越干脆，越大越柔和。
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_scroll_animation_far_lines = 1

-- 刷新率：前台尽量流畅，空闲时降到较低刷新率省电。
vim.g.neovide_refresh_rate = 120
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_no_idle = false
vim.g.neovide_remember_window_size = true
vim.g.neovide_theme = "auto"

-- 一些更贴近日常桌面应用的行为：输入时隐藏鼠标、退出前确认等。
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_confirm_quit = true
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_message_area_drag_selection = false
vim.g.neovide_highlight_matching_pair = true
vim.g.neovide_proxy_icon = true

-- 这个设置只对 macOS 有意义：左 Option 当作 Meta，右 Option 仍可输入特殊字符。
if system == "Darwin" then
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end

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
