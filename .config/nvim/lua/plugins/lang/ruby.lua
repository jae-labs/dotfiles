return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ruby" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ruby_lsp", "rubocop" },
    },
  },
  -- Ruby LSP
  -- Provides LSP support for Ruby.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {},
        rubocop = {},
      },
    },
  },
  -- Conform - Formatter
  -- Uses Rubocop for formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses Rubocop for linting
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ruby = { "rubocop" },
      },
    },
  },
}
