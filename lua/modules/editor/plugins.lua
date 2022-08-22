local plugin = require('core.pack').register_plugin
local conf = require('modules.editor.config')

plugin({
  'windwp/nvim-autopairs',
  config = conf.autopairs
})

plugin({
  'tpope/vim-surround'
})

plugin({
  'numToStr/Comment.nvim',
  config = conf.comment,
})

plugin({
  'lukas-reineke/indent-blankline.nvim',
  config = conf.indent_blankline,
})

plugin({
  'AndrewRadev/splitjoin.vim',
})

plugin({
  'tpope/vim-abolish',
})

plugin({
  'mg979/vim-visual-multi',
})
