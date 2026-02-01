return {
  -- Nvim-lint - Linter
  -- Provides linting for various file types.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        -- Ansible
        ansible = { "ansible_lint" },

        -- Ruby
        ruby = { "rubocop" },

        -- Shell/Bash
        sh = { "shellcheck" },

        -- Go
        go = { "golangcilint" },

        -- Docker
        dockerfile = { "hadolint" },

        -- JSON
        json = { "jsonlint" },

        -- TypeScript/JavaScript
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },

        -- Terraform
        terraform = { "tflint" },
        tf = { "tflint" },

        -- YAML
        yaml = { "yamllint" },
      },
    },
  },
}
