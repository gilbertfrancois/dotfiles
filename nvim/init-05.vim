" Inspiration
" https://github.com/rstacruz/vim-coc-settings
" https://github.com/ChristianChiarulli/LunarVim/tree/stable-snapshot-CoC
"
set nocompatible              " required
filetype off                  " required

"============================================================================
"=                            BASIC SETTING                                 =
"============================================================================


set noshowmode                          " We don't need to see things like -- INSERT -- anymore

" UTF-8 support
set encoding=utf-8

" Swipe and mouse scroll
set mouse=a

" YouCompleteMe does not work with fish
set shell=/bin/bash

" show line numbers
set number
set relativenumber

" show the matching part of the pair for [] {} and ()
set showmatch

" Use same clipboard in Vim and in the system
" Note: MacOS X specific setting
set clipboard=unnamed

" Set Leader key
let mapleader = " "

" Where to put new tab when doing screen split
set splitright

" Fixing 'Press ENTER or type command' prompt issue
set shortmess=a

" enable syntax highlighting
syntax enable

" highlight cursorline
set cursorline

" Useful settings
set history=700
set undolevels=700

" 
" Disable creation of a swapfile
set noswapfile

" Don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Search configuration
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase
set hlsearch
set incsearch

set guicursor=
"============================================================================
"=                            KEYS REMAPPING                                =
"============================================================================

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

  " Use alt + hjkl to resize windows
" nnoremap <silent> <M-j> :resize -2<CR>
" nnoremap <silent> <M-k> :resize +2<CR>
" nnoremap <silent> <M-h> :vertical resize -2<CR>
" nnoremap <silent> <M-l> :vertical resize +2<CR>

" Better copy and paste
set pastetoggle=<F2>

"============================================================================
"=                          PLUGIN INITIALIZATION                           =
"============================================================================

" set the runtime path to include Vundle and initialize
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()

" Let vundle handle Vundle, required
Plugin 'gmarik/Vundle.vim'

" LSP
Plugin 'neovim/nvim-lspconfig'
Plugin 'nvim-lua/completion-nvim'
Plugin 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update


" Better defaults
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Directory and file tree <leader>t
Plugin 'scrooloose/nerdtree'

" FZF
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plugin 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
Plugin 'junegunn/fzf.vim'

Plugin 'vim-python/python-syntax'

Plugin 'lifepillar/vim-colortemplate'

" UI
Plugin 'gilbertfrancois/intellij-light.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'joshdick/onedark.vim'

call vundle#end()            " required
filetype plugin indent on    " required

"============================================================================
"=                          PLUGIN CUSTOMIZATION                            =
"============================================================================

" let g:PaperColor_Theme_Options = {
"   \   'theme': {
"   \     'default': {
"   \       'transparent_background': 1
"   \     }
"   \   }
"   \ }
" colorscheme PaperColor
" set background=light
" let g:airline_theme = "papercolor"

colorscheme intellij_light
let g:airline_theme = "papercolor"

" colorscheme onedark
" let g:airline_theme = "onedark"

" colorscheme gruvbox
" set background=dark


"*********************** AIRLINE **************************
" Airline customization
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"*********************** NERDTree *************************
map <leader>t :NERDTreeToggle<CR>
" Don't show hidden files
let NERDTreeShowHidden=0
let NERDTreeIgnore=['\.o$', '\~$', '\.swp$', '\.git$', '\.pyc$']

"============================================================================
"=                            PYTHON CUSTOMIZATION                          =
"============================================================================
let g:python3_host_prog = join([$HOME, "/.config/nvim/lib/python/bin/python3"], "")
let g:python_highlight_all = 1
let g:python_highlight_operators = 0

"============================================================================
"=                            NODE CUSTOMIZATION                          =
"============================================================================
" let g:node_host_prog = join([$HOME, "/.config/nvim/lib/node/bin/node"], "")

" Set debug brakepoint
au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>


"============================================================================
"=                            LSP and autocomplete                          =
"============================================================================

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list=['exact', 'substring', 'fuzzy']

lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
