-- Globals shared across all modules
MAIN_MOD = "SUPER"
TERMINAL = "~/.local/bin/foot-launch"
BROWSER = "brave-browser --incognito"
FILE_MANAGER = "nautilus"
-- MENU = "noctalia msg panel-toggle launcher"
MENU = "qs -c noctalia-shell ipc call launcher toggle"

require("modules.autostart")
require("modules.monitor")
require("modules.input")
require("modules.appearance")
require("modules.keybinds")
require("modules.lid")
