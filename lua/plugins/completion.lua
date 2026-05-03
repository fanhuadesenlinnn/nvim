return {
  {
    -- blink.cmp 是速度很快的补全插件，负责代码、路径、片段和 LSP 补全。
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        -- 默认预设比较接近常见编辑器体验，适合先上手再微调。
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-y>"] = { "select_and_accept" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
        menu = {
          border = "rounded",
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
      sources = {
        -- 补全来源：LSP 语义补全、文件路径、代码片段、当前 buffer 文字。
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      if vim.lsp and vim.lsp.config then
        -- 把 blink.cmp 的补全能力告诉 LSP，语言服务器才能返回更完整的候选项。
        vim.lsp.config("*", {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        })
      end
    end,
  },
}
