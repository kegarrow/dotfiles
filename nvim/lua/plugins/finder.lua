-- ==============================================================================
-- PLUGINS: FUZZY FINDER & SEARCH (Telescope)
-- ==============================================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- File Pickers
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find Files (Root)" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Open Buffers" },
      { "<leader>fn", "<cmd>enew<CR>", desc = "New Buffer" },

      -- Search & Grep Pickers
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep (Workspace)" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep Word Under Cursor" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy Search in Buffer" },

      -- Git Pickers
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },

      -- LSP & Diagnostic Pickers
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Document Diagnostics" },
      { "<leader>fD", "<cmd>Telescope diagnostics<CR>", desc = "Workspace Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace Symbols" },

      -- Neovim Helpers
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Documentation" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
      { "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<CR>", desc = "Change Colorscheme" },
      { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume Last Picker" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.88,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
            },
            n = {
              ["q"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "%.cache",
            "%.lock",
            "target/",
            "dist/",
            "build/",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      }
    end,
  },
}
