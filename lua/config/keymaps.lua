local keymap = vim.keymap.set

-- 清除搜索高亮；搜索后觉得满屏高亮碍眼时按 Esc 即可。
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })
keymap("n", "<leader>w", "<cmd>write<cr>", { desc = "保存文件" })
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "关闭当前窗口" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "退出 Neovim" })

-- 在分屏之间移动光标，方向对应 h/j/k/l。
keymap("n", "<C-h>", "<C-w>h", { desc = "切到左侧窗口" })
keymap("n", "<C-j>", "<C-w>j", { desc = "切到下方窗口" })
keymap("n", "<C-k>", "<C-w>k", { desc = "切到上方窗口" })
keymap("n", "<C-l>", "<C-w>l", { desc = "切到右侧窗口" })

-- 已打开文件：Neovim 里常叫 buffer，可以理解成“正在内存中打开的文件”。
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "上一个已打开文件" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "下一个已打开文件" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "关闭当前已打开文件" })

-- 分屏操作：v 是 vertical 垂直分屏，h 是 horizontal 水平分屏。
keymap("n", "<leader>sv", "<C-w>v", { desc = "垂直分屏" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "水平分屏" })
keymap("n", "<leader>se", "<C-w>=", { desc = "平均分配分屏大小" })
keymap("n", "<leader>sx", "<cmd>close<cr>", { desc = "关闭当前分屏" })

-- 常用管理工具：Lazy 管插件，Mason 管 LSP/格式化等外部工具。
keymap("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "打开 Lazy 插件管理器" })
keymap("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "打开 Mason 工具管理器" })
keymap("n", "<leader>uh", "<cmd>checkhealth<cr>", { desc = "检查 Neovim 健康状态" })
keymap("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "切换自动换行" })
keymap("n", "<leader>un", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "切换相对行号" })

-- 可视模式下缩进或移动选区后，继续保持选中状态，方便连续操作。
keymap("v", "<", "<gv", { desc = "左缩进并保持选中" })
keymap("v", ">", ">gv", { desc = "右缩进并保持选中" })
keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "选中内容下移" })
keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "选中内容上移" })
