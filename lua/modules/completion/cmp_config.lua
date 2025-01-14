local cmp_config = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")

	cmp.setup({
		preselect = cmp.PreselectMode.Item,
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text", -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function(entry, vim_item)
					return vim_item
				end,
			}),
		},
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			end,
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<Tab>"] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				-- elseif luasnip.expand_or_jumpable() then
				--     luasnip.expand_or_jump()
				else
					fallback()
				end
			end,
			["<S-Tab>"] = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				-- elseif luasnip.jumpable(-1) then
				--     luasnip.jump(-1)
				else
					fallback()
				end
			end,
		},
		sources = {
			{
				name = "nvim_lsp",
			},
			{
				name = "vsnip",
			},
			{
				name = "buffer",
			},
			{
				name = "path",
			},
		},
	})

	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({ {
			name = "path",
		} }, { {
			name = "cmdline",
		} }),
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sql" },
		callback = function()
			cmp.setup.buffer({
				sources = {
					{
						name = "vim-dadbod-completion",
					},
				},
			})
		end,
	})
end

return cmp_config
