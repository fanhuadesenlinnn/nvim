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
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- 先加载 nvim-tree 默认快捷键，保留熟悉的目录树操作。
        api.config.mappings.default_on_attach(bufnr)

        -- nvim-tree 默认用 f/F 做实时筛选；这里删除它们，避免和全局 f 跳转冲突。
        pcall(vim.keymap.del, "n", "f", { buffer = bufnr })
        pcall(vim.keymap.del, "n", "F", { buffer = bufnr })

        local function opts(desc)
          return { desc = "文件树: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- 用 / 做目录树筛选，和多数编辑器/命令行里的“搜索”直觉一致。
        vim.keymap.set("n", "/", api.filter.live.start, opts("开始筛选"))
        vim.keymap.set("n", "<Esc>", api.filter.live.clear, opts("清除筛选"))
      end,
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
