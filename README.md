# 个人 Neovim 配置

这是一套基于 `lazy.nvim` 管理插件的 Neovim 配置，目标是同时适合终端 Neovim 和 Neovide 使用。

## 目录结构

- `init.lua`：启动入口，按顺序加载配置。
- `lua/config/options.lua`：通用编辑器选项，终端和 Neovide 都会使用。
- `lua/config/keymaps.lua`：通用快捷键。
- `lua/config/gui.lua`：只在 Neovide 中生效的图形界面配置。
- `lua/config/health.lua`：启动后检查常见依赖，缺少工具时给出安装提示。
- `lua/config/plugins.lua`：插件开关总表；想关闭一组插件，注释一行 `import` 即可。
- `lua/plugins/*.lua`：每类插件一个文件，方便阅读和修改。
- `neovide/config.toml`：Neovide 应用级配置。

## 启动页

启动时会显示 LazyVim 风格的友好首页，由 `folke/snacks.nvim` 提供。

首页里可以直接按键：

- `p`：查找文件
- `n`：新建文件
- `g`：全文搜索
- `r`：最近文件
- `c`：编辑 Neovim 配置
- `l`：打开 Lazy 插件管理器
- `q`：退出

## 主要插件

- 补全：`saghen/blink.cmp`
- 文件树：`nvim-tree/nvim-tree.lua`
- 模糊查找：`nvim-telescope/telescope.nvim`
- 光标跳转：自定义 `f` 可见区字符跳转 + `folke/flash.nvim`
- 多光标编辑：`mg979/vim-visual-multi`
- 撤销历史树：`mbbill/undotree`
- 终端：`akinsho/toggleterm.nvim`
- Git 行内状态：`lewis6991/gitsigns.nvim`
- 启动页/通知/输入框：`folke/snacks.nvim`
- 快捷键提示：`folke/which-key.nvim`
- 主题：`folke/tokyonight.nvim`
- LSP 基础：`mason.nvim`、`mason-lspconfig.nvim`、`nvim-lspconfig`
- 语法高亮：`nvim-treesitter/nvim-treesitter`

## 主题

主题固定为 LazyVim 默认风格的 TokyoNight Moon：

- Neovim 使用 `tokyonight-moon`。
- 主题通过 `require("tokyonight").load()` 加载，贴近 LazyVim 默认方式。
- `auto-dark-mode.nvim` 保留但默认禁用，避免偏离 LazyVim 默认暗色主题。
- Catppuccin 暂时只是备用主题，默认不会启用。

## 快捷键

`<Space>` 是 leader 键。按下 `<Space>` 后稍等一下，`which-key.nvim` 会弹出快捷键提示。

常用跳转：按 `f`，当前 tab 的所有可见窗口会变灰；再输入目标字符，所有相同字符会显示标签；最后输入标签即可跳转。

完整快捷键表见 `docs/keymaps.md`。

## 常用命令

Neovim 里的命令一般以 `:` 开头，例如 `:Lazy`、`:Mason`、`:TSInstall bash`。

常用命令和排查方法见 `docs/commands.md`，里面记录了插件管理、Treesitter parser 安装、LSP、文件树、Telescope 等命令的用途。

## 依赖提示

配置启动后会检查常见工具：

- `git`：安装和更新插件需要。
- `rg`：Telescope 全文搜索需要。
- C 编译器：Treesitter 安装语法解析器时常用。
- Linux 剪贴板工具：终端复制粘贴可能需要 `wl-clipboard` 或 `xclip`。

缺少工具时，Neovim 会给出 macOS、Ubuntu/Debian、Fedora 的安装提示。

## Treesitter

这套配置使用 `nvim-treesitter` 的 `main` 分支，更适合 Neovim 0.12 之后的新版本。

新版 Treesitter 需要 `tree-sitter` 命令行工具：

```sh
brew install tree-sitter-cli
```

Linux 发行版里一般叫 `tree-sitter-cli`。缺少时启动后会提示安装命令。

高亮启用方式使用 Neovim 原生 `vim.treesitter.start()`；临时脚本、Scratch 代码 buffer 会优先按 filetype 启用，高亮缺失时再按文件后缀推断，例如 `.sh` 使用 bash parser、`.lua` 使用 lua parser。启动页、插件面板、Telescope 预览窗口和超大文件会自动跳过，避免工具窗口触发 parser 报错。

更新 Treesitter 和 parser 时运行：

```vim
:Lazy update nvim-treesitter
```

如果某个语言没有 Treesitter 高亮，例如 bash/sh 文件，可以运行：

```vim
:TSInstall bash
```

如果刚修改了配置里的 parser 列表，可以运行：

```vim
:Lazy build nvim-treesitter
```

更多命令说明见 `docs/commands.md`。

## 关闭某组插件

编辑 `lua/config/plugins.lua`，注释对应一行即可，例如关闭文件树：

```lua
-- { import = "plugins.filetree" },
```

## 第一次启动

第一次启动会自动安装 `lazy.nvim` 和插件。安装完成后，可以运行：

```vim
:Lazy
```

查看插件状态，或运行：

```vim
:checkhealth
```

检查 Neovim 环境是否健康。
