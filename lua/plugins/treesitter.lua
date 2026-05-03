return {
  {
    -- Treesitter 提供更准确的语法高亮和缩进，比传统正则高亮更聪明。
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      -- 这里列出常用语言；以后需要别的语言，往这个列表里加名字即可。
      ensure_installed = {
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
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
