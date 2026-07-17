local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- auto format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.rs", "*.ts", ".json", ".md", ".lua" },
      callback = function()
        vim.lsp.buf.format({
          buffer = ev.buf,
          filter = function(f_client)
            return f_client.name ~= "null-ls"
          end,
          async = false,
        })
      end,
    })

    -- gd/gD are not part of Neovim's built-in LSP defaults (only grr/gri/grt/grn/gra are)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "vim.lsp.buf.definition()" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "vim.lsp.buf.declaration()" })
    -- K is remapped to '^' in keymap_vanila.lua, so hover moves to <leader>k
    vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { buffer = ev.buf, desc = "vim.lsp.buf.hover()" })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

-- LSP servers (binaries provided by Nix home.packages)
vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.config('jsonls', { capabilities = capabilities })
vim.lsp.config('yamlls', { capabilities = capabilities })
vim.lsp.config('ts_ls', { capabilities = capabilities })

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

vim.lsp.config('gopls', {
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.lsp.enable({ 'pyright', 'jsonls', 'yamlls', 'lua_ls', 'gopls', 'ts_ls' })

-- rustaceanvim (handles rust-analyzer internally)
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>a",
  function()
    vim.cmd.RustLsp('codeAction')
  end,
  { silent = true, buffer = bufnr }
)
