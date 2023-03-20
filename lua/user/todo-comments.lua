
local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
  print("todo-comments not found")
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
