return {
  -- Global conform.nvim configuration
  -- This consolidates all formatters and enables format-on-save for specific file types
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },
        -- Shell
        sh = { "shfmt" },
        -- Terraform
        terraform = { "terraform_fmt" },
        -- Ansible
        ["yaml.ansible"] = { "ansible-lint" },
        -- Ruby
        ruby = { "rubocop" },
        -- TypeScript/JavaScript
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        -- Python
        python = { "black" },
        -- Rust
        rust = { "rustfmt" },
        -- YAML
        yaml = { "prettier" },
        -- JSON
        json = { "prettier" }
      },
      formatters = {
        rubocop = {
          args = { "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" }
        },
      }
    },
  },
}
