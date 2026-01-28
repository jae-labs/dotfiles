return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ansiblels" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "ansible-lint" } },
  },
  -- Ansible LSP
  -- Provides LSP support for Ansible playbooks.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ansiblels = {},
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses ansible-lint for linting.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ansible = { "ansible_lint" },
      },
    },
  },
}
