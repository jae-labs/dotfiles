return {
  -- Search Pulse (Visual feedback for search)
  { "inside/vim-search-pulse" },

  -- Lualine
  -- A blazing fast and easy to configure statusline plugin for Neovim.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons
      -- Customize the 'z' section (far right) to show location
      opts.sections.lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      }
    end,
  },
}
