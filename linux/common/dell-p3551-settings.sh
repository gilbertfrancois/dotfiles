#!/bin/bash

source "$(dirname "$0")/fedora_tweaks.sh"

function install_dell_settings() {
    sudo grubby --update-kernel=ALL --args="acpi_osi=! acpi_osi='Windows 2015' acpi_backlight=native mem_sleep_default=deep"
    sudo grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau,nova_core"
}

function install_logind_settings() {
    sudo mkdir -p /etc/systemd/logind.conf.d
    sudo tee /etc/systemd/logind.conf.d/power.conf > /dev/null << 'EOF'
[Login]
HandlePowerKey=suspend
EOF
    sudo systemctl restart systemd-logind
}

function install_nvidia_580xx() {
    sudo dnf remove "*nvidia*" -x nvidia-gpu-firmware
    sudo dnf install -y \
        akmod-nvidia-580xx \
        xorg-x11-drv-nvidia-580xx-cuda
}

install_generic
install_dell_settings
install_logind_settings
install_nvidia_580xx
install_x86_nvidia
