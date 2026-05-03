return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "打开/关闭文件树" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "在文件树中定位当前文件" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- 使用 nvim-tree 接管目录浏览，避免和 Neovim 自带 netrw 冲突。
      disable_netrw = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      view = {
        -- 文件树宽度可以按喜好调整，数字越大越宽。
        width = 34,
        side = "left",
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "name",
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
    },
  },
}
