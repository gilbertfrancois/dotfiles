hl.on("hyprland.start", function()
	-- Chain systemd/D-Bus initialization sequentially to prevent race conditions,
	-- then explicitly restart the portal once the environment is ready.
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start graphical-session.target && systemctl --user restart xdg-desktop-portal"
	)
	hl.exec_cmd("~/.config/kitty/watch-theme.sh")

	-- Start your shell launcher/panels
	hl.exec_cmd("qs -c noctalia-shell")
end)
