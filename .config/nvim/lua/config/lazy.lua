local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- add LazyVim and import its plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- import/override with your plugins
        { import = "plugins" },
        {
            "folke/snacks.nvim",
            opts = {
                dashboard = { enabled = false },
            },
        },
    },
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = true,
        -- version = "*", -- try installing the latest stable version for plugins that support semver
        version = "*", -- always use the latest git commit
        -- Install missing plugins automatically
        install = {
            missing = true,
            colorscheme = { "tokyonight" },
        },
        ui = {
            border = "rounded", -- Better visual appearance
            title = "Lazy", -- Clear window titles
        },
    },
    checker = {
        enabled = false, -- check for plugin updates periodically
        -- frequency = 3600,  -- Check every hour instead of default
        -- notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip", -- disable gzip compression
                -- "matchit", -- enable matchit plugin
                -- "matchparen", -- enable matchparen plugin
                -- "netrwPlugin", -- enable netrw plugin
                "tarPlugin", -- disable tar plugin
                "tohtml", -- disable tohtml plugin
                "tutor", -- disable tutor plugin
                "zipPlugin", -- disable zip plugin
            },
        },
        -- Add cache configuration:
        cache = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/lazy/cache",
        },
    },
})
