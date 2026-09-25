-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Blackhole register mappings
-- These mappings allow you to delete (d, D), change (c, C), or delete character (x, X)
-- without overwriting your current clipboard/register content.
-- The '"_' register is the blackhole register; data sent there is discarded.
map("n", "d", '"_d') -- Delete to blackhole
map("n", "D", '"_D') -- Delete line to blackhole
--map("n", "c", '"_c') -- Change to blackhole
--map("n", "C", '"_C') -- Change line to blackhole
map("n", "x", '"_x') -- Delete char to blackhole
map("n", "X", '"_X') -- Delete char backwards to blackhole

-- Toggle UI elements for copying
-- Ctrl+b: Disable line numbers and git gutter (if present) to make copying text easier.
-- This assumes 'GitGutterDisable' command exists (from vim-gitgutter plugin).
-- <cmd>...<CR> executes the command in command mode.
map("", "<C-b>", "<cmd>set nonu nornu | GitGutterDisable<CR>")

-- Diagnostic floating window
-- gl: Show diagnostic information in a floating window at cursor position
map("n", "gl", vim.diagnostic.open_float)

--  Undotree toggle mapping
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })

-- Run current Python file with horizontal split buffer
map("n", "<leader>r", function()
    vim.cmd("write")

    if vim.bo.filetype == "python" then
        vim.cmd("botright split | resize 30 | terminal python3 " .. vim.fn.shellescape(vim.fn.expand("%")))
    else
        vim.notify("Not a Python file", vim.log.levels.WARN)
    end
end, { desc = "Run current Python file" })

-- Close current window or terminal buffer
map("n", "<leader>q", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("bd!")
    else
        vim.cmd("close")
    end
end, { desc = "Close current window" })
