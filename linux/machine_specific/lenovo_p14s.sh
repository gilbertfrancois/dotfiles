#!/bin/bash

# Swap Alt<->Super only on the built-in keyboard ("AT Translated Set 2
# keyboard", evdev id 0001:0001) so external keyboards (e.g. the ZSA Ergodox
# EZ) are unaffected. GNOME/Mutter has no per-device XKB option (unlike
# Hyprland's `device { }` blocks), so this uses keyd to remap at the evdev
# level instead.

BUILD_DIR="/tmp/keyd-build"

function remove_gnome_global_alt_win_swap() {
    # Make sure GNOME's global xkb-options doesn't also swap alt/win, or
    # it would double up with the keyd remap below.
    local current
    current="$(gsettings get org.gnome.desktop.input-sources xkb-options)"
    if [[ "$current" == *altwin:swap_alt_win* ]]; then
        gsettings set org.gnome.desktop.input-sources xkb-options \
            "$(echo "$current" | sed "s/'altwin:swap_alt_win', *//; s/, *'altwin:swap_alt_win'//; s/'altwin:swap_alt_win'//")"
    fi
}

function install_keyd() {
    if command -v keyd &>/dev/null; then
        return
    fi

    rm -rf "$BUILD_DIR"
    git clone --depth 1 https://github.com/rvaiya/keyd "$BUILD_DIR"
    make -C "$BUILD_DIR"
    sudo make -C "$BUILD_DIR" install
}

function configure_keyd_swap() {
    sudo mkdir -p /etc/keyd
    sudo tee /etc/keyd/lenovo_p14s.conf > /dev/null <<'CONF'
[ids]
0001:0001

[main]
leftalt = leftmeta
leftmeta = leftalt
rightalt = rightmeta
rightmeta = rightalt
CONF

    sudo systemctl enable --now keyd
    sudo systemctl restart keyd
}

remove_gnome_global_alt_win_swap
install_keyd
configure_keyd_swap
