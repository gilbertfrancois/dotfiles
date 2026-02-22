#!/usr/bin/env bash

# sudo apt update
sudo apt install -y xsltproc gettext libidn2-dev notmuch urlview abook lynx libsasl2-dev libkrb5-dev liblmdb-dev libsasl2-modules-gssapi-mit libnotmuch-dev pkg-config

rm -rf $HOME/.local/neomutt.app

pushd /tmp
git clone https://github.com/neomutt/neomutt
cd neomutt

./configure --prefix="$HOME/.local/neomutt.app" --gss --sasl --lmdb --notmuch

make -j"$(nproc)"
make install

popd
