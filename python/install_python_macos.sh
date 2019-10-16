#!/usr/bin/env bash

echo "--- Installing build environment"

#sudo xcode-select --install
#if [[ "${OSTYPE}" == "darwin18" ]]; then
#    sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
#fi

echo "--- Installing brew libraries"

brew update
brew install sqlite3 readline openssl zlib xz tcl-tk

echo "--- Installing pyenv"

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

export LDFLAGS="-L/usr/local/opt/sqlite/lib ${LDFLAGS}"
export CPPFLAGS="-I/usr/local/opt/sqlite/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/opt/readline/lib ${LDFLAGS}"
export CPPFLAGS="-I/usr/local/opt/readline/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/opt/openssl/lib ${LDFLAGS}"
export CPPFLAGS="-I/usr/local/opt/openssl/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/opt/zlib/lib ${LDFLAGS}"
export CPPFLAGS="-I/usr/local/opt/zlib/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib ${LDFLAGS}"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include ${CPPFLAGS}"
export CFLAGS="-O2"

PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.6.8
pyenv local 3.6.8
pip install pipenv

PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.7.4
pyenv local 3.7.4
pip install pipenv

rm .python-version

echo '--- Please add the following lines to .bash_profile'
echo
echo 'export PIPENV_VENV_IN_PROJECT=1'
echo 'export PYENV_ROOT="$HOME/.pyenv"' 
echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
echo 

