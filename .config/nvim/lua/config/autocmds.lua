-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Custom Filetype Detection
-- This block configures Neovim to recognize specific file extensions or filenames
-- and assign them the correct filetype for syntax highlighting and LSP support.
vim.filetype.add({
    -- Match by file extension
    extension = {
        tf = "terraform",       -- .tf files -> terraform filetype
        tfvars = "terraform",   -- .tfvars files -> terraform filetype
        hcl = "hcl",            -- .hcl files -> hcl filetype
        tfstate = "json",       -- .tfstate files -> json filetype
    },
    -- Match by exact filename
    filename = {
        [".terraformrc"] = "hcl", -- .terraformrc -> hcl filetype
        ["terraform.rc"] = "hcl", -- terraform.rc -> hcl filetype
    },
    -- Match by regex pattern
    pattern = {
        -- Match any file ending in .tfstate.backup -> json filetype
        [".*%.tfstate%.backup"] = "json",
    },
})
