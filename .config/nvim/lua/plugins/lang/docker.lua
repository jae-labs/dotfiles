return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "dockerls" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "hadolint" } },
  },
  -- Docker LSP
  -- Provides LSP support for Dockerfiles.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        hadolint = {},
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses hadolint for linting Dockerfiles.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}
