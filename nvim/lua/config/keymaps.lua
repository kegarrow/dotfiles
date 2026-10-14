-- ==============================================================================
-- CONFIG: KEYMAPS (Ergonomic IDE Shortcuts)
-- ==============================================================================
-- Leader key is Space (' ')

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ------------------------------------------------------------------------------
-- 1. GENERAL SHORTCUTS
-- ------------------------------------------------------------------------------
-- Fast Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save Buffer", unpack(opts) })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Window", unpack(opts) })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force Quit All", unpack(opts) })

-- Clear Search Highlights with Esc or <leader>h
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear Highlights", unpack(opts) })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear Highlights", unpack(opts) })

-- Create New Buffer
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New Empty Buffer", unpack(opts) })

-- Natural Navigation Over Wrapped Lines (smooth movement across wrapped viewport text)
map({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (Visual Line Aware)" })
map({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (Visual Line Aware)" })

-- Toggle Text Wrap in Viewport Dynamically
map("n", "<leader>tw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  local state = vim.opt.wrap:get() and "enabled" or "disabled"
  vim.notify("Text wrapping " .. state, vim.log.levels.INFO, { title = "Viewport Wrap" })
end, { desc = "Toggle Viewport Text Wrap", unpack(opts) })

-- Better Cursor Positioning
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down & Center Cursor", unpack(opts) })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up & Center Cursor", unpack(opts) })
map("n", "n", "nzzzv", { desc = "Next Search Result & Center", unpack(opts) })
map("n", "N", "Nzzzv", { desc = "Previous Search Result & Center", unpack(opts) })

-- Single character deletion without clobbering register
map("n", "x", '"_x', { desc = "Delete Character (No Yank)", unpack(opts) })

-- Delete without yanking into default register
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete (Black Hole Register)", unpack(opts) })

-- Preserve clipboard register when pasting over visual selection
map("x", "p", 'P', { desc = "Paste Over Selection Without Replacing Register", unpack(opts) })

-- ------------------------------------------------------------------------------
-- 2. WINDOW MANAGEMENT & SPLITS
-- ------------------------------------------------------------------------------
-- Navigate Between Windows (Ctrl + Vim Directions)
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", unpack(opts) })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", unpack(opts) })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", unpack(opts) })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", unpack(opts) })

-- Split Creation
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split Horizontal", unpack(opts) })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split Vertical", unpack(opts) })
map("n", "<leader>wd", "<C-w>c", { desc = "Close Window", unpack(opts) })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize Windows", unpack(opts) })

-- Window Resizing with Ctrl + Arrow Keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height", unpack(opts) })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height", unpack(opts) })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width", unpack(opts) })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width", unpack(opts) })

-- ------------------------------------------------------------------------------
-- 3. BUFFER NAVIGATION & MANAGEMENT
-- ------------------------------------------------------------------------------
-- Cycle Through Buffers
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous Buffer", unpack(opts) })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer", unpack(opts) })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous Buffer", unpack(opts) })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer", unpack(opts) })

-- Close Current Buffer Safely
map("n", "<leader>bd", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    local choice = vim.fn.confirm("Buffer has unsaved changes. Save before closing?", "&Yes\n&No\n&Cancel")
    if choice == 1 then
      vim.cmd("write")
    elseif choice == 3 or choice == 0 then
      return
    end
  end
  -- Switch to alternate buffer before deleting to maintain window layout
  vim.cmd("bprevious")
  vim.cmd("bdelete! " .. bufnr)
end, { desc = "Close Current Buffer", unpack(opts) })

-- Close All Other Buffers
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close Other Buffers", unpack(opts) })

-- ------------------------------------------------------------------------------
-- 4. EDITING & TEXT MANIPULATION
-- ------------------------------------------------------------------------------
-- Visual Mode: Move lines up & down with auto-reindent
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down", unpack(opts) })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up", unpack(opts) })

-- Visual Mode: Keep selection when indenting
map("v", "<", "<gv", { desc = "Indent Left & Keep Selection", unpack(opts) })
map("v", ">", ">gv", { desc = "Indent Right & Keep Selection", unpack(opts) })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join Lines & Keep Cursor Position", unpack(opts) })

-- ------------------------------------------------------------------------------
-- 5. DIAGNOSTICS & QUICKFIX
-- ------------------------------------------------------------------------------
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic", unpack(opts) })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic", unpack(opts) })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show Line Diagnostics", unpack(opts) })
map("n", "<leader>cq", vim.diagnostic.setqflist, { desc = "Diagnostics to Quickfix", unpack(opts) })

-- Quickfix Navigation
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous Quickfix Item", unpack(opts) })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next Quickfix Item", unpack(opts) })

-- ------------------------------------------------------------------------------
-- 6. TERMINAL ESCAPE
-- ------------------------------------------------------------------------------
-- Easily escape terminal mode back to normal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode", unpack(opts) })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: Go to Left Window", unpack(opts) })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: Go to Lower Window", unpack(opts) })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: Go to Upper Window", unpack(opts) })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: Go to Right Window", unpack(opts) })
