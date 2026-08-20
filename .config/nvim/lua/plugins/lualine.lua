return {
  -- Lualine
  -- A blazing fast and easy to configure statusline plugin for Neovim
  -- Customizable status line showing mode, file info, git status, and more
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
