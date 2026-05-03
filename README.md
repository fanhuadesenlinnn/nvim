# Personal Neovim Config

This config uses `lazy.nvim` as the plugin manager and keeps plugin groups in small modules.

## Layout

- `init.lua` loads the config in a predictable order.
- `lua/config/options.lua` contains editor options shared by terminal Neovim and Neovide.
- `lua/config/gui.lua` is only active when `vim.g.neovide` is set.
- `lua/config/plugins.lua` is the plugin switchboard. Comment one import line to disable a whole feature group.
- `lua/plugins/*.lua` contains one focused plugin group per file.
- `neovide/config.toml` contains Neovide app-level settings that do not belong in `init.lua`.

## Main Plugins

- Completion: `saghen/blink.cmp`
- File tree: `nvim-tree/nvim-tree.lua`
- Fuzzy finder: `nvim-telescope/telescope.nvim`
- Cursor jump: `folke/flash.nvim`
- Key hints: `folke/which-key.nvim`
- Auto light/dark switching: `f-person/auto-dark-mode.nvim`
- LSP basics: `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig`
- Syntax: `nvim-treesitter/nvim-treesitter`

## Theme

The theme is fixed to TokyoNight Moon for a stable dark appearance:

- Neovim uses `tokyonight-moon`.
- `auto-dark-mode.nvim` is installed but disabled, so the editor does not change when the operating system appearance changes.

Catppuccin is included as a LazyVim-compatible optional theme, but TokyoNight is the active default.

## Keymaps

The leader key is `<Space>`. Press `<Space>` and wait briefly to see key hints from `which-key.nvim`.

See `docs/keymaps.md` for the full keymap table.

## Disable A Feature

Edit `lua/config/plugins.lua` and comment one import:

```lua
-- { import = "plugins.filetree" },
```

## Notes

The first launch bootstraps `lazy.nvim`, installs plugins, and creates a lockfile. Run `:Lazy` to inspect, update, or sync plugins.
