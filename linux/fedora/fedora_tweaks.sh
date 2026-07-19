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

function install_nvidia_proprietary_driver() {
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

    sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<'EOF'
blacklist nouveau
options nouveau modeset=0
EOF

    sudo tee /etc/dracut.conf.d/nvidia.conf >/dev/null <<'EOF'
omit_drivers+=" nouveau "
EOF

    sudo tee /etc/modprobe.d/nvidia-drm.conf >/dev/null <<'EOF'
options nvidia-drm modeset=1
EOF

    sudo akmods --force
    sudo dracut --force --regenerate-all

    echo ""
    echo "==> nvidia driver installed, nouveau blacklisted and dropped from the initramfs."
    echo "    akmods signs the nvidia kmod with a MOK key, auto-generated on first run and"
    echo "    named after this machine's hostname. It should have prompted you to set an"
    echo "    enrollment password just now (if it didn't, run:"
    echo "    sudo mokutil --import /etc/pki/akmods/certs/public_key.der)."
    echo "    That enrollment only matters once Secure Boot is turned on in the BIOS:"
    echo "    reboot, and at the blue 'MOK Management' screen pick Enroll MOK -> Continue"
    echo "    -> enter that password -> reboot again."
    echo "    After that, verify with: nvidia-smi && lsmod | grep -i nvidia"
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
        latexmk \
        zathura \
        zathura-plugins-all
}

function install_brave() {
    sudo dnf install dnf-plugins-core
    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo dnf install brave-browser
}

function install_proton() {
    pushd $HOME/Downloads/
    # wget https://proton.me/download/mail/linux/1.13.3/ProtonMail-desktop-beta.rpm
    # wget https://proton.me/download/pass/linux/proton-pass-1.38.1-1.x86_64.rpm

    wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.4-1.noarch.rpm"
    sudo dnf install ./protonvpn-stable-release-1.0.4-1.noarch.rpm && sudo dnf check-update --refresh
    sudo dnf install proton-vpn-gnome-desktop
    sudo dnf install libappindicator-gtk3 gnome-shell-extension-appindicator gnome-extensions-app
    sudo dnf install proton-vpn-cli
    popd

}

function install_generic() {
    pre_install
    make_settings
    install_misc
    install_docker
    install_ffmpeg
    install_gstreamer
    install_tex
    install_brave
}

function install_x86_amd_gpu() {
    install_vaapi_amd_intel
}

function install_x86_nvidia_gpu() {
    install_vaapi_nvidia_intel
    install_nvidia_container_toolkit
}

install_generic
# install_x86_amd_gpu
install_x86_nvidia_gpu
#install_nvidia_proprietary_driver
