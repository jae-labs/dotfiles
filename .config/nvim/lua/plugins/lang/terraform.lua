return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "terraform", "hcl" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "terraformls", "tflint" },
    },
  },
  -- Terraform LSP
  -- Provides LSP support for Terraform.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
        tflint = {},
      },
    },
  },
  -- Vim-Terraform
  -- Syntax highlighting and indentation for Terraform.
  {
    "hashivim/vim-terraform",
    ft = { "terraform" },
  },
  -- Conform - Formatter
  -- Uses terraform_fmt for formatting.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
  },
  -- Nvim-lint - Linter
  -- Uses tflint for linting.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },
}
