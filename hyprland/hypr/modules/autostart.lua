hl.on("hyprland.start", function()
	-- noctalia-qs-legacy's `qs -c noctalia-shell` links against Qt's private
	-- API, which breaks on every Qt point release until the copr rebuilds it.
	-- The standalone noctalia-git binary avoids that fragility.
	hl.exec_cmd("noctalia -d")
	hl.exec_cmd("command -v protonvpn && protonvpn disconnect && protonvpn connect --country CH || true")

	-- hypridle only exists to lock the session before suspend (see
	-- hypridle.conf) -- nothing else starts it.
	hl.exec_cmd("hypridle")

	-- Block logind's own lid-switch handling so modules/lid.lua is the
	-- sole authority over lid close/open (clamshell mode, custom suspend).
	-- Released automatically when Hyprland exits.
	hl.exec_cmd(
		"systemd-inhibit --what=handle-lid-switch --who=Hyprland --why='Custom clamshell/lid handling' --mode=block sleep infinity"
	)
end)
