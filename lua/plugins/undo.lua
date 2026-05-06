return {
  {
    -- undotree 会把撤销历史画成树，方便你回到某个历史版本。
    -- 它不是替代 u / <C-r>，而是给撤销历史一个可视化面板。
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "打开/关闭撤销历史树" },
    },
    init = function()
      -- 面板宽度。觉得窄可以调大，觉得占空间可以调小。
      vim.g.undotree_SplitWidth = 32
      -- true 表示撤销树放在右侧，和左侧 nvim-tree 文件树分开。
      vim.g.undotree_SetFocusWhenToggle = true
      vim.g.undotree_WindowLayout = 2
      -- 显示帮助行，新手更容易知道面板里能按什么键。
      vim.g.undotree_HelpLine = true
    end,
  },
}
