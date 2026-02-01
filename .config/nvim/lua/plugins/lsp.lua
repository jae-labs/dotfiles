return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Ansible
                ansiblels = {},

                -- Kubernetes/Helm
                helm_ls = {},

                -- Ruby
                ruby_lsp = {},
                rubocop = {},

                -- Bash
                bashls = {},

                -- Go
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

                -- Docker
                dockerls = {},
                hadolint = {},

                -- JSON
                jsonls = {},

                -- Python
                pyright = {},

                -- TypeScript/JavaScript
                vtsls = {
                    -- explicitly add default filetypes, so that we can extend
                    -- them in related extras
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                        "typescript",
                        "typescriptreact",
                        "typescript.tsx",
                    },
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            enableMoveToFileCodeAction = true, -- Enable move to file code action
                            autoUseWorkspaceTsdk = true, -- Use workspace TypeScript version
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true, -- Enable fuzzy matching
                                },
                            },
                        },
                        typescript = {
                            updateImportsOnFileMove = { enabled = "always" }, -- Auto update imports
                            suggest = {
                                completeFunctionCalls = true, -- Complete function calls with parentheses
                            },
                            -- Enable inlay hints
                            -- Default: false (in most configs)
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                        },
                    },
                },
                eslint = {
                    settings = {
                        -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
                        workingDirectories = { mode = "auto" },
                    },
                },

                -- YAML
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false, -- Disable key ordering enforcement
                        },
                    },
                },
            },
            setup = {
                vtsls = function(_, opts)
                    -- copy typescript settings to javascript
                    opts.settings.javascript =
                        vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
                end,
            },
        },
        config = function()
            -- Setup terraform LSP with traditional method
            local lspconfig = require('lspconfig')

            lspconfig.terraformls.setup({
                cmd = { "terraform-ls", "serve" },
                filetypes = { "terraform", "tf", "terraform-vars" },
                root_dir = function(fname)
                    return require('lspconfig.util').root_pattern('.git', '.terraform')(fname) or vim.fn.getcwd()
                end,
                autostart = false,  -- We'll trigger manually
            })

            lspconfig.tflint.setup({
                cmd = { "tflint", "--langserver" },
                filetypes = { "terraform", "tf" },
                root_dir = function(fname)
                    return require('lspconfig.util').root_pattern('.git', '.terraform')(fname) or vim.fn.getcwd()
                end,
                autostart = false,  -- We'll trigger manually
            })

            -- Create autocommand to start LSP for Terraform files
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = {"*.tf", "*.tfvars", "*.terraform"},
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    local root_dir = require('lspconfig.util').root_pattern('.git', '.terraform')(fname) or vim.fn.getcwd()

                    -- Start terraformls
                    vim.lsp.start({
                        name = "terraformls",
                        cmd = { "terraform-ls", "serve" },
                        root_dir = root_dir,
                        bufnr = bufnr,
                    })

                    -- Start tflint
                    vim.lsp.start({
                        name = "tflint",
                        cmd = { "tflint", "--langserver" },
                        root_dir = root_dir,
                        bufnr = bufnr,
                    })
                end,
            })
        end,
    },

    -- Rustaceanvim plugin
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        ft = { "rust" },
    },
}
