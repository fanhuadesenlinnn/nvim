# 常用命令说明

这些命令都在 Neovim 里输入。先按 `:` 进入命令模式，再输入命令并回车。

## 插件管理

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:Lazy` | 想查看插件状态时 | 打开 lazy.nvim 插件管理器，可以看到插件是否安装、是否有更新。 |
| `:Lazy sync` | 第一次装好配置，或换电脑同步配置后 | 安装缺失插件、更新已有插件，并清理不用的插件。 |
| `:Lazy update` | 想更新全部插件时 | 更新所有插件。更新前建议确认网络能访问 GitHub。 |
| `:Lazy update nvim-treesitter` | 只想更新 Treesitter 插件时 | 只更新 `nvim-treesitter` 本体，不动其他插件。 |
| `:Lazy build nvim-treesitter` | 新增 parser 列表后，或者语法高亮缺失时 | 重新执行 Treesitter 的安装步骤，把配置里列出的 parser 装好。 |
| `:Lazy clean` | 删除已经从配置里移除的插件时 | 清理不再使用的插件目录。 |

## Treesitter 语法高亮

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:TSInstall bash` | bash、sh 文件没有 Treesitter 高亮时 | 只安装 bash parser。其他语言也可以替换命令最后的名字，例如 `:TSInstall lua`。 |
| `:TSInstall python lua bash` | 想一次安装几个 parser 时 | 一次安装多个 parser，名字之间用空格隔开。 |
| `:TSUpdate bash` | 某个 parser 旧了或表现异常时 | 只更新 bash parser。 |
| `:TSUpdate` | 想更新所有已安装 parser 时 | 更新已经安装过的 parser。 |
| `:TSLog` | parser 安装失败时 | 查看 Treesitter 安装、更新日志，方便判断是网络、编译器还是 parser 问题。 |
| `:InspectTree` | 想确认当前文件有没有语法树时 | 打开当前 buffer 的语法树视图，适合排查 Treesitter 是否真的生效。 |
| `:Inspect` | 想看光标位置的高亮来源时 | 查看当前光标处的高亮组和来源。 |

如果提示找不到 `tree-sitter` 命令，说明缺少 Treesitter 编译工具：

```sh
brew install tree-sitter-cli
```

Linux 里通常安装系统包 `tree-sitter-cli`，不同发行版包名可能略有差异。

## LSP 和外部工具

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:Mason` | 想安装语言服务器、格式化工具、调试工具时 | 打开 Mason 管理界面。 |
| `:LspInfo` | 当前文件补全、跳转、诊断不工作时 | 查看当前 buffer 是否连接了 LSP。 |
| `:checkhealth` | 新机器、配置异常、依赖缺失时 | 检查 Neovim、插件、外部工具的健康状态。 |

## 文件树

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:NvimTreeToggle` | 想打开或关闭左侧目录树时 | 和快捷键 `<Space>e` 类似。 |
| `:NvimTreeFindFile` | 想在目录树里定位当前文件时 | 和快捷键 `<Space>E` 类似。 |
| `:NvimTreeRefresh` | 文件树显示和磁盘不一致时 | 刷新目录树。 |

## Telescope 搜索

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:Telescope find_files` | 查找项目文件 | 和快捷键 `<Space>ff` 类似。 |
| `:Telescope live_grep` | 全文搜索项目内容 | 和快捷键 `<Space>fg` 类似，需要安装 `rg`。 |
| `:Telescope buffers` | 在已打开 buffer 中切换 | 和快捷键 `<Space>fb` 类似。 |
| `:Telescope help_tags` | 查找 Neovim 帮助文档 | 和快捷键 `<Space>fh` 类似。 |
| `:Telescope oldfiles` | 查找最近打开过的文件 | 和快捷键 `<Space>fr` 类似。 |

## 终端

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:ToggleTerm direction=float` | 想打开浮动终端时 | 和快捷键 `<Space>tt` 类似。 |
| `:ToggleTerm size=15 direction=horizontal` | 想打开下方横向终端时 | 和快捷键 `<Space>th` 类似。 |
| `:ToggleTerm size=80 direction=vertical` | 想打开右侧纵向终端时 | 和快捷键 `<Space>tv` 类似。 |
| `:TermNew direction=float` | 想新开一个独立终端时 | 和快捷键 `<Space>tn` 类似。 |
| `:TermSelect` | 已经开了多个终端，想选择其中一个时 | 和快捷键 `<Space>ts` 类似。 |
| `:ToggleTermToggleAll` | 想一次打开或隐藏所有 toggleterm 终端时 | 适合同时管理多个长期运行的终端任务。 |
| `:TermExec cmd="git status"` | 想在终端里执行一次命令时 | 会把命令发送到 toggleterm 终端中执行。 |

## Git

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:Gitsigns preview_hunk` | 想看当前 Git 改动块改了什么时 | 和快捷键 `<Space>gp` 类似。 |
| `:Gitsigns stage_hunk` | 想暂存当前 Git 改动块时 | 和快捷键 `<Space>gs` 类似。 |
| `:Gitsigns reset_hunk` | 想撤销当前 Git 改动块时 | 和快捷键 `<Space>gr` 类似，执行前要确认改动不需要了。 |
| `:Gitsigns stage_buffer` | 想暂存当前文件全部改动时 | 和快捷键 `<Space>gS` 类似。 |
| `:Gitsigns reset_buffer` | 想撤销当前文件全部改动时 | 和快捷键 `<Space>gR` 类似，风险比 reset_hunk 更大。 |
| `:Gitsigns blame_line` | 想看当前行是谁、什么时候改的时 | 和快捷键 `<Space>gb` 类似。 |
| `:Gitsigns diffthis` | 想打开当前文件和 Git 版本的差异视图时 | 和快捷键 `<Space>gd` 类似。 |
| `:Gitsigns toggle_word_diff` | 想看一行里具体哪些词变了时 | 和快捷键 `<Space>gw` 类似。 |

## 多光标

`vim-visual-multi` 主要通过快捷键使用，常见入口是 `<C-n>`、`<C-Up>`、`<C-Down>`。

如果忘了多光标操作，可以查看帮助：

```vim
:help visual-multi
```

如果只是做简单列编辑，Neovim 自带可视块模式通常更稳定：

```text
<C-v>  进入可视块选择
I      在每行开头插入
A      在每行结尾追加
```

## 撤销历史

| 命令 | 什么时候用 | 说明 |
| --- | --- | --- |
| `:UndotreeToggle` | 想查看撤销历史树时 | 和快捷键 `<Space>uu` 类似。 |

普通撤销和重做仍然是 Neovim 自带命令：

```text
u      撤销
<C-r>  重做
```

## 常见排查顺序

遇到“插件、补全、高亮、搜索”不正常时，可以按这个顺序看：

1. `:checkhealth`
2. `:Lazy`
3. `:Mason`
4. `:LspInfo`
5. `:TSLog`

如果只是某种语言没有 Treesitter 高亮，优先运行：

```vim
:TSInstall 语言名
```

例如 shell 脚本：

```vim
:TSInstall bash
```

如果刚修改了 `lua/plugins/treesitter.lua` 里的 parser 列表，运行：

```vim
:Lazy build nvim-treesitter
```
