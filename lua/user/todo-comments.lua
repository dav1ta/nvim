-- TodoComments quick cues:
-- 1. `:TodoQuickFix` → collect TODO/FIXME hits into the quickfix list.
-- 2. `:TodoTrouble` → browse todo items with the Trouble UI when triaging.
-- 3. `:TodoTelescope` → fuzzy-search todos across the repo on demand.
-- 4. `]t` / `[t` → jump to next/previous todo inline while reading code.
-- 5. Add `FIX`, `NOTE`, etc. under `keywords` below to highlight custom tags.
-- 6. Shift `highlight.keyword` to `fg` if the background color feels too loud.
-- 7. Tweak `search.pattern` when you only want uppercase annotations.

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
