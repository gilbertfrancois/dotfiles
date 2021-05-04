#!/usr/bin/env bash

set -e
function update_sh {
    case `grep -sqF "poetry/bin" ${HOME}/$1 > /dev/null; echo $?` in
        0)
            echo "--- Poetry is already added to the path in ${HOME}/$1."
            ;;
        1)
            echo "--- Adding poetry to the path in ${HOME}/$1."
            echo 'export PATH=${HOME}/.poetry/bin:${PATH}' >> ~/$1
            source ${HOME}/$1
            ;;
        *)
            echo "--- You don't seem to have $1. No worries, all is fine :)"
            ;;
    esac
}

echo "--- Installing Poetry..."
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

update_sh .bashrc
update_sh .profile
update_sh .bash_profile
update_sh .zshrc

