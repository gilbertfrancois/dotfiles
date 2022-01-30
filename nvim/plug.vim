if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" Plug 'cohama/lexima.vim'
Plug 'lewis6991/gitsigns.nvim'

" Color schemes
Plug 'joshdick/onedark.vim'
Plug 'gilbertfrancois/intellij-light.vim'
Plug 'mcchrish/zenbones.nvim'

if has("nvim")
  Plug 'neovim/nvim-lspconfig'
  "
  " Completion
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-nvim-lua'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'tamago324/cmp-zsh'

  Plug 'onsails/lspkind-nvim'

  Plug 'folke/lsp-colors.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  " Plug 'glepnir/lspsaga.nvim'
endif

call plug#end()

