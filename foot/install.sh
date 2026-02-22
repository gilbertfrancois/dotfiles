#!/usr/bin/env bash
set -euo pipefail

PREFIX="$HOME/.local/foot.app"

sudo apt update
sudo apt install -y \
    build-essential git pkg-config meson ninja-build scdoc python3 \
    libxkbcommon-dev libwayland-dev wayland-protocols \
    libpixman-1-dev libfontconfig1-dev \
    libutf8proc-dev libncursesw5-dev \
    libfcft-dev libtllist-dev

cd /tmp
rm -rf foot
git clone https://codeberg.org/dnkl/foot.git
cd foot

mkdir -p ~/.config/systemd/user

export CFLAGS="${CFLAGS:-} -O3"

meson setup bld/release \
    --buildtype=release \
    --prefix="$HOME/.local/foot.app" \
    -Db_lto=true \
    -Dsystemd-units-dir="$HOME/.local/share/systemd/user"
ninja -C bld/release
ninja -C bld/release test
ninja -C bld/release install
