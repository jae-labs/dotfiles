return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "gopls" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "goimports", "gofumpt", "golangci-lint", "delve" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- Use gofumpt for stricter formatting
              -- Default: false
              gofumpt = true,
              -- Enable code lenses for various actions
              -- Default: varies, usually false for some
              codelenses = {
                gc_details = false, -- Show GC optimization details
                generate = true, -- Show 'go generate' lens
                regenerate_cgo = true,
                run_govulncheck = true, -- Run vulnerability check
                test = true, -- Show 'run test' lens
                tidy = true, -- Show 'go mod tidy' lens
                upgrade_dependency = true,
                vendor = true,
              },
              -- Enable inlay hints
              -- Default: false (in most configs)
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              -- Enable static analysis checks
              analyses = {
                fieldalignment = true, -- Check for struct field alignment (memory optimization)
                nilness = true, -- Check for redundant nil checks
                unusedparams = true, -- Check for unused parameters
                unusedwrite = true, -- Check for unused writes
                useany = true, -- Check for usage of 'any'
              },
              usePlaceholders = true, -- Add placeholders for function parameters
              completeUnimported = true, -- Autocomplete unimported packages
              staticcheck = true, -- Enable staticcheck
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true, -- Enable semantic token highlighting
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },
  {
    "leoluz/nvim-dap-go",
    config = true,
  },
}
