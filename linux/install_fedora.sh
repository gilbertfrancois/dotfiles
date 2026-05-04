sudo dnf install htop
sudo dnf install libappindicator-gtk3 gnome-shell-extension-appindicator gnome-extensions-app
sudo dnf install openssh
sudo dnf install gstreamer1
sudo dnf install gstreamer1-devel gstreamer1-plugins-base-tools gstreamer1-doc gstreamer1-plugins-base-devel gstreamer1-plugins-good gstreamer1-plugins-good-extras gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-devel gstreamer1-plugins-bad-free-extras

sudo dnf install \\
gstreamer1 \\
gstreamer1-plugins-base \\
gstreamer1-plugins-base-tools \\
gstreamer1-plugins-good \\
gstreamer1-plugins-bad-free \\
gstreamer1-plugins-bad-free-extras \\
gstreamer1-plugins-ugly-free \\
gstreamer1-plugin-openh264 \\
gstreamer1-plugin-libav \\
gstreamer1-vaapi \\
libva \\
libva-utils
: 1772975662:0
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-pluginsudo dnf install libva-nvidia-driver

sudo dnf install gstreamer1
sudo dnf install dnf install gstreamer1-vaapi
sudo dnf install libcamera-gstreamer
sudo dnf install gstreamer1-plugins-good-extras
sudo dnf install gstreamer1-plugins-bad-extras
sudo dnf install gstreamer1-plugins-ugly-extras
sudo dnf install gstreamer1-plugins-ugly-free-extras
sudo dnf install gstreamer1-plugins-bad-free-extras
sudo dnf install lm_sensors
sudo dnf install oathtool
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf install gstreamer1-plugin-libav
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-pluginsudo dnf install gstreamer1-plugin-libav
sudo dnf install gstreamer1-plugin-libav
sudo dnf swap ffmpeg-free ffmpeg --allowerasingsudo dnf install \\
sudo dnf makecache --refresh
sudo dnf swap ffmpeg-free ffmpeg --allowerasingsudo dnf copr enable lihaohong/yazi && sudo dnf install yazi
sudo dnf copr enable dejan/lazygitsudo dnf install fastfetch
sudo dnf update
sudo dnf update
sudo dnf search btop
sudo dnf install btop
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf remove docker \\
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo dnf config-manager --enable nvidia-container-toolkit-experimental
sudo dnf config-manager --disable nvidia-container-toolkit-experimental
sudo dnf config-manager setopt nvidia-container-toolkit-experimental.enabled=0
sudo dnf update
sudo dnf install texlive-scheme-medium
sudo dnf search zathura
sudo dnf install zathura zathura-plugins-all
sudo dnf install ansible
sudo dnf install awscli2
