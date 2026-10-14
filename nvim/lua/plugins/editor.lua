-- ==============================================================================
-- PLUGINS: EDITOR ENHANCEMENTS & WORKFLOW PRODUCTIVITY
-- ==============================================================================

return {
  -- 1. Which-Key (Interactive Keybinding Legend & Menu)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "+Buffer" },
        { "<leader>c", group = "+Code / LSP" },
        { "<leader>d", group = "+Debug / DAP" },
        { "<leader>f", group = "+Find / Fuzzy" },
        { "<leader>g", group = "+Git" },
        { "<leader>h", group = "+Git Hunks" },
        { "<leader>q", group = "+Quit / Session" },
        { "<leader>t", group = "+Toggle / Terminal" },
        { "<leader>w", group = "+Window / Splits" },
        { "<leader>x", group = "+Trouble / Diagnostics" },
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
    },
  },

  -- 2. Nvim-Autopairs (Automatic Delimiter Matching)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- Hook into cmp for automatic function parentheses
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- 3. Nvim-Surround (Add/Change/Delete Parentheses, Brackets & HTML Tags)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- 4. Comment.nvim (Smart Code Commenting)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- 5. Todo-Comments (Highlight & Search TODO/FIXME/NOTE)
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO Comment" },
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs (Telescope)" },
      { "<leader>xt", "<cmd>TodoQuickFix<CR>", desc = "TODOs (Quickfix)" },
    },
    opts = {
      signs = true,
    },
  },

  -- 6. Flash.nvim (Lightning-Fast Jump Navigation)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash Remote" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- 7. Persistence.nvim (Session Restoration)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session (CWD)" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
