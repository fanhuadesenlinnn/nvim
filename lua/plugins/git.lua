return {
  {
    -- gitsigns.nvim 会在左侧符号列显示 Git 增删改状态，并提供预览、暂存、撤销等 hunk 操作。
    -- hunk 可以理解成“一小块连续的 Git 改动”。
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 600,
      },
      preview_config = {
        border = "rounded",
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- 在 Git 改动块之间跳转。这里使用 [g/]g，避免和诊断跳转 [d/]d 冲突。
        map("n", "]g", function()
          gitsigns.nav_hunk("next")
        end, "下一个 Git 改动块")
        map("n", "[g", function()
          gitsigns.nav_hunk("prev")
        end, "上一个 Git 改动块")

        -- 当前 hunk 操作：适合逐块检查、暂存或撤销改动。
        map("n", "<leader>gs", gitsigns.stage_hunk, "暂存当前 Git 改动块")
        map("n", "<leader>gr", gitsigns.reset_hunk, "撤销当前 Git 改动块")
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "暂存选中 Git 改动")
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "撤销选中 Git 改动")

        map("n", "<leader>gS", gitsigns.stage_buffer, "暂存当前文件全部改动")
        map("n", "<leader>gR", gitsigns.reset_buffer, "撤销当前文件全部改动")
        map("n", "<leader>gu", gitsigns.undo_stage_hunk, "取消暂存当前 Git 改动块")
        map("n", "<leader>gp", gitsigns.preview_hunk, "预览当前 Git 改动块")
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "查看当前行 Git 责任信息")
        map("n", "<leader>gd", gitsigns.diffthis, "查看当前文件 Git 差异")
        map("n", "<leader>gw", gitsigns.toggle_word_diff, "切换词级 Git 差异")
      end,
    },
  },
}
