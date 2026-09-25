#!/bin/bash
set -euo pipefail

# ThinkPad Hybrid USB-C with USB-A Dock (Lenovo Type 40AF).
#
# This dock does NOT pass DisplayPort through natively: its two external
# video outputs are driven by a DisplayLink chip (USB vendor id 17e9) that
# compresses frames over USB. Without the evdi kernel module + the
# DisplayLink user-space service, the kernel never creates DRM outputs for
# those ports, so Hyprland/GNOME only ever see the internal panel.
#
# RPM Fusion doesn't carry this (closed-source DisplayLink firmware), so
# this pulls it from negativo17, which maintains evdi/displaylink as akmod
# packages for Fedora.

function pre_install() {
    if [[ ! -f /etc/yum.repos.d/fedora-multimedia.repo ]]; then
        sudo dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
    fi
    sudo dnf makecache --refresh
}

function install_displaylink() {
    # akmod-evdi builds the kernel module from source on install/kernel
    # update; there is no plain "evdi" package. xorg-x11-displaylink is
    # skipped since this machine runs Wayland (Hyprland), not Xorg.
    sudo dnf install -y akmod-evdi libevdi displaylink
    sudo akmods --force
    sudo modprobe evdi
    sudo systemctl enable --now displaylink.service

    echo ""
    echo "==> evdi built and loaded, displaylink.service enabled."
    echo "    Secure Boot is disabled on this machine, so the unsigned akmod"
    echo "    loads as-is; if Secure Boot is ever turned on, enroll the MOK"
    echo "    key the same way as for the nvidia akmod (see lenovo_p14s.sh)."
    echo "    Unplug and replug the dock, then check: hyprctl monitors"
    echo "    (or: lsmod | grep evdi / systemctl status displaylink)"
}

pre_install
install_displaylink
