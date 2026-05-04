#!/bin/bash
: <<'DOC'
OPTIMIZED MULTIMEDIA & HARDWARE ACCELERATION INSTALLER
------------------------------------------------------
TARGET SYSTEM: Fedora Linux (FC43+)
HARDWARE:      Intel Gen10 (Comet Lake) + NVIDIA Quadro (P3551 / Optimus)
INTENT:        Replace limited "Free" implementations with high-performance, 
               proprietary, and hardware-accelerated binaries.

ARCHITECTURE OVERVIEW:
1. REPOSITORIES: Enables RPM Fusion (Free/Non-Free) to access patented codecs.
2. CLEANUP: Purges 'ffmpeg-free' and legacy 'i965' drivers which are 
   less optimized for 10th Gen Intel silicon.
3. MESA SWAP: Replaces crippled Mesa drivers with 'freeworld' versions to 
   unlock H.264/H.265 hardware decoding on the Intel iGPU.
4. FFMPEG SWAP: Replaces 'ffmpeg-free' with full 'ffmpeg' to enable NVENC 
   (NVIDIA Encoder) and NVDEC (NVIDIA Decoder) support.
5. GSTREAMER: Installs the 'bad-freeworld' and 'ugly' sets which contain 
   optimized wrappers for hardware-specific pipelines.
6. NVIDIA BRIDGE: Configures 'libva-nvidia-driver' for VA-API compatibility 
   and 'nv-codec-headers' for native NVENC/CUDA access.

VERIFICATION:
- Intel:  'vainfo' (should show iHD driver + VAEntrypointEncSlice)
- NVIDIA: 'export LIBVA_DRIVER_NAME=nvidia && vainfo'
- GStreamer: 'gst-inspect-1.0 | grep nvcodec'
DOC

# 1. PRE-REQUISITE: Enable RPM Fusion (Free and Non-Free)
# We do this first so the 'swap' commands have a source to pull from.
echo "--- Enabling RPM Fusion Repositories ---"
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf makecache --refresh

# 2. CLEANUP: Remove less-optimized/legacy packages
# libva-intel-driver is the old i965 driver. We want the iHD (intel-media-driver).
# mesa-va-drivers-free lacks many proprietary hardware acceleration paths.
echo "--- Removing legacy and limited 'Free' drivers ---"
sudo dnf remove -y \
    libva-intel-driver \
    libva-intel-hybrid-driver \
    mesa-va-drivers \
    mesa-vdpau-drivers

# 3. SWAP: FFmpeg and Mesa to 'Freeworld' and Full versions
# This is the most critical step for GStreamer performance.
echo "--- Swapping to optimized FFmpeg and Mesa Freeworld ---"
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# 4. INSTALL: High-Performance Intel & NVIDIA Drivers
# intel-media-driver (iHD) is the optimized one for your 10th Gen CPU.
echo "--- Installing high-performance Hardware Acceleration drivers ---"
sudo dnf install -y \
    intel-media-driver \
    libva-utils \
    vdpauinfo \
    libva-nvidia-driver \
    nv-codec-headers \
    vulkan-loader

# 5. INSTALL: Full GStreamer Stack
# We include 'freeworld' and 'ugly' which contain the proprietary optimized code.
echo "--- Installing GStreamer with all proprietary plugins ---"
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
    nv-codec-headers \
    libcamera-gstreamer

# 6. SYSTEM-WIDE CONFIG: Multimedia Group
echo "--- Finalizing Multimedia Group Update ---"
sudo dnf group upgrade -y multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Clears the GStreamer cache so it rescans and finds the new 'nvcodec' and 'freeworld' plugins
rm -rf ~/.cache/gstreamer-1.0

echo "--------------------------------------------------------"
echo "DONE! Please reboot to initialize the iHD and NVIDIA VA-API drivers."
echo "To verify Intel: run 'vainfo' and look for 'iHD driver'."
echo "To verify NVIDIA: run 'export LIBVA_DRIVER_NAME=nvidia && vainfo'."
