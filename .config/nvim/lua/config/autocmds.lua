-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Custom Filetype Detection using Autocmds
-- This approach uses BufRead autocmds to set filetype for Ansible files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
        "playbook*.yml", "playbook*.yaml",
        "*/playbook*.yml", "*/playbook*.yaml",
        "*/roles/*/tasks/*.yml", "*/roles/*/tasks/*.yaml",
        "*/roles/*/handlers/*.yml", "*/roles/*/handlers/*.yaml",
        "*/roles/*/vars/*.yml", "*/roles/*/vars/*.yaml",
        "*/roles/*/defaults/*.yml", "*/roles/*/defaults/*.yaml",
        "*/roles/**/*.yml", "*/roles/**/*.yaml",
        "*/group_vars/*.yml", "*/group_vars/*.yaml",
        "*/host_vars/*.yml", "*/host_vars/*.yaml",
        "*/inventory*.yml", "*/inventory*.yaml",
        "*/site.yml", "*/site.yaml",
        "site.yml", "site.yaml",
    },
    callback = function()
        vim.bo.filetype = "yaml.ansible"
    end,
})

-- Terraform Filetype Detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
        "*.tf", "*.tfvars", "*.terraform",
        "*/.terraformrc", "*/terraform.rc",
        "*.tfstate", "*.tfstate.backup",
    },
    callback = function()
        if vim.fn.expand('%:t'):match('%.tfstate') then
            vim.bo.filetype = "json"
        else
            vim.bo.filetype = "terraform"
        end
    end,
})
