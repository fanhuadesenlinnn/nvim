return {
  {
    -- toggleterm.nvim 是社区常用的终端管理插件，用来快速打开/隐藏一个或多个终端。
    -- 它比直接 :terminal 更顺手：可以固定浮动、横向、纵向布局，也能记住终端状态。
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = {
      "ToggleTerm",
      "ToggleTermToggleAll",
      "TermExec",
      "TermNew",
      "TermSelect",
      "ToggleTermSetName",
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "打开/关闭浮动终端" },
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "打开/关闭下方终端" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "打开/关闭右侧终端" },
      { "<leader>tn", "<cmd>TermNew direction=float<cr>", desc = "新建一个浮动终端" },
      { "<leader>ts", "<cmd>TermSelect<cr>", desc = "选择已有终端" },
    },
    opts = {
      -- size 会根据终端方向决定高度或宽度；横向终端是高度，纵向终端是宽度。
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        end
        if term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
        return 20
      end,
      direction = "float",
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      close_on_exit = true,
      shell = vim.o.shell,
      shade_terminals = true,
      float_opts = {
        border = "rounded",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
      highlights = {
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      on_open = function(term)
        local opts = { buffer = term.bufnr, silent = true }

        -- 终端打开后默认在 terminal 模式；按 Esc 回到普通模式，方便移动光标和切窗口。
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

        -- 在终端模式里也能用 Ctrl+h/j/k/l 切到其他分屏，和普通窗口操作保持一致。
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end,
    },
  },
}
