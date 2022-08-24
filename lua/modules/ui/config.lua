local utils = require('utils')
local config = {}

function config.zephyr()
	local theme_path = vim.fn.stdpath('data') .. '/theme'
	if utils.file_exists(theme_path) then
		local theme = utils.lines_from(theme_path)
		for _, value in pairs(theme) do
			vim.cmd('colorscheme ' .. value)
		end
	else
		vim.cmd('colorscheme zephyr')
	end
end

function config.galaxyline()
	require('modules.ui.eviline')
end

function config.dashboard()
	local home = os.getenv('HOME')
	local db = require('dashboard')
	db.session_directory = home .. '/.cache/nvim/session'
	-- disable due to bug of auto session conflict bug
	-- db.preview_command = 'cat | lolcat -F 0.3'
	-- db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
	db.preview_file_height = 12
	db.preview_file_width = 80
	db.custom_center = {
		{
			icon = '  ',
			desc = 'Sync Plugins                            ',
			shortcut = 'SPC p s',
			action = 'PackerSync',
		},
		{
			icon = '  ',
			desc = 'Find  File                              ',
			action = 'Telescope find_files find_command=rg,--hidden,--files',
			shortcut = 'SPC f f',
		},
	}
end

function config.nvim_bufferline()
	require('bufferline').setup({
		options = {
			separator_style = 'thick',
			modified_icon = '✥',
			buffer_close_icon = '',
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				}
			},
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local has_error = false
				for e, _ in pairs(diagnostics_dict) do
					if e == "error" then
						has_error = true
						break
					end
				end

				local s = "(" .. count .. ")"
				if has_error then
					s = s .. "  "
				end
				return s
			end,
		},
	})
end

function config.nvim_tree()
	require('nvim-tree').setup({
		disable_netrw = false,
		hijack_cursor = true,
		hijack_netrw = true,
	})
end

function config.which_key()
	require('which-key').setup({})
end

return config
