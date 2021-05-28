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

" Better defaults
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Neoclide COC
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

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
Plugin 'tikhomirov/vim-glsl'

Plugin 'lifepillar/vim-colortemplate'
Plugin 'superevilmegaco/AutoRemoteSync.nvim'

" UI
Plugin 'gilbertfrancois/intellij-light.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'joshdick/onedark.vim'

call vundle#end()            " required
filetype plugin indent on    " required

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

colorscheme intellij_light
let g:airline_theme = "papercolor"

" colorscheme onedark
" let g:airline_theme = "onedark"



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

"============================================================================
"=                                COC                                       =
"============================================================================

let g:coc_node_path = join([$HOME, "/.config/nvim/lib/node/bin/node"], "")
let g:coc_global_extensions = ['coc-pyright', 'coc-html', 'coc-css', 'coc-tsserver', 'coc-json'] 
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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><noait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
