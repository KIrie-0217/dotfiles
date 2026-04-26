-- mason
local mason = require('mason')
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
-- auto format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)

    -- 保存時に自動フォーマット
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.rs", "*.ts", ".json", ".md", ".lua" },
      callback = function()
        vim.lsp.buf.format({
          buffer = ev.buf,
          filter = function(f_client)
            -- TypeScriptのようにNode.js, Deno, Bunのどれを使うかによって、none-ls (Biome, Prettier) の有無が変わる場合、none-lsの複数回実行を防止するため
            return f_client.name ~= "null-ls"
          end,
          async = false,
        })
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
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



mason.setup()
mason_lspconfig.setup({
	ensure_installed = {
		"pyright",
		"lua_ls",
		"jsonls",
		"yamlls"
	},
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

mason_lspconfig.setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
		capabilities = capabilities

	})
    end,

   ['lua_ls'] = function()
	  lspconfig.lua_ls.setup {
	    settings = {
	      Lua = {
		runtime = {
		  version = 'LuaJIT',
		},
		workspace = {
		  checkThirdParty = false,
		  library = {
		    vim.env.VIMRUNTIME,
		  },
		},
	      },
	    },
	  }
	end,
	["gopls"] = function()
		lspconfig.gopls.setup({
		  settings = {
			 gopls = {
				analyses = {
				  unusedparams = true,
				},
				staticcheck = true,
				gofumpt = true,
			 },
		  },
		})	
	end, 
})

-- rustaceanvim 
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n",
  "<leader>a",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)

