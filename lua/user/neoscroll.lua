function setup()
  local status_ok, neoscroll = pcall(require, "neoscroll")
  if not status_ok then
    print("neoscroll not found")
    return
  end

  neoscroll.setup({
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
  })
end

return { setup = setup }
