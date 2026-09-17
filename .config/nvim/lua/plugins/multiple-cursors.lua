return {
    -- Multiple Cursors
    -- Simulate VS Code-style multiple cursors for simultaneous editing
    -- Keybindings: Ctrl+J/K, Ctrl+Up/Down, Leader+A, etc.
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*", -- Use the latest tagged version
        opts = {}, -- This causes the plugin setup function to be called
        keys = {
            { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor and move down" },
            { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "Add cursor and move up" },

            { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
            {
                "<C-Down>",
                "<Cmd>MultipleCursorsAddDown<CR>",
                mode = { "n", "i", "x" },
                desc = "Add cursor and move down",
            },

            {
                "<C-LeftMouse>",
                "<Cmd>MultipleCursorsMouseAddDelete<CR>",
                mode = { "n", "i" },
                desc = "Add or remove cursor",
            },

            { "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Add cursors to cword" },
            {
                "<Leader>A",
                "<Cmd>MultipleCursorsAddMatchesV<CR>",
                mode = { "n", "x" },
                desc = "Add cursors to cword in previous area",
            },
            -- Visual-mode: Ctrl-N (like vip + <C-n>) adds cursors to each selected line
            {
                "<C-n>",
                "<Cmd>MultipleCursorsAddVisualArea<CR>",
                mode = { "x" },
                desc = "Add cursors to lines of visual area",
            },
            {
                "<Leader>d",
                "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
                mode = { "n", "x" },
                desc = "Add cursor and jump to next cword",
            },
            { "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },

            { "<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock virtual cursors" },
        },
    },
}
