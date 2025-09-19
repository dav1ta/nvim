local function setup()
  local status_ok, todo = pcall(require, "todo-comments")
  if not status_ok then
    return
  end
  todo.setup({
      keywords = {
          TODO = { icon = " ", color = "error" },
      },
      highlight = {
          keyword = "bg",
          pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
          pattern = [[\b(KEYWORDS)]],
      },
  })
end

return {setup = setup}
