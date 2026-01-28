return {
  -- GitHub integration
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "squash",
      picker = "telescope",
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List Issues (Octo)" },
      { "<leader>gI", "<cmd>Octo issue search<cr>", desc = "Search Issues (Octo)" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs (Octo)" },
      { "<leader>gP", "<cmd>Octo pr search<cr>", desc = "Search PRs (Octo)" },
      { "<leader>gr", "<cmd>Octo repo list<cr>", desc = "List Repos (Octo)" },
      { "<leader>gS", "<cmd>Octo search<cr>", desc = "Search (Octo)" },
    },
  },

  -- GitLab integration
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
      "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in UI.
    },
    event = { "BufReadPre", "BufNewFile" }, -- Activate when a file is created/opened
    cmd = { "Gitlab" }, -- Activate when a command is executed
    opts = {
      statusline = {
        enabled = true, -- Hook into the builtin statusline to indicate the status of the GitLab integration
      },
    },
  },
}
