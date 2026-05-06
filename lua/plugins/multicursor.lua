return {
  {
    -- vim-visual-multi 是经典多光标插件，适合批量改相同单词、列编辑、给多行同时插入内容。
    -- 它有自己的交互模式：进入多光标后，可以用 i/a/c 等常见编辑命令同时修改多个位置。
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      -- 保留插件默认快捷键，和很多教程保持一致，学习成本更低。
      vim.g.VM_default_mappings = 1
      vim.g.VM_mouse_mappings = 1

      -- 这些名字是 vim-visual-multi 官方支持的映射项。
      -- 想换键位时，只改右侧字符串即可。
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select Cursor Down"] = "<C-Down>",
        ["Select Cursor Up"] = "<C-Up>",
      }
    end,
  },
}
