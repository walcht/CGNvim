--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------

-- Open LSP log in a new tab
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

-- LSP information in a new tab
vim.api.nvim_create_user_command(
  "LspInfo",
  ":checkhealth vim.lsp",
  { desc = "LSP information (alias to :checkhealth vim.lsp)" }
)

vim.api.nvim_create_user_command("LspClearLog", function()
  io.open(vim.lsp.log.get_filename(), "w"):close()
end, {
  desc = "Clears the LSP log.",
})

vim.api.nvim_create_user_command("LspRestart", function(info)
  local client_names = info.fargs

  -- restart current buffer's LS
  if #client_names == 0 then
    client_names = vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :totable()
  end

  for name in vim.iter(client_names) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      print(name)
      vim.lsp.enable(name, false)
      if info.bang then
        vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
          client:stop(true)
        end)
      end
    end
  end

  ---@diagnostic disable-next-line: undefined-field
  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for name in vim.iter(client_names) do
      vim.schedule_wrap(vim.lsp.enable)(name)
    end
  end)
end, { desc = "Restart the given client" })
