return {
  -- Add ansiblels to Mason auto-install and setup
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "ansiblels")
      return opts
    end,
    config = function()
      -- Setup ansiblels with correct config after Mason loads
      vim.defer_fn(function()
        local lspconfig = require("lspconfig")
        if lspconfig.ansiblels then
          lspconfig.ansiblels.setup({
            cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/ansible-language-server'), '--stdio' },
            filetypes = { 'yaml.ansible' },
            root_dir = function(fname)
              local util = require('lspconfig.util')
              return util.root_pattern('ansible.cfg', '.ansible-lint')(fname) or vim.fn.fnamemodify(fname, ':h')
            end,
            settings = {
              ansible = {
                python = {
                  interpreterPath = 'python',
                },
                ansible = {
                  path = 'ansible',
                },
                executionEnvironment = {
                  enabled = false,
                },
                validation = {
                  enabled = true,
                  lint = {
                    enabled = true,
                    path = 'ansible-lint',
                  },
                },
              },
            },
            single_file_support = true,
          })
        end
      end, 1000)
    end,
  },
}
