let $NVIM_CONFIG_DIR = expand('$HOME/.dotfiles/nvim')

if has('nvim-0.5')
    " nightly config
    source $NVIM_CONFIG_DIR/init-05.vim
else
    " stable config
    source $NVIM_CONFIG_DIR/init-04.vim
endif
