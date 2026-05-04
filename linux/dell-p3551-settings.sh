#!/bin/bash

source "$(dirname "$0")/fedora_tweaks.sh"

function install_dell_settings() {
    sudo grubby --update-kernel=ALL --remove-args="acpi_backlight=vendor"
    sudo grubby --update-kernel=ALL --args="i915.enable_lspcon=0"
}

function install_nvidia_580xx() {
    sudo dnf remove "*nvidia*" -x nvidia-gpu-firmware
    sudo dnf install -y \
        akmod-nvidia-580xx \
        xorg-x11-drv-nvidia-580xx-cuda
}

install_generic
install_dell_settings
install_nvidia_580xx
install_x86_nvidia
