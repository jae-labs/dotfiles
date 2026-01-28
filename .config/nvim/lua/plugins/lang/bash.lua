return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "bash" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "bashls" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "shellcheck", "shfmt" } },
  },
  -- Bash LSP
  -- Provides LSP support for Bash scripts.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  -- Conform - Formatter
  -- Uses shfmt for formatting.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses shellcheck for linting.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
    },
  },
}
