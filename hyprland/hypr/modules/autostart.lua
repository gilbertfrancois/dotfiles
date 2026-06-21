hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c noctalia-shell")
	hl.exec_cmd("protonvpn disconnect && protonvpn connect --country CH")
end)
