return {
  {
    -- bufferline.nvim 会在顶部显示已打开文件列表，效果接近 LazyVim 默认的“文件标签栏”。
    -- 注意：Neovim 的 tab 和 buffer 不是一回事；这里显示的是 buffer，也就是已打开文件。
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "选择一个已打开文件" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "选择并关闭一个已打开文件" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "固定/取消固定当前文件" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "关闭所有未固定文件" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "关闭其他已打开文件" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "关闭右侧已打开文件" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧已打开文件" },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "thin",
        indicator = {
          style = "underline",
        },
        -- nvim-tree 打开时，顶部标签栏会为左侧文件树留出空位，视觉上更整齐。
        offsets = {
          {
            filetype = "NvimTree",
            text = "文件树",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
        diagnostics_indicator = function(_, _, diagnostics)
          local result = {}
          if diagnostics.error then
            table.insert(result, "E" .. diagnostics.error)
          end
          if diagnostics.warning then
            table.insert(result, "W" .. diagnostics.warning)
          end
          return table.concat(result, " ")
        end,
      },
    },
  },
}
