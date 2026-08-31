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

  -- Terraform LSP: Enabled for all projects except those with the OCI provider
  -- The oracle/oci provider is massive (~250 MB binary, 7 MB schema) and causes
  -- terraform-ls initialization/indexing to freeze Neovim.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
      setup = {
        terraformls = function(_, opts)
          -- Return true so LazyVim / mason-lspconfig doesn't auto-enable terraformls globally
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "terraform", "terraform-vars" },
            group = vim.api.nvim_create_augroup("terraformls_conditional_start", { clear = true }),
            callback = function(ev)
              local fname = vim.api.nvim_buf_get_name(ev.buf)
              if not fname or fname == "" then
                return
              end
              local normalized = vim.fs.normalize(fname)
              local root = vim.fs.root(ev.buf, { ".terraform", ".git" })

              -- Skip if OCI provider is present in the workspace .terraform directory
              if root and vim.uv.fs_stat(root .. "/.terraform/providers/registry.terraform.io/oracle") then
                return
              end

              -- Otherwise, start terraformls for this buffer
              vim.lsp.start(vim.tbl_extend("keep", opts or {}, {
                name = "terraformls",
                cmd = { "terraform-ls", "serve" },
                root_dir = root or vim.fs.dirname(normalized),
              }), { bufnr = ev.buf })
            end,
          })
          return true
        end,
      },
    },
  },
}
