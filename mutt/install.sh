#!/usr/bin/env bash

set +xe
# sudo apt update
sudo apt install -y xsltproc gettext libidn2-dev notmuch urlview abook lynx libsasl2-dev libkrb5-dev liblmdb-dev libsasl2-modules-gssapi-mit libnotmuch-dev pkg-config libgpgme

rm -rf $HOME/.local/neomutt.app

pushd /tmp
git clone https://github.com/neomutt/neomutt
cd neomutt

# -autocrypt +fcntl -flock -fmemopen +futimens +getaddrinfo -gnutls -gpgme
# -gsasl +gss +hcache -homespool +idn +inotify -locales_hack -lua +nls +notmuch
# +openssl +pgp +regex +sasl +smime -sqlite +truecolor
./configure --prefix="$HOME/.local/neomutt.app" --gss --sasl --lmdb --notmuch --ssl --autocrypt

make -j"$(nproc)"
make install

ln -s ~/.local/neomutt.app/bin/neomutt ~/.local/bin/mutt
ln -s ~/.local/neomutt.app/bin/neomutt ~/.local/bin/neomutt
popd
