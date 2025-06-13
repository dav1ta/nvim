local M = {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatClose", "CopilotChatToggle" },
  event = "VeryLazy",
}

function M.config()
  local select = require("CopilotChat.select")
  require("CopilotChat").setup({
    model = "claude-3.5-sonnet",
    chat_autocomplete = false,
    selection = select.visual,
    remember_as_sticky = false,
    prompts = {
      Explain = {
        prompt = "Explain what this code does.",
        system_prompt = "COPILOT_EXPLAIN",
      },
      Optimize = {
        prompt = "Optimize this code for performance and readability.",
        system_prompt = "COPILOT_BASE",
      },
    },
  })
end

return M
