#!/usr/bin/env bash
sudo apt update

echo "--- Installing Python"

sudo apt install -y make \
 build-essential \
 libssl-dev \
 zlib1g-dev \
 libbz2-dev \
 libreadline-dev \
 libsqlite3-dev \
 wget \
 curl \
 llvm \
 libncurses5-dev \
 libncursesw5-dev \
 xz-utils \
 tk-dev \
 libffi-dev \
 liblzma-dev \
 python-openssl \
 git

rm -rf ${HOME}/.pyenv
git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv

# PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.6.8
# pyenv global 3.6.8
# pip install pipenv

PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.4
pyenv global 3.7.4 
pip install pipenv

rm .python-version

echo '--- Please add the following lines to .bashrc'
echo
echo 'export PIPENV_VENV_IN_PROJECT=1'
echo 'export PYENV_ROOT="$HOME/.pyenv"' 
echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
echo 
