require "user.options"
require "user.keymap"
require "user.plugins"
require "user.completion"
require "user.lspconfig"

-- vim.g.tokyonight_style = "night"
-- vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
-- vim.cmd[[colorscheme tokyonight]]

vim.g.onedark_termcolors = 256
vim.g.background = dark
vim.cmd[[colorscheme onedark]]

vim.cmd "let g:python3_host_prog = join([$HOME, '/.local/share/nvim/lib/python/bin/python3'], '')"
