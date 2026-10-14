-- ==============================================================================
-- PLUGINS: VERSION CONTROL & GIT INTEGRATION
-- ==============================================================================

return {
  -- 1. Gitsigns (Hunk gutter indicators, staging, blame & diffing)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Hunk Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git Hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous Git Hunk" })

        -- Hunk Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage Selected Hunk" })
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset Selected Hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Entire Buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Entire Buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk Popup" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame Line (Detailed)" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Inline Blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff Against Index" })

        -- Text Object for Hunks (e.g. 'dih' delete inner hunk)
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Git Hunk" })
      end,
    },
  },

  -- 2. LazyGit Terminal Interface
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit GUI" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit Current File History" },
    },
  },

  -- 3. Diffview (Interactive Diff and Merge Tool)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: Open Working Diff" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Diffview: Close Diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: Current File History" },
    },
  },

  -- 4. Git Conflict (Interactive 3-Way Merge Conflict Resolver)
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      default_mappings = true, -- co (ours), ct (theirs), cb (both), c0 (none), ]x, [x
      default_commands = true,
      disable_diagnostics = false,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
}
