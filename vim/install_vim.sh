rm -rf ${HOME}/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim

export PIP3=`which pip3`
${PIP3} install --upgrade flake8 jedi pynvim yapf isort

