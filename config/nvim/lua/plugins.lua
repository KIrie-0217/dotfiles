-- null-ls
require("null-ls").setup({
  sources = {
    require("null-ls").builtins.diagnostics.textlint.with({ filetypes = { "markdown" } }),
  },
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

-- treesitter (parsers installed by Nix, just enable highlight)
vim.treesitter.start = (function(original)
  return function(bufnr, lang)
    lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr or 0].filetype)
    local disable = { rust = true, lua = true, toml = true, c_sharp = true, vue = true }
    if lang and disable[lang] then return end
    original(bufnr, lang)
  end
end)(vim.treesitter.start)
vim.o.conceallevel = 2

-- render-markdown
require("render-markdown").setup({})

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-q>"] = cmp.mapping.complete(),
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

-- amazonq
require("amazonq").setup({
  ssoStartUrl = os.getenv("AMAZONQ_SSO_START_URL") or "",
})
