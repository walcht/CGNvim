for da, _ in vim.fs.dir("/home/walcht/.config/nvim/lua/cgnvim/daps") do
  local status_ok, error_object = pcall(require, "cgnvim.daps." .. da:gsub("%.lua", ""))
  if not status_ok then
    print("Failed to load DAP: " .. da .. "\n\n" .. "Reason: " .. error_object)
  end
end
