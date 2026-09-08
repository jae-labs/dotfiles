return {
  -- Disable LazyVim's codelens <leader>cc so NerdCommenter can use it
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>cc", false, mode = { "n", "x" } },
          },
        },
      },
    },
  },

  -- NERDCommenter
  {
    "preservim/nerdcommenter",
    lazy = false,
    init = function()
      vim.g.NERDCreateDefaultMappings = 0
    end,
    config = function()
      vim.keymap.set("n", "<leader>cc", "<plug>NERDCommenterComment", { desc = "Comment line" })
      vim.keymap.set("v", "<leader>cc", "<plug>NERDCommenterComment", { desc = "Comment selection" })
      vim.keymap.set("n", "<leader>cu", "<plug>NERDCommenterUncomment", { desc = "Uncomment line" })
      vim.keymap.set("v", "<leader>cu", "<plug>NERDCommenterUncomment", { desc = "Uncomment selection" })
    end,
  },
}
