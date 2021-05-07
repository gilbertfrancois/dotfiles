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
" Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Directory and file tree <leader>t
Plugin 'scrooloose/nerdtree'

" FZF
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plugin 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
Plugin 'junegunn/fzf.vim'

" Better syntax highlighting
Plugin 'vim-python/python-syntax'

Plugin 'lifepillar/vim-colortemplate'

" UI
Plugin 'gilbertfrancois/intellij-light.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'joshdick/onedark.vim'

call vundle#end()            " required
filetype plugin indent on    " required
