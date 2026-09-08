return {
  -- Mason - LSP/DAP/Linter/Formatter manager
  {
    "mason-org/mason.nvim",
    config = function()
      local mason = require("mason")

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        },
        -- Auto-install tools when requested by other plugins
        automatic_installation = true,
      })

      -- Auto-install linters and formatters based on plugin configs
      local registry = require("mason-registry")

      -- Get linters from nvim-lint config
      local lint_config = require("lazy.core.config").plugins["nvim-lint"]
      local linters_to_install = {}

      if lint_config and lint_config.opts and lint_config.opts.linters_by_ft then
        for _, linters in pairs(lint_config.opts.linters_by_ft) do
          for _, linter in ipairs(linters) do
            linters_to_install[linter] = true
          end
        end
      end

      -- Get formatters from conform config
      local conform_config = require("lazy.core.config").plugins["conform.nvim"]
      if conform_config and conform_config.opts and conform_config.opts.formatters_by_ft then
        for _, formatters in pairs(conform_config.opts.formatters_by_ft) do
          for _, formatter in ipairs(formatters) do
            linters_to_install[formatter] = true
          end
        end
      end

      -- Install all detected tools, skipping ones that don't exist
      for tool, _ in pairs(linters_to_install) do
        local ok, pkg = pcall(registry.get_package, tool)
        if ok and pkg and not pkg:is_installed() then
          vim.defer_fn(function()
            pkg:install()
          end, 100)
        elseif not ok then
          -- Silently skip packages that don't exist in registry
          -- vim.notify("Skipping unknown Mason package: " .. tool, vim.log.levels.INFO)
        end
      end
    end,
  },

  -- Mason-lspconfig - Bridge between Mason and lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      -- Mason will auto-install LSP servers as needed
      automatic_installation = true,
    },
  },
}
