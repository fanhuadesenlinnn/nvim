return {
  -- 主题：LazyVim 默认风格的 TokyoNight Moon。
  { import = "plugins.colorscheme" },
  -- 补全：输入代码时弹出候选项。
  { import = "plugins.completion" },
  -- 文件树：左侧目录浏览。
  { import = "plugins.filetree" },
  -- 搜索：查找文件、全文搜索、帮助文档。
  { import = "plugins.telescope" },
  -- 跳转：在屏幕内快速跳到目标位置。
  { import = "plugins.motion" },
  -- LSP：代码跳转、诊断、重命名等语言能力。
  { import = "plugins.lsp" },
  -- 语法：更准确的高亮和缩进。
  { import = "plugins.treesitter" },
  -- 界面：启动页、快捷键提示、状态栏。
  { import = "plugins.ui" },
}
