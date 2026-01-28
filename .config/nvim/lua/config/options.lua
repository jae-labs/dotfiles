-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Shell configuration
-- Sets the shell to use for executing commands.
-- Default: $SHELL or "sh"
vim.opt.shell = "/bin/zsh"

-- UI & VISUALS

-- Transparent background
-- Sets the highlight group 'Normal' to have no background color.
-- This allows your terminal's background image/color to show through.
-- Default: Depends on the colorscheme
vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })

-- Enable True Color support
-- Enables 24-bit RGB color in the TUI.
-- Default: false (uses 256 colors)
vim.opt.termguicolors = true

-- Background setting
-- Tells Neovim whether the background is 'dark' or 'light'.
-- Adjusts colorschemes to be readable on the specified background type.
-- Default: "dark"
vim.opt.background = "dark"

-- Line numbers
-- Show line numbers on the left side.
-- Default: false
vim.opt.number = true

-- Relative line numbers
-- Show relative line numbers (distance from cursor) instead of absolute ones.
-- Useful for jumping with motions like `10j`.
-- Default: false
vim.opt.relativenumber = false

-- Syntax highlighting
-- Enables syntax highlighting for code.
-- Default: off
vim.cmd("syntax enable")

-- Command completion mode
-- Enhanced command-line completion mode.
-- Shows a menu of completions when you press Tab in the command line.
-- Default: true (in Neovim defaults)
vim.opt.wildmenu = true

-- Compatibility for OSX Terminal Solarized
-- Specific setting for Solarized theme in some terminals.
-- Default: nil
vim.g.solarized_termtrans = 1

-- Error bells
-- Disable the audible beep when an error occurs.
-- Default: true (beeps)
vim.opt.errorbells = false

-- EDITOR BEHAVIOR

-- Word wrapping
-- Wrap long lines to the next line visually (does not insert newlines).
-- Default: true
vim.opt.wrap = true

-- Encoding
-- Sets the character encoding used inside Neovim.
-- Default: "utf-8"
vim.opt.encoding = "utf-8"

-- Regex engine
-- Selects the regular expression engine to use.
-- 1 = old engine, 2 = NFA engine.
-- Sometimes set to 1 to fix performance issues with certain syntax files.
-- Default: 0 (automatic selection)
vim.opt.regexpengine = 1

-- Backspace behavior
-- Configures how the backspace key works in Insert mode.
-- "indent": allow backspacing over autoindent
-- "eol": allow backspacing over line breaks (join lines)
-- "start": allow backspacing over the start of insert
-- Default: "indent,eol,start"
vim.opt.backspace = { "indent", "eol", "start" }

-- Indentation (Tabs = Spaces)

-- Expand tabs
-- Convert tabs to spaces.
-- Default: false
vim.opt.expandtab = true

-- Tab stop
-- Number of spaces that a <Tab> in the file counts for.
-- Default: 8
vim.opt.tabstop = 4

-- Shift width
-- Number of spaces to use for each step of (auto)indent.
-- Used for `>>`, `<<`, etc.
-- Default: 8
vim.opt.shiftwidth = 4

-- Format options
-- Controls automatic formatting of text.
-- remove "c": Do not auto-wrap comments using textwidth
-- remove "r": Do not automatically insert the current comment leader after hitting <Enter> in Insert mode
-- remove "o": Do not automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode
-- Default: "tcqj" (varies)
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- SEARCH SETTINGS

-- Ignore case
-- Ignore case when searching.
-- Default: false
vim.opt.ignorecase = true

-- Smart case
-- Override 'ignorecase' if the search pattern contains upper case characters.
-- Default: false
vim.opt.smartcase = true

-- Highlight search
-- Highlight all matches of the search pattern.
-- Default: true
vim.opt.hlsearch = true

-- Incremental search
-- Show search matches as you type.
-- Default: true
vim.opt.incsearch = true

-- SYSTEM / BACKUPS / UNDO

-- Backup files
-- Make a backup before overwriting a file.
-- Default: false
vim.opt.backup = false

-- Write backup
-- Make a backup before overwriting a file.
-- Default: true
vim.opt.writebackup = false

-- Swap file
-- Use a swap file for the buffer.
-- Default: true
vim.opt.swapfile = false

-- History size
-- Number of commands and search patterns to keep in the history.
-- Default: 10000 (Neovim default is higher now, but user set 1000)
vim.opt.history = 1000

-- Persistent Undo Storage
-- Save undo history to a file so it persists after closing Neovim.
local undo_path = vim.fn.expand("$HOME/.local/state/nvim/undo")
-- Create the directory if it doesn't exist
if vim.fn.isdirectory(undo_path) == 0 then
    vim.fn.mkdir(undo_path, "p", 0700)
end

-- Undo directory
-- Directory where undo files are stored.
-- Default: "."
vim.opt.undodir = undo_path

-- Undo file
-- Enable persistent undo.
-- Default: false
vim.opt.undofile = true

-- Terraform Plugin Variables
-- Automatically format Terraform files on save.
-- Default: 0
vim.g.terraform_fmt_on_save = 1

-- Align settings for Terraform.
-- Default: 0
vim.g.terraform_align = 1

-- The Master Switch
-- This tells Neovim: "Show me the invisible characters defined below."
vim.opt.list = true

-- Keep cursor centered vertically. Can also be done with 'zz' command.
-- Default: 0
vim.opt.scrolloff = 999

-- We use an autocmd because filetype plugins often force these
-- flags back on. This overwrites them for every file you open.

-- Autocmd to adjust 'formatoptions' for all file types
-- Removes 'o' and 'r' from 'formatoptions' to stop comment continuation.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        -- Remove 'o': Stop comment continuation when pressing 'o' or 'O'
        -- Remove 'r': Stop comment continuation when pressing 'Enter' (optional)
        vim.opt_local.formatoptions:remove({ "o", "r" })
    end,
})
