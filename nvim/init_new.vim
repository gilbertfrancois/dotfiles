filetype plugin indent on
scriptencoding utf-8

"============================================================================
"=                            BASIC SETTING                                 =
"============================================================================

set nocompatible
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set iskeyword+=-                      	" treat dash separated words as a word text object"
set encoding=utf-8                      " The encoding displayed
set pumheight=14                        " Makes popup menu smaller
set ruler              			        " Show the cursor position all the time
set cmdheight=1                         " More space for displaying messages
set nowrap                              " Display long lines as just one line
set mouse=a
set shell=/bin/bash
set number
set relativenumber
set showmatch
let mapleader = " "
set splitright
" set shortmess=a
syntax enable
set cursorline
set colorcolumn=120
set history=700
set undolevels=700
set noswapfile
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set shiftround
set ignorecase                          " Ignore case when searching
set smartcase                           " Turn on smartcase
set hlsearch
set guicursor=
set clipboard+=unnamedplus
set incsearch
set noshowcmd                           " Show (partial) command in the last line of the screen. 
set scrolloff=2

autocmd!
" set script encoding
" stop loading config if it's on tiny or small
if !1 | finish | endif

" set fileencodings=utf-8,sjis,euc-jp,latin
" set title
set nobackup
set nowritebackup
" set laststatus=2
" let loaded_matchparen = 1
" set backupskip=/tmp/*,/private/tmp/*
set lazyredraw                          " Don't redraw while executing macros
set t_BE=                               " Suppress appending <PasteStart> and <PasteEnd> when pasting
" set noshowmatch
" set backspace=start,eol,indent
" set path+=**
" set wildignore+=*/node_modules/*
" if has('nvim')
  " set inccommand=split
" endif

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r

"============================================================================
"=                            IMPORTS
"============================================================================
runtime ./plug.vim
runtime ./maps.vim

"============================================================================
"=                            THEME
"============================================================================
colorscheme intellij_light
let g:airline_theme = "papercolor"

"============================================================================
"=                            PYTHON CUSTOMIZATION                          =
"============================================================================
let g:python3_host_prog = join([$HOME, "/.local/share/nvim/lib/python/bin/python3"], "")
" let g:node_host_prog = join([$HOME, "/.local/share/nvim/lib/node/bin/node"], "")

"============================================================================
"=                            EXTRA
"============================================================================
set exrc

"============================================================================
"=                            FORMATTERS
"============================================================================
autocmd FileType c,cpp setlocal equalprg=clang-format
autocmd FileType python nnoremap <leader>= :0,$!yapf<CR>
