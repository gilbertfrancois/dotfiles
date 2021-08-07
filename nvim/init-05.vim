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
set encoding=utf-8
set mouse=a
set shell=/bin/bash
set number
set relativenumber
set showmatch
set clipboard=unnamed
let mapleader = " "
set splitright
set shortmess=a
syntax enable
set cursorline
set colorcolumn=120
set history=700
set undolevels=700
set noswapfile
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase
set hlsearch
set incsearch
set guicursor=
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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

call plug#begin(stdpath('data') . 'vimplug')
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-ragtag'

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'hrsh7th/nvim-compe'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    " Plug 'glepnir/galaxyline.nvim', { 'branch': 'main' }
    Plug 'kyazdani42/nvim-web-devicons'  " needed for galaxyline icons

    Plug 'nikvdp/neomux'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'

    Plug 'joshdick/onedark.vim'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'lifepillar/vim-colortemplate'
    Plug 'superevilmegaco/AutoRemoteSync.nvim'
    Plug 'scrooloose/nerdtree'

call plug#end()


"============================================================================
"=                          PLUGIN CUSTOMIZATION                            =
"============================================================================

" " let g:PaperColor_Theme_Options = {
" "   \   'theme': {
" "   \     'default': {
" "   \       'transparent_background': 1
" "   \     }
" "   \   }
" "   \ }
" colorscheme PaperColor
" set background=light
" let g:airline_theme = "papercolor"

" colorscheme intellij_light
" let g:airline_theme = "papercolor"

" " onedark.vim override: Don't set a background color when running in a terminal;
" " just use the terminal's background color
" " `gui` is the hex color code used in GUI mode/nvim true-color mode
" " `cterm` is the color code used in 256-color mode
" " `cterm16` is the color code used in 16-color mode
" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"   augroup END
" endif
colorscheme onedark
let g:airline_theme = "onedark"
let g:onedark_termcolors=256



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
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.o$', '\~$', '\.swp$', '\.git$', '\.pyc$']

"============================================================================
"=                            PYTHON CUSTOMIZATION                          =
"============================================================================
let g:python3_host_prog = join([$HOME, "/.config/nvim/lib/python/bin/python3"], "")
let g:python_highlight_all = 1
let g:python_highlight_operators = 0

"============================================================================
"=                            NODE CUSTOMIZATION                            =
"============================================================================
" let g:node_host_prog = join([$HOME, "/.config/nvim/lib/node/bin/node"], "")
" let g:node_host_prog = expand("~/.config/nvim/lib/node-v14.16.1-linux-x64/bin/node")

" Set debug brakepoint
au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>

"============================================================================
"=                            GLSL                                          =
"============================================================================
autocmd BufNewFile,BufRead *.vert,*.tesc,*.tese,*.glsl,*.geom,*.frag,*.comp set filetype=glsl


" >> Telescope bindings
nnoremap <Leader>pp :lua require'telescope.builtin'.builtin{}<CR>

" most recentuly used files
nnoremap <Leader>m :lua require'telescope.builtin'.oldfiles{}<CR>

" find buffer
nnoremap ; :lua require'telescope.builtin'.buffers{}<CR>

" find in current buffer
nnoremap <Leader>/ :lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>

" bookmarks
nnoremap <Leader>' :lua require'telescope.builtin'.marks{}<CR>

" git files
nnoremap <Leader>f :lua require'telescope.builtin'.git_files{}<CR>

" all files
nnoremap <Leader>bfs :lua require'telescope.builtin'.find_files{}<CR>

" ripgrep like grep through dir
nnoremap <Leader>rg :lua require'telescope.builtin'.live_grep{}<CR>

" pick color scheme
nnoremap <Leader>cs :lua require'telescope.builtin'.colorscheme{}<CR>


" >> setup nerdcomment key bindings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1

xnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>
nnoremap <Leader>ci :call NERDComment('n', 'toggle')<CR>


" >> Lsp key bindings
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K     <cmd>Lspsaga hover_doc<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-p> <cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-n> <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ga    <cmd>Lspsaga code_action<CR>
xnoremap <silent> ga    <cmd>Lspsaga range_code_action<CR>
nnoremap <silent> gs    <cmd>Lspsaga signature_help<CR>

lua <<EOF
require("lsp")
require("treesitter")
require("completion")
EOF
