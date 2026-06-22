hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("command -v protonvpn && protonvpn disconnect && protonvpn connect --country CH || true")
end)
