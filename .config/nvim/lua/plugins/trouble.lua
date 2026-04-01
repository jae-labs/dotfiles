return {
    -- Trouble
    -- Pretty diagnostics, references, telescope results, quickfix and location list
    -- Provides a clean interface to view and navigate code issues and references
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            -- Toggle the diagnostics list for the current document
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            -- Toggle the diagnostics list for the entire workspace
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            -- Toggle location list
            { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
            -- Toggle quickfix list
            { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
        },
    },
}
