local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]] 

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end


-- Have packer use a popup window
-- packer.init {
  -- display = {
    -- open_fn = function()
      -- return require("packer.util").float { border = "rounded" }
    -- end,
  -- },
-- }

return require('packer').startup(function(use)
  -- Let packer manage itself
  use "wbthomason/packer.nvim" 

  -- The Tim Pope plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/popup.nvim" 

  -- Useful lua functions used ny lots of plugins
  use "nvim-lua/plenary.nvim" 

  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Completion plugins
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  -- use 'hrsh7th/cmp-nvim-lsp-document-symbol'
  -- use 'tamago324/cmp-zsh'

  -- Snippet engine
  use 'L3MON4D3/LuaSnip'
  -- Many ready-made snippets for a lot of languages
  use 'rafamadriz/friendly-snippets'

  -- use 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  use 'nvim-telescope/telescope.nvim'
  use 'kyazdani42/nvim-tree.lua'
  use 'kyazdani42/nvim-web-devicons'

  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && npm install', cmd = 'MarkdownPreview'}

  -- Color schemes
  use 'folke/tokyonight.nvim'
  use 'joshdick/onedark.vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
