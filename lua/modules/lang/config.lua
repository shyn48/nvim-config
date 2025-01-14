local config = {}

function config.nvim_treesitter()
	vim.api.nvim_command("set foldmethod=expr")
	vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		ignore_install = { "phpdoc" },
		highlight = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},
		autotag = {
			enable = true,
		},
		-- rainbow = {
		-- 	enable = true,
		-- },
		matchup = {
			enable = true,
		},
	})
end

function config.nvim_treesitter_context()
	require("treesitter-context").setup({})
end

function config.refactoring()
	require("refactoring").setup({})
end

function config.symbols_outline()
	require("symbols-outline").setup({})
end

function config.trouble()
	require("trouble").setup({})
end

function config.ufo()
	require("ufo").setup({
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
	})
end

function config.gotests()
	require("gotests").setup()
end

return config
