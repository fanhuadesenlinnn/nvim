local parsers = {
  -- 编辑器、文档和查询语言
  "comment",
  "query",
  "vim",
  "vimdoc",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "rst",
  "latex",
  "typst",
  "mermaid",

  -- Shell、脚本和常见命令行配置
  "awk",
  "astro",
  "bash",
  "fish",
  "powershell",
  "tmux",
  "zsh",

  -- Web 前端、模板和 API 文件
  "angular",
  "css",
  "scss",
  "html",
  "htmldjango",
  "javascript",
  "jsdoc",
  "typescript",
  "tsx",
  "vue",
  "svelte",
  "eex",
  "heex",
  "jinja",
  "blade",
  "pug",
  "templ",
  "graphql",
  "http",

  -- 通用数据格式、配置文件和基础设施
  "bicep",
  "caddy",
  "cmake",
  "csv",
  "cue",
  "desktop",
  "diff",
  "dockerfile",
  "dot",
  "editorconfig",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "hcl",
  "hjson",
  "hocon",
  "hyprlang",
  "ini",
  "jq",
  "json",
  "json5",
  "jsonnet",
  "just",
  "kdl",
  "kitty",
  "make",
  "meson",
  "nginx",
  "ninja",
  "nix",
  "pem",
  "prisma",
  "properties",
  "regex",
  "robots_txt",
  "ssh_config",
  "terraform",
  "toml",
  "tsv",
  "udev",
  "xresources",
  "xml",
  "yaml",

  -- 主流编程语言和生态文件
  "c",
  "c_sharp",
  "clojure",
  "cpp",
  "cuda",
  "dart",
  "elm",
  "elixir",
  "erlang",
  "fennel",
  "fortran",
  "fsharp",
  "gleam",
  "glsl",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "groovy",
  "haskell",
  "java",
  "julia",
  "kotlin",
  "luau",
  "matlab",
  "objc",
  "ocaml",
  "passwd",
  "perl",
  "php",
  "php_only",
  "phpdoc",
  "proto",
  "python",
  "r",
  "rego",
  "requirements",
  "ruby",
  "rust",
  "scala",
  "solidity",
  "sql",
  "starlark",
  "swift",
  "textproto",
  "thrift",
  "wgsl",
  "yuck",
  "zig",
}

local disabled_filetypes = {
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  lazy = true,
  mason = true,
  snacks_dashboard = true,
}

local disabled_buftypes = {
  help = true,
  prompt = true,
  quickfix = true,
  terminal = true,
}

local parser_set = {}
for _, parser in ipairs(parsers) do
  parser_set[parser] = true
end

-- Neovim 的 filetype 名字和 Treesitter parser 名字不总是一致。
-- 例如 shell 脚本的 filetype 常常是 sh，但 parser 名字是 bash；这里手动补齐这些常见别名。
local lang_by_filetype = {
  bzl = "starlark",
  cs = "c_sharp",
  dosini = "ini",
  eelixir = "eex",
  gitconfig = "git_config",
  gitrebase = "git_rebase",
  javascriptreact = "javascript",
  jsonc = "json",
  ps1 = "powershell",
  robots = "robots_txt",
  sh = "bash",
  sshconfig = "ssh_config",
  tex = "latex",
  typescriptreact = "tsx",
  xdefaults = "xresources",
}

-- 如果对应 parser 还没有安装，至少先打开 Vim 自带的语法高亮，避免 bash 这类文件完全没颜色。
local syntax_by_lang = {
  bash = "sh",
  c_sharp = "cs",
  git_config = "gitconfig",
  git_rebase = "gitrebase",
  javascript = "javascript",
  latex = "tex",
  powershell = "ps1",
  robots_txt = "robots",
  ssh_config = "sshconfig",
  starlark = "bzl",
  tsx = "typescriptreact",
  xresources = "xdefaults",
}

local missing_parser_notified = {}

-- 有些临时 buffer 不会正确设置 filetype，但 buffer 名字里仍然有后缀。
-- 这里按后缀明确指定 parser，让 Scratch 里的临时代码也能获得 Treesitter 高亮。
-- 这个列表覆盖常见编程语言、脚本、Web、数据格式和配置文件；后面想禁用某类语言时，
-- 可以直接从 parsers 和下面两个映射表里删掉对应项。
local lang_by_extension = {
  astro = "astro",
  awk = "awk",
  bash = "bash",
  bicep = "bicep",
  bzl = "starlark",
  c = "c",
  caddy = "caddy",
  cc = "cpp",
  cfg = "ini",
  clj = "clojure",
  cljc = "clojure",
  cljs = "clojure",
  cmake = "cmake",
  conf = "ini",
  cpp = "cpp",
  cs = "c_sharp",
  css = "css",
  csv = "csv",
  cu = "cuda",
  cue = "cue",
  cuh = "cuda",
  cxx = "cpp",
  dart = "dart",
  desktop = "desktop",
  diff = "diff",
  dockerfile = "dockerfile",
  dot = "dot",
  eex = "eex",
  edn = "clojure",
  elm = "elm",
  erl = "erlang",
  ex = "elixir",
  exs = "elixir",
  fennel = "fennel",
  fish = "fish",
  fnl = "fennel",
  frag = "glsl",
  fs = "fsharp",
  fsi = "fsharp",
  fsx = "fsharp",
  gleam = "gleam",
  glsl = "glsl",
  gql = "graphql",
  graphql = "graphql",
  go = "go",
  gradle = "groovy",
  groovy = "groovy",
  h = "c",
  hcl = "hcl",
  heex = "heex",
  hpp = "cpp",
  hrl = "erlang",
  hs = "haskell",
  htm = "html",
  html = "html",
  http = "http",
  hxx = "cpp",
  ini = "ini",
  java = "java",
  jinja = "jinja",
  jinja2 = "jinja",
  js = "javascript",
  json = "json",
  json5 = "json5",
  jsonc = "json",
  jsonnet = "jsonnet",
  jsx = "javascript",
  just = "just",
  jl = "julia",
  kdl = "kdl",
  kt = "kotlin",
  kts = "kotlin",
  libsonnet = "jsonnet",
  lua = "lua",
  luau = "luau",
  mjs = "javascript",
  ml = "ocaml",
  mli = "ocaml",
  md = "markdown",
  mdx = "markdown",
  markdown = "markdown",
  mat = "matlab",
  mermaid = "mermaid",
  mmd = "mermaid",
  mm = "objc",
  nginx = "nginx",
  ninja = "ninja",
  nix = "nix",
  p8 = "lua",
  patch = "diff",
  pbtxt = "textproto",
  pem = "pem",
  perl = "perl",
  php = "php",
  pl = "perl",
  pm = "perl",
  prisma = "prisma",
  proto = "proto",
  ps1 = "powershell",
  psd1 = "powershell",
  psm1 = "powershell",
  pug = "pug",
  py = "python",
  pyw = "python",
  query = "query",
  r = "r",
  rb = "ruby",
  rego = "rego",
  regex = "regex",
  rest = "http",
  rst = "rst",
  rs = "rust",
  sass = "scss",
  scala = "scala",
  sc = "scala",
  scm = "query",
  scss = "scss",
  sh = "bash",
  sol = "solidity",
  sql = "sql",
  star = "starlark",
  svelte = "svelte",
  swift = "swift",
  templ = "templ",
  tex = "latex",
  textproto = "textproto",
  tf = "terraform",
  tfvars = "terraform",
  thrift = "thrift",
  tmux = "tmux",
  toml = "toml",
  ts = "typescript",
  tsv = "tsv",
  tsx = "tsx",
  typ = "typst",
  vim = "vim",
  vert = "glsl",
  vue = "vue",
  wgsl = "wgsl",
  xml = "xml",
  yaml = "yaml",
  yml = "yaml",
  yuck = "yuck",
  zig = "zig",
  zsh = "zsh",
}

local filetype_by_extension = {
  astro = "astro",
  awk = "awk",
  bash = "bash",
  bicep = "bicep",
  bzl = "bzl",
  c = "c",
  caddy = "caddy",
  cc = "cpp",
  cfg = "ini",
  clj = "clojure",
  cljc = "clojure",
  cljs = "clojure",
  cmake = "cmake",
  conf = "ini",
  cpp = "cpp",
  cs = "cs",
  css = "css",
  csv = "csv",
  cu = "cuda",
  cue = "cue",
  cuh = "cuda",
  cxx = "cpp",
  dart = "dart",
  desktop = "desktop",
  diff = "diff",
  dockerfile = "dockerfile",
  dot = "dot",
  eex = "eelixir",
  edn = "clojure",
  elm = "elm",
  erl = "erlang",
  ex = "elixir",
  exs = "elixir",
  fennel = "fennel",
  fish = "fish",
  fnl = "fennel",
  frag = "glsl",
  fs = "fsharp",
  fsi = "fsharp",
  fsx = "fsharp",
  gleam = "gleam",
  glsl = "glsl",
  gql = "graphql",
  graphql = "graphql",
  go = "go",
  gradle = "groovy",
  groovy = "groovy",
  h = "c",
  hcl = "hcl",
  heex = "heex",
  hpp = "cpp",
  hrl = "erlang",
  hs = "haskell",
  htm = "html",
  html = "html",
  http = "http",
  hxx = "cpp",
  ini = "ini",
  java = "java",
  jinja = "jinja",
  jinja2 = "jinja",
  js = "javascript",
  json = "json",
  json5 = "json5",
  jsonc = "jsonc",
  jsonnet = "jsonnet",
  jsx = "javascriptreact",
  just = "just",
  jl = "julia",
  kdl = "kdl",
  kt = "kotlin",
  kts = "kotlin",
  libsonnet = "jsonnet",
  lua = "lua",
  luau = "luau",
  mjs = "javascript",
  ml = "ocaml",
  mli = "ocaml",
  md = "markdown",
  mdx = "markdown",
  markdown = "markdown",
  mat = "matlab",
  mermaid = "mermaid",
  mmd = "mermaid",
  mm = "objc",
  nginx = "nginx",
  ninja = "ninja",
  nix = "nix",
  p8 = "lua",
  patch = "diff",
  pbtxt = "textproto",
  pem = "pem",
  perl = "perl",
  php = "php",
  pl = "perl",
  pm = "perl",
  prisma = "prisma",
  proto = "proto",
  ps1 = "ps1",
  psd1 = "ps1",
  psm1 = "ps1",
  pug = "pug",
  py = "python",
  pyw = "python",
  query = "query",
  r = "r",
  rb = "ruby",
  rego = "rego",
  regex = "regex",
  rest = "http",
  rst = "rst",
  rs = "rust",
  sass = "scss",
  scala = "scala",
  sc = "scala",
  scm = "query",
  scss = "scss",
  sh = "sh",
  sol = "solidity",
  sql = "sql",
  star = "starlark",
  svelte = "svelte",
  swift = "swift",
  templ = "templ",
  tex = "tex",
  textproto = "textproto",
  tf = "terraform",
  tfvars = "terraform",
  thrift = "thrift",
  tmux = "tmux",
  toml = "toml",
  ts = "typescript",
  tsv = "tsv",
  tsx = "typescriptreact",
  typ = "typst",
  vim = "vim",
  vert = "glsl",
  vue = "vue",
  wgsl = "wgsl",
  xml = "xml",
  yaml = "yaml",
  yml = "yaml",
  yuck = "yuck",
  zig = "zig",
  zsh = "zsh",
}

-- 这类文件通常没有普通后缀，或者后缀太泛；按完整文件名判断更可靠。
local lang_by_filename = {
  [".bash_profile"] = "bash",
  [".bashrc"] = "bash",
  [".clang-format"] = "yaml",
  [".clang-tidy"] = "yaml",
  [".dockerignore"] = "gitignore",
  [".editorconfig"] = "editorconfig",
  [".env"] = "bash",
  [".gitattributes"] = "gitattributes",
  [".gitconfig"] = "git_config",
  [".gitignore"] = "gitignore",
  [".gitmodules"] = "git_config",
  [".profile"] = "bash",
  [".tmux.conf"] = "tmux",
  [".xdefaults"] = "xresources",
  [".xresources"] = "xresources",
  [".zprofile"] = "zsh",
  [".zshrc"] = "zsh",
  ["build.gradle"] = "groovy",
  ["caddyfile"] = "caddy",
  ["cmakelists.txt"] = "cmake",
  ["commit_editmsg"] = "gitcommit",
  ["containerfile"] = "dockerfile",
  ["dockerfile"] = "dockerfile",
  ["gemfile"] = "ruby",
  ["git-rebase-todo"] = "git_rebase",
  ["gnumakefile"] = "make",
  ["go.mod"] = "gomod",
  ["go.sum"] = "gosum",
  ["go.work"] = "gowork",
  ["gradle.properties"] = "properties",
  ["hyprland.conf"] = "hyprlang",
  ["justfile"] = "just",
  ["kitty.conf"] = "kitty",
  ["makefile"] = "make",
  ["meson.build"] = "meson",
  ["meson_options.txt"] = "meson",
  ["nginx.conf"] = "nginx",
  ["passwd"] = "passwd",
  ["podfile"] = "ruby",
  ["rakefile"] = "ruby",
  ["requirements.txt"] = "requirements",
  ["robots.txt"] = "robots_txt",
  ["settings.gradle"] = "groovy",
  ["ssh_config"] = "ssh_config",
  ["sshd_config"] = "ssh_config",
  ["tmux.conf"] = "tmux",
}

local filetype_by_filename = {
  [".bash_profile"] = "bash",
  [".bashrc"] = "bash",
  [".clang-format"] = "yaml",
  [".clang-tidy"] = "yaml",
  [".dockerignore"] = "gitignore",
  [".editorconfig"] = "editorconfig",
  [".env"] = "sh",
  [".gitattributes"] = "gitattributes",
  [".gitconfig"] = "gitconfig",
  [".gitignore"] = "gitignore",
  [".gitmodules"] = "gitconfig",
  [".profile"] = "sh",
  [".tmux.conf"] = "tmux",
  [".xdefaults"] = "xdefaults",
  [".xresources"] = "xdefaults",
  [".zprofile"] = "zsh",
  [".zshrc"] = "zsh",
  ["build.gradle"] = "groovy",
  ["caddyfile"] = "caddy",
  ["cmakelists.txt"] = "cmake",
  ["commit_editmsg"] = "gitcommit",
  ["containerfile"] = "dockerfile",
  ["dockerfile"] = "dockerfile",
  ["gemfile"] = "ruby",
  ["git-rebase-todo"] = "gitrebase",
  ["gnumakefile"] = "make",
  ["go.mod"] = "gomod",
  ["go.sum"] = "gosum",
  ["go.work"] = "gowork",
  ["gradle.properties"] = "properties",
  ["hyprland.conf"] = "hyprlang",
  ["justfile"] = "just",
  ["kitty.conf"] = "kitty",
  ["makefile"] = "make",
  ["meson.build"] = "meson",
  ["meson_options.txt"] = "meson",
  ["nginx.conf"] = "nginx",
  ["passwd"] = "passwd",
  ["podfile"] = "ruby",
  ["rakefile"] = "ruby",
  ["requirements.txt"] = "requirements",
  ["robots.txt"] = "robots",
  ["settings.gradle"] = "groovy",
  ["ssh_config"] = "sshconfig",
  ["sshd_config"] = "sshconfig",
  ["tmux.conf"] = "tmux",
}

-- 多段后缀和“文件名.环境”的形式不能只看最后一个后缀，例如 Dockerfile.dev、user.blade.php。
local lang_by_filename_pattern = {
  { "%.blade%.php$", "blade" },
  { "%.component%.html$", "angular" },
  { "^caddyfile[%.%-%_]", "caddy" },
  { "^dockerfile[%.%-%_]", "dockerfile" },
  { "^makefile[%.%-%_]", "make" },
}

local filetype_by_filename_pattern = {
  { "%.blade%.php$", "blade" },
  { "%.component%.html$", "angular" },
  { "^caddyfile[%.%-%_]", "caddy" },
  { "^dockerfile[%.%-%_]", "dockerfile" },
  { "^makefile[%.%-%_]", "make" },
}

local function extension_from_name(name)
  return name:match("%.([%w_+-]+)$")
end

local function filename_from_name(name)
  return (name:match("([^/\\]+)$") or name):lower()
end

local function value_from_filename_pattern(filename, patterns)
  for _, item in ipairs(patterns) do
    if filename:match(item[1]) then
      return item[2]
    end
  end
end

local function lang_from_filetype(filetype)
  if filetype == "" then
    return nil
  end

  if lang_by_filetype[filetype] then
    return lang_by_filetype[filetype]
  end

  local ok, lang = pcall(vim.treesitter.language.get_lang, filetype)
  lang = ok and lang or filetype

  if parser_set[lang] then
    return lang
  end
end

local function lang_from_extension(name)
  local filename = filename_from_name(name)
  if lang_by_filename[filename] then
    return lang_by_filename[filename]
  end

  local pattern_lang = value_from_filename_pattern(filename, lang_by_filename_pattern)
  if pattern_lang then
    return pattern_lang
  end

  local ext = extension_from_name(name)
  if not ext then
    return nil
  end

  return lang_by_extension[ext:lower()]
end

local function infer_filetype(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local filename = filename_from_name(name)
  if filetype_by_filename[filename] then
    return filetype_by_filename[filename]
  end

  local pattern_filetype = value_from_filename_pattern(filename, filetype_by_filename_pattern)
  if pattern_filetype then
    return pattern_filetype
  end

  local ext = extension_from_name(name)
  if not ext then
    return nil
  end

  return filetype_by_extension[ext:lower()]
end

local function resolve_lang(buf)
  local filetype = vim.bo[buf].filetype
  local buftype = vim.bo[buf].buftype

  if disabled_filetypes[filetype] or disabled_buftypes[buftype] then
    return nil
  end

  local lang = lang_from_filetype(filetype)
  local name = vim.api.nvim_buf_get_name(buf)
  lang = lang or lang_from_extension(name)

  if not lang or not parser_set[lang] then
    return nil
  end

  if name == "" then
    return lang
  end

  local max_filesize = 1024 * 1024
  local ok, stat = pcall(vim.uv.fs_stat, name)
  if ok and stat and stat.size > max_filesize then
    return nil
  end

  return lang
end

local function enable_syntax_fallback(buf, lang)
  local syntax = syntax_by_lang[lang] or lang
  if syntax == "" then
    return
  end

  vim.bo[buf].syntax = syntax

  -- syntax enable 只在需要兜底时打开；Treesitter 正常时不会碰这条老式高亮路径。
  pcall(vim.cmd, "syntax enable")
end

local function notify_missing_parser(lang, err)
  if missing_parser_notified[lang] then
    return
  end
  missing_parser_notified[lang] = true

  vim.schedule(function()
    vim.notify(
      ("Treesitter 的 %s parser 暂时不可用，已先使用 Vim 自带语法高亮兜底。\n安装单个 parser：:TSInstall %s\n安装配置里全部 parser：:Lazy build nvim-treesitter\n原始信息：%s"):format(
        lang,
        lang,
        tostring(err)
      ),
      vim.log.levels.WARN,
      { title = "Treesitter parser 未安装" }
    )
  end)
end

local function start_treesitter(buf)
  local lang = resolve_lang(buf)
  if not lang then
    return
  end

  local inferred_filetype = infer_filetype(buf)
  if vim.bo[buf].filetype == "" and inferred_filetype then
    pcall(vim.api.nvim_set_option_value, "filetype", inferred_filetype, { buf = buf })
  end

  -- vim.treesitter.start 是 Neovim 0.12 推荐的原生启用方式。
  -- pcall 可以避免某个语言 parser 暂时缺失时打断你打开文件。
  local ok, err = pcall(vim.treesitter.start, buf, lang)
  if not ok then
    enable_syntax_fallback(buf, lang)
    notify_missing_parser(lang, err)
  end
end

local function set_indentexpr(buf)
  if not resolve_lang(buf) then
    return
  end

  -- 缩进使用 Neovim 原生 treesitter indentexpr；工具窗口和超大文件跳过。
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return {
  {
    -- nvim-treesitter 的 main 分支是 Neovim 0.12+ 的新版实现。
    -- master 分支已经冻结，继续用在 0.12 上容易出现 parser/runtime 不匹配。
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      if vim.fn.executable("tree-sitter") == 0 then
        vim.schedule(function()
          vim.notify(
            table.concat({
              "安装或更新 Treesitter parser 需要 tree-sitter CLI。",
              "macOS: brew install tree-sitter-cli",
              "Ubuntu/Debian: sudo apt install tree-sitter-cli",
              "Fedora: sudo dnf install tree-sitter-cli",
              "Windows: npm install -g tree-sitter-cli",
            }, "\n"),
            vim.log.levels.WARN,
            { title = "缺少 tree-sitter CLI" }
          )
        end)
        return
      end

      require("config.compiler").with_compiler("nvim-treesitter parser 安装", function()
        require("nvim-treesitter").install(parsers):wait(300000)
      end)
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

      for filetype, lang in pairs(lang_by_filetype) do
        pcall(vim.treesitter.language.register, lang, filetype)
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(event)
          start_treesitter(event.buf)
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
        group = vim.api.nvim_create_augroup("user_treesitter_indent", { clear = true }),
        callback = function(event)
          set_indentexpr(event.buf)
        end,
      })
    end,
  },
}
