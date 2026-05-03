local keymap = vim.keymap.set

keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
keymap("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

keymap("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

keymap("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
keymap("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

keymap("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
keymap("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Open Mason" })
keymap("n", "<leader>uh", "<cmd>checkhealth<cr>", { desc = "Check health" })
keymap("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })
keymap("n", "<leader>un", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative number" })

keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })
keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
