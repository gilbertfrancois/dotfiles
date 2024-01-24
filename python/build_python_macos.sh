#!/usr/bin/env bash
set -e

echo "--- Installing brew libraries"
brew update
brew install sqlite3 readline openssl zlib xz tcl-tk

PREFIX=$(brew --prefix)

export LDFLAGS="-L${PREFIX}/opt/sqlite/lib ${LDFLAGS}"
export CPPFLAGS="-I${PREFIX}/opt/sqlite/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/opt/readline/lib ${LDFLAGS}"
export CPPFLAGS="-I${PREFIX}/opt/readline/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/opt/openssl/lib ${LDFLAGS}"
export CPPFLAGS="-I${PREFIX}/opt/openssl/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/opt/zlib/lib ${LDFLAGS}"
export CPPFLAGS="-I${PREFIX}/opt/zlib/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/opt/tcl-tk/lib ${LDFLAGS}"
export CPPFLAGS="-I${PREFIX}/opt/tcl-tk/include ${CPPFLAGS}"
export CFLAGS="-O2"

PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install ${1}
