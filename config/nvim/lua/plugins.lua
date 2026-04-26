require("lazy").setup({
  -- lsp
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "onsails/lspkind.nvim" },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter" },

  -- ui
  { "catppuccin/nvim" },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "yamatsum/nvim-cursorline" },

  -- fold
  { "anuvyklack/pretty-fold.nvim" },
  { "anuvyklack/fold-preview.nvim", requires = { "anuvyklack/keymap-amend.nvim" } },
  { "anuvyklack/keymap-amend.nvim" },

  -- git
  { "lewis6991/gitsigns.nvim" },
  { "f-person/git-blame.nvim" },

  -- markdown
  { "MeanderingProgrammer/markdown.nvim", name = "render-markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function() require("render-markdown").setup({}) end },

  -- rust
  { "mrcjkb/rustaceanvim", version = "^4", lazy = false },
})

-- null-ls
require("null-ls").setup({
  sources = {},
  debug = true,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
    end
  end,
})

-- ibl
require("ibl").setup()

-- lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "ayu_mirage",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- fold
require("pretty-fold").setup()
require("fold-preview").setup({ auto = 500 })

-- treesitter
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "rust", "lua", "toml", "c_sharp", "vue" },
  },
})
vim.o.conceallevel = 2

-- null-ls textlint
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.textlint.with({ filetypes = { "markdown" } }),
  },
})

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  matching = { disallow_symbol_nonprefix_matching = false },
})

-- gitsigns
require("gitsigns").setup({
  signs = {
    add = { text = "┃" }, change = { text = "┃" }, delete = { text = "_" },
    topdelete = { text = "‾" }, changedelete = { text = "~" }, untracked = { text = "┆" },
  },
  current_line_blame = false,
})

-- git-blame
require("gitblame").setup({
  event = "VeryLazy",
  opts = {
    enabled = true,
    message_template = " <summary> • <date> • <author> • <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 1,
  },
})

-- catppuccin
require("catppuccin").setup({})
