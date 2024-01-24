#!/usr/bin/env bash

# if [[ `uname -s` == "Darwin" ]]; then
#     brew update
#     brew install curl
# elif [[ `uname -s` == "Linux" ]]; then
#     sudo apt update
#     sudo apt install curl
# fi

echo "--- Installing Poetry"
pushd /tmp/
# Download install script
curl -sSL https://install.python-poetry.org >install_poetry.sh
chmod 755 install_poetry.sh
echo "... Uninstall old Poetry installation"
./install_poetry.sh --uninstall
echo "... Install latest poetry"
./install_poetry.sh
echo "... Change settings"
# Change this setting in the poetry configuration...
poetry config virtualenvs.prefer-active-python true
poetry config --list
popd

echo "... Done."
