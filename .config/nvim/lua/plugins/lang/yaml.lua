return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "yamlls" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "yamllint" } },
  },
  -- YAML LSP
  -- Provides LSP support for YAML files.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false, -- Disable key ordering enforcement
            },
          },
        },
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses yamllint for linting.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
  },
}
