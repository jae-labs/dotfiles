return {
  -- Treesitter configuration
  -- Centralized language parser configuration for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Shell
        "bash",
        -- Web development
        "typescript",
        "javascript",
        "tsx",
        -- Configuration languages
        "yaml",
        "json",
        "dockerfile",
        "terraform",
        "hcl",
        "helm",
        -- Programming languages
        "go",
        "gomod",
        "gowork",
        "gosum",
        "python",
        "rust",
        "ron",
        "ruby",
      },
    },
  },
}
