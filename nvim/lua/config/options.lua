-- ==============================================================================
-- CONFIG: OPTIONS (Modern IDE Editor Defaults & Ergonomics)
-- ==============================================================================

local opt = vim.opt

-- Disable unused legacy providers to optimize startup performance
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Cross-Platform WinGet PATH Auto-Resolution (Windows)
-- Ensures tools installed via winget (zig, ripgrep, fd, fzf, lazygit, node) are immediately in PATH
if vim.fn.has("win32") == 1 then
  local localappdata = vim.fn.getenv("LOCALAPPDATA")
  if localappdata ~= vim.NIL and localappdata ~= "" then
    local winget_pkgs = localappdata .. "\\Microsoft\\WinGet\\Packages"
    if vim.fn.isdirectory(winget_pkgs) == 1 then
      local dirs = vim.fn.glob(winget_pkgs .. "/*/*", false, true)
      local to_add = {}
      for _, d in ipairs(dirs) do
        if vim.fn.isdirectory(d) == 1 then
          table.insert(to_add, d)
        end
      end
      local top_dirs = vim.fn.glob(winget_pkgs .. "/*", false, true)
      for _, d in ipairs(top_dirs) do
        if vim.fn.isdirectory(d) == 1 then
          table.insert(to_add, d)
        end
      end
      if #to_add > 0 then
        vim.env.PATH = table.concat(to_add, ";") .. ";" .. vim.env.PATH
      end
    end

    -- Python 3 Provider Auto-Detection
    local python_paths = {
      localappdata .. "\\Programs\\Python\\Python312\\python.exe",
      localappdata .. "\\Programs\\Python\\Python313\\python.exe",
      localappdata .. "\\Programs\\Python\\Python311\\python.exe",
    }
    for _, py in ipairs(python_paths) do
      if vim.fn.filereadable(py) == 1 then
        vim.g.python3_host_prog = py
        local pydir = vim.fn.fnamemodify(py, ":h")
        vim.env.PATH = pydir .. ";" .. pydir .. "\\Scripts;" .. vim.env.PATH
        break
      end
    end
  end
end

-- Neovim 0.12 Compatibility Shim for Treesitter AST Directives:
-- In Neovim 0.12, query matches return node lists (table<integer, TSNode[]>).
-- Safely unwraps single-element tables if passed to get_node_text.
if vim.treesitter and vim.treesitter.get_node_text then
  local orig_get_node_text = vim.treesitter.get_node_text
  vim.treesitter.get_node_text = function(node, source, opts)
    if type(node) == "table" and not node.range and node[1] then
      node = node[1]
    end
    return orig_get_node_text(node, source, opts)
  end
end

-- Line Numbers (Hybrid relative + absolute for rapid navigation)
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2         -- Number of visual spaces per TAB
opt.shiftwidth = 2      -- Number of spaces inserted for each indentation level
opt.softtabstop = 2     -- Number of spaces inserted in insert mode for TAB
opt.expandtab = true    -- Convert tabs to spaces
opt.smartindent = true  -- Insert indents automatically
opt.autoindent = true   -- Maintain current indent on newline
opt.shiftround = true   -- Round indent to multiple of 'shiftwidth'

-- Search & Patterns
opt.ignorecase = true   -- Case-insensitive searching
opt.smartcase = true    -- Case-sensitive if search contains uppercase characters
opt.hlsearch = true     -- Highlight search matches
opt.incsearch = true    -- Show matches while typing search query
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Window Splits (IDE standard behavior: opens new splits down and right)
opt.splitbelow = true   -- Horizontal split opens below current window
opt.splitright = true   -- Vertical split opens to the right of current window

-- Visual Cues & Appearance
opt.termguicolors = true   -- True 24-bit RGB colors in terminal
opt.cursorline = true      -- Highlight the line where cursor resides
opt.signcolumn = "yes"     -- Always reserve signcolumn for git & diagnostics to prevent layout shift
opt.scrolloff = 8          -- Keep at least 8 lines visible above/below cursor
-- Smart Text Wrapping (Wrap text in viewport with indentation preservation)
opt.wrap = true            -- Enable soft line wrapping so text fits the viewport
opt.linebreak = true       -- Wrap lines at convenient boundary characters (words/spaces) rather than mid-word
opt.breakindent = true     -- Maintain matching indentation level on wrapped lines for clean reading
opt.showbreak = "↳ "       -- Visual glyph indicator at the start of wrapped continuation lines
opt.pumheight = 10         -- Limit completion popup menu height
opt.pumblend = 10          -- Slight transparency for popup menu
opt.winblend = 10          -- Slight transparency for floating windows
opt.showmode = false       -- Mode already displayed by statusline (lualine)
opt.ruler = false          -- Line/col already shown by lualine
opt.fillchars = {
  eob = " ",               -- Suppress '~' on empty buffer lines
  vert = "│",
  horiz = "─",
}

-- Persistent Undo & History
opt.undofile = true        -- Save undo history across Neovim sessions
opt.undolevels = 10000     -- Generous undo history buffer
-- Place undo files securely in Neovim data directory
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
opt.undodir = undo_dir

-- Swap & Backup Files (Disabled in favor of persistent undo and Git)
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Performance & Timers
opt.updatetime = 200       -- Faster completion trigger & faster gitsigns updates (ms)
opt.timeoutlen = 300       -- Shorter key sequence timeout for responsive which-key popups
opt.redrawtime = 1500      -- Max time (ms) for syntax redraw

-- Clipboard Integration
-- Sync with system clipboard (Windows/Linux/macOS)
opt.clipboard = "unnamedplus"

-- Mouse Support
opt.mouse = "a"            -- Enable mouse in all modes (scrolling, clicking, resizing splits)

-- Code Folding (Modern Treesitter / Expression folding)
opt.foldlevel = 99         -- Start with all folds open
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "1"       -- Subtle indicator for folded code blocks

-- Markdown & UI Concealing
opt.conceallevel = 2       -- Conceal markdown syntax formatting cleanly
opt.concealcursor = ""

-- Code Formatting Behavior
opt.formatoptions:remove({ "c", "r", "o" }) -- Do not auto-insert comment leader on Enter or 'o'

-- Virtual Edit
opt.virtualedit = "block"  -- Allow cursor anywhere in visual block mode
