cp -r ~/.config ~/.config_backup
dconf reset -f /
rm -rf ~/.local/share/gnome-shell/extensions
rm -rf ~/.config/nautilus
rm -rf ~/.local/share/nautilus
