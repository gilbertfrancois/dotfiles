hl.on("hyprland.start", function()
	-- hl.exec_cmd("noctalia")
	hl.exec_cmd("qs -c noctalia-shell")
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
