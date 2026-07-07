#!/bin/bash

function install_dell_settings() {
    sudo grubby --update-kernel=ALL --args="acpi_osi=! acpi_osi='Windows 2015' acpi_backlight=native mem_sleep_default=deep"
    sudo grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau,nova_core"
}

function install_nvidia_580xx() {
    sudo dnf remove "*nvidia*" -x nvidia-gpu-firmware
    sudo dnf install -y \
        akmod-nvidia-580xx \
        xorg-x11-drv-nvidia-580xx-cuda
}

install_dell_settings
install_nvidia_580xx
