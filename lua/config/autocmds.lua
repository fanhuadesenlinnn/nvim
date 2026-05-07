local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- 复制文字后短暂高亮一下刚复制的范围，确认自己复制对了。
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- 重新打开文件时回到上次离开的位置；读长文件时很有用。
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 当窗口重新获得焦点、切换 buffer 或短暂停顿时，检查文件是否被外部程序修改。
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = group,
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function(event)
    vim.notify(vim.fn.fnamemodify(event.file, ":t") .. " 已从磁盘重新加载", vim.log.levels.INFO)
  end,
})
