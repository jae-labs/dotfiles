return {
  -- Mason LSP Config
  -- LSP servers are automatically installed via ensure_installed in each lang/*.lua file
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Individual language servers are configured in lua/plugins/lang/*.lua
      -- Each lang file specifies its own ensure_installed servers
      -- Automatically install LSP servers configured in opts.servers
      -- Default: false (in mason-lspconfig, but set to true here)
      automatic_installation = true,
    },
  },
}