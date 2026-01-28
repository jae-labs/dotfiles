return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "jsonls" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "jsonlint" } },
  },
  -- JSON LSP
  -- Provides LSP support for JSON files.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {},
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses jsonlint for linting.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        json = { "jsonlint" },
      },
    },
  },
}
