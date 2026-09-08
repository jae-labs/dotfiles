return {
  -- Copilot: AI-powered code completion
  -- Provides inline ghost text suggestions as you type
  -- Authenticate on first use with :Copilot auth
  -- Only loads if ~/.nvim.lua.plugins.copilot.enabled exists (touch ~/.nvim.lua.plugins.copilot.enabled to enable)
  {
    "zbirenbaum/copilot.lua",
    cond = function()
      return vim.fn.filereadable(vim.fn.expand("~/.nvim.lua.plugins.copilot.enabled")) == 1
    end,
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        -- Show inline ghost text suggestions automatically
        -- Default: false
        enabled = true,
        -- Automatically show suggestions as you type
        -- Default: false
        auto_trigger = true,
        -- Keymaps for interacting with suggestions
        keymap = {
          -- Accept the current suggestion
          accept = "<Tab>",
          -- Cycle to the next suggestion
          next = "<M-]>",
          -- Cycle to the previous suggestion
          prev = "<M-[>",
          -- Dismiss the current suggestion
          dismiss = "<C-]>",
        },
      },
      -- Disable Copilot's built-in panel (we use inline suggestions)
      panel = {
        enabled = false,
      },
      -- Filetypes where Copilot is enabled/disabled
      -- true = disabled, false = enabled
      filetypes = {
        help = true,
        gitcommit = false,
        gitrebase = false,
        ["."] = false,
      },
    },
  },
}
