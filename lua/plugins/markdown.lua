return {
  {
    -- 在 Neovim 里直接把 Markdown 标题、列表、代码块等渲染得更接近阅读效果。
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    cmd = "RenderMarkdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "切换 Markdown 内嵌渲染" },
      { "<leader>ms", "<cmd>RenderMarkdown preview<cr>", desc = "打开 Markdown 侧边预览" },
    },
  },
  {
    -- 用浏览器实时预览 Markdown，适合检查最终排版、Mermaid、公式和图片。
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = function(plugin)
      local npm = vim.fn.has("win32") == 1 and "npm.cmd" or "npm"
      if vim.fn.executable(npm) == 0 then
        vim.notify(
          "markdown-preview.nvim 需要 npm 来安装浏览器预览依赖。",
          vim.log.levels.WARN,
          { title = "缺少 npm" }
        )
        return
      end

      local result = vim.system({ npm, "install" }, {
        cwd = plugin.dir .. "/app",
        text = true,
      }):wait()

      if result.code ~= 0 then
        error(result.stderr ~= "" and result.stderr or result.stdout)
      end
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "切换 Markdown 浏览器预览" },
    },
  },
}
