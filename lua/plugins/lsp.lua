return {
  {
    -- Mason 用来安装/管理语言服务器等外部工具，适合新手少手动折腾环境。
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- 先安装 Lua 语言服务器，方便编辑这套 Neovim 配置本身。
      ensure_installed = {
        "lua_ls",
      },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      if vim.lsp and vim.lsp.config then
        -- 让 lua_ls 认识全局变量 vim，否则编辑配置时会误报 vim 未定义。
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        })
      end

      -- 诊断就是 LSP 给出的错误/警告提示。
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          prefix = "●",
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(event)
          -- 这些快捷键只在 LSP 成功附加到当前文件后才生效。
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
          map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
          map("n", "gr", vim.lsp.buf.references, "查找引用")
          map("n", "gi", vim.lsp.buf.implementation, "跳转到实现")
          map("n", "K", vim.lsp.buf.hover, "查看悬浮文档")
          map("n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "代码操作")
          map("n", "<leader>fd", vim.diagnostic.open_float, "查看本行诊断")
          map("n", "[d", vim.diagnostic.goto_prev, "上一个诊断")
          map("n", "]d", vim.diagnostic.goto_next, "下一个诊断")
        end,
      })
    end,
  },
}
