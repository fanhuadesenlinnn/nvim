local parsers = {
  "bash",
  "c",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

local filetypes = {
  "bash",
  "c",
  "json",
  "lua",
  "markdown",
  "python",
  "query",
  "sh",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

local function is_real_file(buf)
  return vim.bo[buf].buftype == ""
end

local function can_start(buf)
  if not is_real_file(buf) then
    return false
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return false
  end

  local max_filesize = 1024 * 1024
  local ok, stat = pcall(vim.uv.fs_stat, name)
  return not (ok and stat and stat.size > max_filesize)
end

local function start_treesitter(buf)
  if not can_start(buf) then
    return
  end

  -- vim.treesitter.start 是 Neovim 0.12 推荐的原生启用方式。
  -- pcall 可以避免某个语言 parser 暂时缺失时打断你打开文件。
  pcall(vim.treesitter.start, buf)
end

return {
  {
    -- nvim-treesitter 的 main 分支是 Neovim 0.12+ 的新版实现。
    -- master 分支已经冻结，继续用在 0.12 上容易出现 parser/runtime 不匹配。
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      if vim.fn.executable("tree-sitter") == 1 then
        require("nvim-treesitter").install(parsers):wait(300000)
      end
    end,
    opts = {
      ensure_installed = parsers,
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = opts.install_dir,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        pattern = filetypes,
        callback = function(event)
          start_treesitter(event.buf)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_indent", { clear = true }),
        pattern = filetypes,
        callback = function(event)
          if can_start(event.buf) then
            -- 缩进使用 Neovim 原生 treesitter indentexpr；特殊窗口和超大文件跳过。
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
