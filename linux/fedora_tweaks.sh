#!/bin/bash

# 1. Enable RPM Fusion (Free and Non-Free)
# This is mandatory for NVIDIA drivers and non-free codecs
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# 2. Update package metadata
sudo dnf makecache --refresh

sudo dnf update
sudo dnf install fastfetch
sudo dnf install lm_sensors
sudo dnf install oathtool
sudo dnf install htop
sudo dnf install libappindicator-gtk3 gnome-shell-extension-appindicator gnome-extensions-app
sudo dnf install openssh

sudo dnf install zathura zathura-plugins-all
sudo dnf install awscli2
sudo dnf install texlive-scheme-medium

gsettings set org.gnome.desktop.input-sources xkb-options "['compose:ralt', 'ctrl:nocaps']"

sudo ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/10-sub-pixel-rgb.conf

$HOME/.dotfiles/linux/install_clipboard_sync.sh

# 3. Swap ffmpeg-free for the full-featured ffmpeg
# This replaces the limited Fedora version with the one supporting NVENC/NVDEC and QuickSync
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

# 4. Install Intel & NVIDIA Hardware Acceleration Drivers (VA-API/VDPAU)
# intel-media-driver is the optimized non-free driver for 8th+ gen Intel CPUs
# nvidia-vaapi-driver allows NVIDIA to work with VA-API applications
sudo dnf install -y \
    intel-media-driver \
    libva-utils \
    vdpauinfo \
    nvidia-vaapi-driver \
    libva-nvidia-driver

# 5. Install the complete GStreamer Suite
# We include 'freeworld' and 'ugly' versions which contain the optimized/proprietary codecs
sudo dnf install -y \
    gstreamer1 \
    gstreamer1-plugins-base \
    gstreamer1-plugins-base-tools \
    gstreamer1-plugins-good \
    gstreamer1-plugins-good-extras \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    gstreamer1-plugins-ugly-free \
    gstreamer1-plugin-libav \
    gstreamer1-vaapi \
    gstreamer1-libcamera

# 6. Install Multimedia Group (Standardized Metadata and Codecs)
# This ensures system-wide support for all container types
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# 7. Development Headers (Only if you are compiling software)
sudo dnf install -y gstreamer1-devel gstreamer1-plugins-base-devel

dnf copr enable lihaohong/yazi
dnf install yazi

echo "Installation complete. Please reboot to ensure drivers are fully loaded."
