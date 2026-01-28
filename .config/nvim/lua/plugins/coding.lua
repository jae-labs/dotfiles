return {
  -- Copilot
  { "github/copilot.vim", lazy = false },

  -- Copilot Chat
  -- Chat with Copilot in Neovim.
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
  },

  -- NERDCommenter
  -- Comment/uncomment code with shortcuts
  {
    "preservim/nerdcommenter",
    lazy = false,
    config = function()
      -- Create default mappings
      vim.g.NERDCreateDefaultMappings = 0
      
      -- Custom keybindings
      vim.keymap.set("n", "<leader>cc", "<plug>NERDCommenterComment", { desc = "Comment line" })
      vim.keymap.set("v", "<leader>cc", "<plug>NERDCommenterComment", { desc = "Comment selection" })
      vim.keymap.set("n", "<leader>cu", "<plug>NERDCommenterUncomment", { desc = "Uncomment line" })
      vim.keymap.set("v", "<leader>cu", "<plug>NERDCommenterUncomment", { desc = "Uncomment selection" })
    end,
  },
}
