return {
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
