-- ==============================================================================
-- CONFIG: AUTOCMDS (Automated IDE Events & Lifecycle Hooks)
-- ==============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general_group = augroup("IDEGeneralGroup", { clear = true })

-- 1. HIGHLIGHT ON YANK
-- Flashes briefly when text is copied to give clear visual feedback
autocmd("TextYankPost", {
  group = general_group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
  desc = "Highlight yanked text briefly",
})

-- 2. AUTO-RESIZE SPLITS ON WINDOW RESIZE
-- Keep splits proportional when terminal or window is resized
autocmd("VimResized", {
  group = general_group,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Keep window splits evenly sized on window resize",
})

-- 3. CLOSE CERTAIN WINDOWS WITH 'q'
-- Makes help pages, quickfix, man pages, and inspection popups effortless to exit
autocmd("FileType", {
  group = general_group,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Quick Close Window" })
  end,
  desc = "Close utility buffers with 'q'",
})

-- 4. RESTORE CURSOR POSITION
-- Remember where cursor was when reopening previously edited files
autocmd("BufReadPost", {
  group = general_group,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) <= vim.fn.line("$")
    local not_commit = vim.b[args.buf].filetype ~= "gitcommit"
    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
  desc = "Restore last known cursor position",
})

-- 5. DISABLE AUTOMATIC COMMENT CONTINUATION
-- Prevents Neovim from automatically inserting comment characters when pressing Enter
autocmd("FileType", {
  group = general_group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Do not auto-insert comment leader on newline",
})

-- 6. TERMINAL SETTINGS
-- Hide line numbers and enter insert mode immediately when focusing terminal
autocmd("TermOpen", {
  group = general_group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
  desc = "Clean terminal layout settings",
})
