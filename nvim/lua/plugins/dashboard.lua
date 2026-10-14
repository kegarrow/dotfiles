-- ==============================================================================
-- PLUGINS: IDE STARTUP DASHBOARD (alpha-nvim)
-- ==============================================================================

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                Enterprise IDE Edition
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.header.opts.hl = "AlphaHeader"

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
        dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Live Grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<CR>"),
        dashboard.button("l", "󰒲  Lazy Plugins", "<cmd>Lazy<CR>"),
        dashboard.button("m", "󱌢  Mason Toolchains", "<cmd>Mason<CR>"),
        dashboard.button("q", "  Quit IDE", "<cmd>qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local v = vim.version()
        local version_str = string.format("v%d.%d.%d", v.major, v.minor, v.patch)
        return string.format("⚡ Neovim %s  •    %d plugins loaded in %.1fms", version_str, stats.loaded, stats.startuptime)
      end
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1] = { type = "padding", val = 2 }
      return dashboard
    end,
    config = function(_, opts)
      -- TokyoNight-compatible custom highlights
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#c0caf5" })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ff9e64", bold = true })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#565f89", italic = true })

      require("alpha").setup(opts.opts or opts)

      -- Auto-close alpha when opening a file from command line
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          pcall(vim.cmd, "AlphaRedraw")
        end,
      })
    end,
  },
}
