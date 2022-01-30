"============================================================================
"=                            BASIC SETTING                                 =
"============================================================================

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8

set nocompatible
set fileencodings=utf-8,sjis,euc-jp,latin
set title
set nobackup
set nowritebackup
set showcmd
set clipboard+=unnamedplus
" set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set iskeyword+=-                      	" treat dash separated words as a word text object"
set encoding=utf-8                      " The encoding displayed
set pumheight=14                        " Makes popup menu smaller
set ruler              			        " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set nowrap                              " Display long lines as just one line
set mouse=a
" set shell=/bin/bash
set number
" set relativenumber
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
" set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
" set expandtab                           " Converts tabs to spaces
" set smartindent                         " Makes indenting smart
" set autoindent                          " Good auto indent
set shiftround
set ignorecase                          " Ignore case when searching
set smartcase                           " Turn on smartcase
set hlsearch
set incsearch
set guicursor=
set lazyredraw                          " Don't redraw while executing macros
set t_BE=                               " Suppress appending <PasteStart> and <PasteEnd> when pasting
" set noshowcmd                           " Show (partial) command in the last line of the screen. 
filetype plugin indent on

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

" colorscheme intellij_light
" let g:airline_theme = "sol"

" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"   augroup END
" endif
colorscheme onedark
" let g:airline_theme = "onedark"
let g:onedark_termcolors=256
"
" colorscheme zenbones

"============================================================================
"=                            AIRLINE
"============================================================================

" let g:airline_disable_statusline = 1
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_tabs = 1
" let g:airline#extensions#tabline#show_tab_nr = 1
" let g:airline#extensions#tabline#tab_nr_type = 1
" let g:airline_powerline_fonts = 1
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" let g:airline_symbols.space = "\ua0"

"============================================================================
"=                            PYTHON CUSTOMIZATION                          =
"============================================================================
let g:python3_host_prog = join([$HOME, "/.local/share/nvim/lib/python/bin/python3"], "")

"============================================================================
"=                            EXTRA
"============================================================================
set exrc

"============================================================================
"=                            FORMATTERS
"============================================================================
" autocmd FileType c,cpp setlocal equalprg=clang-format
" autocmd FileType python nnoremap <leader>= :0,$!yapf<CR>

" autocmd FileType tex    set wrap
" autocmd FileType tex    set textwidth=119
"============================================================================
"=                            Statusline
"============================================================================
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
