#!/bin/bash

function pre_install() {
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf makecache --refresh
}

function install_misc() {
    sudo dnf update
    sudo dnf install -y \
        awscli2 \
        fastfetch \
        foot \
        gnome-extensions-app \
        gnome-shell-extension-appindicator \
        htop \
        libappindicator-gtk3 \
        lm_sensors \
        nvtop \
        oathtool \
        openssh \
        texlive-scheme-medium
    sudo dnf copr enable lihaohong/yazi
    sudo dnf install -y yazi
    sudo dnf copr enable dejan/lazygit
    sudo dnf install -y lazygit
}

function make_settings() {
    gsettings set org.gnome.desktop.input-sources xkb-options "['compose:ralt', 'ctrl:nocaps']"
    sudo ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/10-sub-pixel-rgb.conf
    $HOME/.dotfiles/linux/install_clipboard_sync.sh
    sudo cp "$(dirname "$0")/etc_bluetooth_main.conf" /etc/bluetooth/main.conf
}

function install_ffmpeg() {
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
}

function install_vaapi_amd_intel() {
    sudo dnf remove -y \
        libva-intel-driver \
        libva-intel-hybrid-driver \
        mesa-va-drivers \
        mesa-vdpau-drivers
    sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
    sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    sudo dnf install -y \
        intel-media-driver \
        libva-utils \
        vdpauinfo
}

function install_vaapi_nvidia_intel() {
    sudo dnf remove -y \
        libva-intel-driver \
        libva-intel-hybrid-driver \
        mesa-va-drivers \
        mesa-vdpau-drivers
    sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
    sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    sudo dnf install -y \
        intel-media-driver \
        libva-utils \
        vdpauinfo \
        nvidia-vaapi-driver \
        libva-nvidia-driver \
        nv-codec-headers
}

function install_gstreamer() {
    sudo dnf install -y \
        gstreamer1 \
        gstreamer1-devel \
        gstreamer1-plugins-base \
        gstreamer1-plugins-base-devel \
        gstreamer1-plugins-base-tools \
        gstreamer1-plugins-good \
        gstreamer1-plugins-good-extras \
        gstreamer1-plugins-bad-free \
        gstreamer1-plugins-bad-free-devel \
        gstreamer1-plugins-bad-free-extras \
        gstreamer1-plugins-bad-freeworld \
        gstreamer1-plugins-ugly \
        gstreamer1-plugins-ugly-free \
        gstreamer1-plugins-ugly-free-extras \
        gstreamer1-plugin-libav \
        gstreamer1-plugin-openh264 \
        gstreamer1-plugins-entrans \
        gstreamer1-vaapi \
        gstreamer1-libcamera
    sudo dnf group upgrade -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    rm -rf ~/.cache/gstreamer-1.0
}

function install_docker() {
    sudo dnf remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine
    sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function install_nvidia_container_toolkit() {
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
    export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.19.0-1
    sudo dnf install -y \
        nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
}

function install_tex() {
    sudo dnf install -y \
        texlive-scheme-tetex \
        texlive-tabularray \
        zathura \
        zathura-plugins-all
}

function install_generic() {
    pre_install
    make_settings
    install_misc
    install_docker
    install_ffmpeg
    install_gstreamer
    install_tex
}

function install_x86_amd() {
    install_vaapi_amd_intel
}

function install_x86_nvidia() {
    install_vaapi_nvidia_intel
    install_nvidia_container_toolkit
}
