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
--   - re-enable with the *same* mode/scale as the static config, not a bare
--     disabled=false. hl.monitor() calls aren't merged: a rule matched by
--     exact connector name ("eDP-1") outranks the desc:-matched static rule,
--     so a bare {output=INTERNAL, disabled=false} silently resets mode/scale
--     to preferred/auto on every lid reopen -- this is what caused the
--     wrong-resolution/too-large-scaling symptom after sleep.
--
-- External monitor unplugged while the lid stays closed (e.g. undocking a
-- Thunderbolt hub without reopening the lid first): if that was the last
-- external monitor, re-enable eDP-1 immediately instead of leaving the
-- machine with zero active outputs until the lid is next opened.

local INTERNAL = "eDP-1"
local INTERNAL_MONITORS = require("modules.monitor").internals

local function external_monitor_connected()
	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= INTERNAL then
			return true
		end
	end
	return false
end

-- modules/monitor lists one candidate spec per laptop this config runs on;
-- find the one matching the panel actually plugged in as eDP-1 (this still
-- works while eDP-1 is disabled -- disabling doesn't drop it from
-- hl.get_monitors(), only makes it inactive).
local function internal_spec()
	for _, m in ipairs(hl.get_monitors()) do
		if m.name == INTERNAL then
			for _, spec in ipairs(INTERNAL_MONITORS) do
				if spec.output == "desc:" .. m.description then
					return spec
				end
			end
		end
	end
	return nil
end

local function enable_internal()
	local spec = internal_spec()
	if not spec then
		hl.monitor({ output = INTERNAL, disabled = false })
		return
	end
	local cfg = {}
	for k, v in pairs(spec) do
		cfg[k] = v
	end
	cfg.disabled = false
	hl.monitor(cfg)
end

hl.bind("switch:on:Lid Switch", function()
	if external_monitor_connected() then
		hl.monitor({ output = INTERNAL, disabled = true })
	else
		hl.exec_cmd("systemctl suspend")
	end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	enable_internal()
end, { locked = true })

hl.on("monitor.removed", function()
	if not external_monitor_connected() then
		enable_internal()
	end
end)
