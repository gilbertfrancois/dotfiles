-- Custom lid-switch handling (Hyprland only reads the raw libinput switch
-- device; logind's own lid handling is blocked via a "handle-lid-switch"
-- inhibitor held in modules.autostart, so this is the sole owner of lid
-- close/open behavior).
--
-- Lid close:
--   - external monitor connected -> disable eDP-1 (Hyprland auto-migrates
--     its workspaces to the remaining monitor). Machine stays awake.
--   - no external monitor -> suspend. hypridle's before_sleep_cmd (see
--     hypridle.conf) locks the session first, regardless of what triggered
--     the suspend.
-- Lid open:
--   - always re-enable eDP-1 unconditionally. (A guard of "only if
--     hl.get_monitor(INTERNAL) == nil" was tried here first, on the theory
--     that a disabled monitor drops out of hl.get_monitors(); in practice
--     it silently blocked the re-enable -- eDP-1 stayed disabled across a
--     lid reopen until an unrelated monitor hotplug forced Hyprland to
--     reapply its static hl.monitor() config. hl.monitor() on an
--     already-enabled output is a harmless no-op, so there's no need for
--     a guard at all.)
--
-- External monitor unplugged while the lid stays closed (e.g. undocking a
-- Thunderbolt hub without reopening the lid first): if that was the last
-- external monitor, re-enable eDP-1 immediately instead of leaving the
-- machine with zero active outputs until the lid is next opened.

local INTERNAL = "eDP-1"

local function external_monitor_connected()
	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= INTERNAL then
			return true
		end
	end
	return false
end

hl.bind("switch:on:Lid Switch", function()
	if external_monitor_connected() then
		hl.monitor({ output = INTERNAL, disabled = true })
	else
		hl.exec_cmd("systemctl suspend")
	end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.monitor({ output = INTERNAL, disabled = false })
end, { locked = true })

hl.on("monitor.removed", function()
	if not external_monitor_connected() then
		hl.monitor({ output = INTERNAL, disabled = false })
	end
end)
