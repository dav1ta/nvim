local M = {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "github/copilot.vim",
    "nvim-lua/plenary.nvim",
  },
  build = "make tiktoken",
  cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatClose", "CopilotChatToggle" },
  event = "VeryLazy",
}

function M.config()
  local select = require("CopilotChat.select")
  local chat = require("CopilotChat")
  chat.setup({
    model = "claude-sonnet-4",
    chat_autocomplete = false,
    selection = select.visual,
    remember_as_sticky = false,
    -- Add a prompt tailored for minimal in-place edits
    prompts = {
      Explain = {
        prompt = "Explain what this code does.",
        system_prompt = "COPILOT_EXPLAIN",
      },
      Optimize = {
        prompt = "Optimize this code for performance and readability.",
        system_prompt = "COPILOT_BASE",
      },
      InlineFix = {
        description = "Rewrite selection to complete/fix it (minimal diff)",
        prompt = table.concat({
          "You are editing code in place.",
          "Rewrite the selected code to complete the function and fix issues.",
          "Keep the function signature and external behavior stable.",
          "Follow project style. Return only a minimal diff of changes.",
        }, "\n"),
        system_prompt = "COPILOT_BASE",
      },
    },
  })

  -- Helpful keymaps for common chat actions and in-place workflows
  local wk_ok, wk = pcall(require, "which-key")
  local maps = {
    { "<leader>ao", "<cmd>CopilotChatOpen<cr>",   desc = "CopilotChat Open" },
    { "<leader>at", "<cmd>CopilotChatToggle<cr>",  desc = "CopilotChat Toggle" },
    { "<leader>aP", "<cmd>CopilotChatPrompts<cr>", desc = "CopilotChat Prompts" },
    { "<leader>aM", "<cmd>CopilotChatModels<cr>",  desc = "CopilotChat Models" },
    -- Visual-mode helpers
    { "<leader>ae", function() chat.ask("#selection /Explain") end,    mode = "v", desc = "Explain selection" },
    { "<leader>af", function() chat.ask("#selection /Fix") end,        mode = "v", desc = "Fix selection" },
    { "<leader>ai", function() chat.ask("#selection /InlineFix") end,  mode = "v", desc = "Inline fix selection" },
  }
  if wk_ok then
    wk.add(maps)
  else
    for _, m in ipairs(maps) do
      local lhs, rhs, opts = m[1], m[2], { silent = true, noremap = true, desc = m.desc }
      if m.mode then
        vim.keymap.set(m.mode, lhs, rhs, opts)
      else
        vim.keymap.set("n", lhs, rhs, opts)
      end
    end
  end
end

return M
