local M = {}

M.server_capabilities = function()
  local clients = vim.lsp.get_clients({})
  local client_index_by_name = {}

  for index, client in ipairs(clients) do
    client_index_by_name[client.name] = index
  end

  vim.ui.select(vim.tbl_keys(client_index_by_name), {
    prompt = "Select client:",
    format_item = function(item)
      return "capabilites for: " .. item
    end,
  }, function(choice)
    local client = clients[client_index_by_name[choice]]
    if not client then
      return
    end
    print(vim.inspect(client.server_capabilities.executeCommandProvider))
    vim.pretty_print(client.server_capabilities)
  end)
end

require("user.lsp.mason")
require("user.lsp.handlers").setup()


return M
