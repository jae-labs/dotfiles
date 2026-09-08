return {
  -- Plugin to profile Neovim startup performance and identify bottlenecks
  -- Use :StartupTime command to generate detailed timing reports
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
