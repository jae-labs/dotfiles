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
