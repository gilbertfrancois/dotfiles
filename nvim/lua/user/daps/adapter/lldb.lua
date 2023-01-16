-- Adjust the path to your executable
local codelldb = require("user.utils.codelldb")

local dap = require("dap")

dap.adapters.codelldb = {
  type = "server",
  port = "13000",
  executable = {
    -- CHANGE THIS to your path!
    command = "/Users/gilbert/.local/share/nvim/lib/extension/adapter/codelldb",
    args = { "--port", "13000" },

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}
