" Inspiration
" https://github.com/rstacruz/vim-coc-settings
" https://github.com/ChristianChiarulli/LunarVim/tree/stable-snapshot-CoC
"
"
source $HOME/.dotfiles/nvim/general.vim
source $HOME/.dotfiles/nvim/keymap.vim
source $HOME/.dotfiles/nvim/plugins.vim
source $HOME/.dotfiles/nvim/coc.vim

"============================================================================
"= UI
"============================================================================

" colorscheme PaperColor
" set background=light
" let g:airline_theme = "papercolor"

colorscheme intellij_light
let g:airline_theme = "sol"

" colorscheme onedark
" let g:airline_theme = "onedark"

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


"============================================================================
"= NERDTree
"============================================================================

map <leader>t :NERDTreeToggle<CR>
" Don't show hidden files
let NERDTreeShowHidden=0
let NERDTreeIgnore=['\.o$', '\~$', '\.swp$', '\.git$', '\.pyc$']

"============================================================================
"= Python
"============================================================================

let g:python3_host_prog = join([$HOME, "/.config/nvim/lib/python/bin/python3"], "")
let g:python_highlight_all = 1
let g:python_highlight_operators = 0

" Set debug brakepoint
au FileType python map <silent> <leader>b oimport pdb; pdb.set_trace()<esc>
au FileType python map <silent> <leader>B Oimport pdb; pdb.set_trace()<esc>


