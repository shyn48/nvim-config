local M = {}

local org_imports = function(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	-- disable tsserver formatting for neovim v0.7
	-- for newer versions it should use filter option on lsp.format
	if client.name == "tsserver" or client.name == "sumneko_lua" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.formatting_sync()
			end,
		})

		if client.name == "gopls" then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					org_imports(1000)
				end,
			})
		end
	end

	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		handler_opts = {
			border = "rounded",
		},
	}, bufnr)
	require("illuminate").on_attach(client)
end

function M.lsp_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	local lspconfig = require("lspconfig")
	local server_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
			yaml = {
				schemas = {
					kubernetes = "globPattern",
				},
			},
		},
	}

	local lsp_servers = {
		"gopls",
		"rust_analyzer",
		"tsserver",
		"dockerls",
		"cssls",
		"jedi_language_server",
		"solc",
		"tailwindcss",
		"terraformls",
		"vimls",
		"sumneko_lua",
		"yamlls",
		"bashls",
	}

	for _, lsp in ipairs(lsp_servers) do
		lspconfig[lsp].setup(server_config)
	end
end

function M.null_ls()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.diagnostics.eslint_d,
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.eslint_d,
			null_ls.builtins.formatting.yapf,
			null_ls.builtins.formatting.stylua,
		},
		on_attach = on_attach,
	})
end

return M
