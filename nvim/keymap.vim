" Set Leader key
let mapleader = " "

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

" TAB in general mode will move to text buffer
nnoremap <silent> <C-TAB> :bnext<CR>
nnoremap <silent> <C-S-TAB> :bprevious<CR>


" Better copy and paste
set pastetoggle=<F2>


