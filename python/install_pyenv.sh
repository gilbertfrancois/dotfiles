#!/usr/bin/env bash

set -e
function update_sh {
    case `grep -sqF "PYENV_ROOT" ${HOME}/$1 > /dev/null; echo $?` in
        0)
            echo "--- pyenv already added to ~/$1."
            ;;
        1)
            echo "--- Adding pyenv environment variables to ~/$1."
            echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/$1
            echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/$1
            echo 'eval "$(pyenv init --path)"' >> ~/$1
            source ${HOME}/$1
            ;;
        *)
            echo "--- You don't seem to have $1. No worries, all is fine :)"
            ;;
    esac
}

CURRENT_DIR=`pwd`
if [[ -d ${HOME}/.pyenv ]]; then
    echo '--- Updating pyenv'
    cd ${HOME}/.pyenv
    git pull
else
    echo '--- Installing pyenv'
    git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
fi
cd ${CURRENT_DIR}

update_sh .bashrc
update_sh .profile
update_sh .bash_profile
update_sh .zshrc

echo "--- Making python 3 default..."
sudo rm -f /usr/bin/python 
sudo ln -s /usr/bin/python3 /usr/bin/python
