#!/usr/bin/env bash
set -e

echo "--- Installing brew libraries"
brew update
brew install sqlite3 readline openssl zlib xz tcl-tk

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

PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install ${1}
