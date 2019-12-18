#!/usr/bin/env bash
set -e
sudo apt update

echo "--- Installing build environment"
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

echo "--- Building Python ${1}"
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install ${1}
pyenv global ${1}
pip install pipenv

rm -f .python-version
