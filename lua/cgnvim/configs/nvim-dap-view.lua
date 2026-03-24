---@module 'dap-view'
-- for configuration options see:
-- https://igorlfs.github.io/nvim-dap-view/configuration
local M = {

  -- Auto open when a session is started and auto close when all sessions finish
  -- Alternatively, can be a string:
  -- - "keep_terminal": as above, but keeps the terminal when the session finishes
  -- - "open_term": open the terminal when starting a new session, nothing else
  auto_toggle = true,

  -- Reopen dapview when switching to a different tab
  -- Can also be a function to dynamically choose when to follow, by returning a boolean
  -- If a function, receives the name of the adapter for the current session as an argument
  follow_tab = false,
}

return M
