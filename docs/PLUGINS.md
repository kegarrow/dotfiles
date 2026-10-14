# Neovim IDE Plugins Architecture

This document details the curated plugin ecosystem powering this Neovim IDE, explaining the purpose, upstream repository, and configuration of each module.

---

## 1. Plugin Ecosystem Overview

| Category | Plugins | Primary Purpose |
| :--- | :--- | :--- |
| **Plugin Manager** | `folke/lazy.nvim` | Lightning-fast, lockfile-pinned, lazy-loading plugin manager |
| **Dashboard** | `goolord/alpha-nvim` | Cyberpunk IDE startup dashboard with performance telemetry |
| **Theme & UI** | `folke/tokyonight.nvim`, `catppuccin/nvim`, `nvim-tree/nvim-web-devicons` | 24-bit TrueColor visual themes and high-res glyph icons |
| **Breadcrumbs & Tabs**| `Bekaboo/dropbar.nvim`, `akinsho/bufferline.nvim`, `nvim-lualine/lualine.nvim` | IDE breadcrumb path bar, tabbed buffer bar, and unified statusline |
| **Visual Cues & Color**| `lukas-reineke/indent-blankline.nvim`, `NvChad/nvim-colorizer.lua`, `karb94/neoscroll.nvim` | Indentation guides, real-time Hex/RGB color highlights, and smooth scrolling |
| **Notifications** | `rcarriga/nvim-notify`, `folke/noice.nvim`, `stevearc/dressing.nvim` | Toast notifications, floating command palette, and modal dialogs |
| **Diagnostics Panel**| `folke/trouble.nvim` | Collapsible problem, diagnostics, and symbol tree panel |
| **File Navigation** | `nvim-neo-tree/neo-tree.nvim`, `stevearc/oil.nvim` | Sidebar file explorer & buffer-like directory editor |
| **Fuzzy Finding** | `nvim-telescope/telescope.nvim`, `nvim-lua/plenary.nvim` | High-speed file finder, live grep, symbol lookup |
| **Syntax Parsing**| `nvim-treesitter`, `treesitter-textobjects` | High-performance AST syntax parsing, custom text objects, and language analysis |
| **LSP & Typing** | `nvim-lspconfig`, `williamboman/mason.nvim`, `mason-lspconfig`, `inc-rename.nvim` | Language Server Protocol clients, toolchain hub, and live incremental renaming |
| **Autocompletion** | `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `friendly-snippets`, `lspkind` | Intelligent snippet-aware completion menu with VS Code icons |
| **Code Formatting**| `stevearc/conform.nvim` | Asynchronous multi-formatter runner with LSP fallback on save |
| **Code Linting** | `mfussenegger/nvim-lint` | Asynchronous background static analysis on buffer write |
| **Version Control**| `lewis6991/gitsigns.nvim`, `kdheepak/lazygit.nvim`, `diffview.nvim`, `git-conflict.nvim` | Gutter diff indicators, full Git terminal UI, diff review, and 3-way merge conflict resolver |
| **Debugger (DAP)** | `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `mason-nvim-dap` | Full IDE debugging: breakpoints, variable watches, step debugging, scopes |
| **Terminal** | `akinsho/toggleterm.nvim` | Floating and split terminal manager |
| **Productivity** | `which-key.nvim`, `nvim-autopairs`, `nvim-surround`, `Comment.nvim`, `todo-comments.nvim`, `flash.nvim`, `persistence.nvim` | Keybinding legend, delimiter auto-pairing, surround text objects, fast code comments, session restore |

---

## 2. Deep Dive by Functional Domain

### A. Core Engine & Package Management (`lua/config/lazy.lua`)
- **`folke/lazy.nvim`**:
  - Automatically bootstraps itself over HTTPS if not present.
  - Pinning is enforced via `lazy-lock.json` for tamper-proof reproducibility.
  - Submodules are loaded from `lua/plugins/*.lua`.
  - Native Vim runtime plugins that are redundant (`netrw`, `gzip`, `tarPlugin`, `zipPlugin`) are disabled for maximum startup performance.

### B. Themes & Aesthetic Layer (`lua/plugins/ui.lua`)
- **`tokyonight.nvim`**: Default theme configured in `"night"` mode with dark sidebars and floating window borders.
- **`catppuccin/nvim`**: Built-in alternative with full treesitter, lsp, and dap integrations.
- **`lualine.nvim`**: Unified global statusline (`globalstatus = true`) featuring:
  - Vim execution mode indicator
  - Git branch and live hunk statistics (`+`, `~`, `-`)
  - Real-time LSP diagnostic counters (Errors, Warnings, Hints, Info)
  - Active Language Server client names
  - File encoding, format, and position progress
- **`bufferline.nvim`**: Tabbed buffer management showing file icons, pinned status, and inline diagnostic badges.
- **`indent-blankline.nvim`**: Highlights current code block scope with vertical guide lines.
- **`noice.nvim` & `nvim-notify`**: Replaces the classical command bar with a floating command palette and toast notifications.

### C. File Tree & Directory Management (`lua/plugins/explorer.lua`)
- **`neo-tree.nvim`**: Provides a standard IDE file tree sidebar (`<leader>e`):
  - Live git status indicators
  - Diagnostic badges on files with compiler errors
  - Built-in file operations: `a` (add), `d` (delete), `r` (rename), `c` (copy), `x` (cut), `p` (paste)
- **`oil.nvim`**: Allows editing the filesystem directly like a normal Vim buffer (`-`). Renaming a file is as simple as changing its text on screen and saving the buffer (`:w`).

### D. Search & Code Discovery (`lua/plugins/finder.lua`)
- **`telescope.nvim`**:
  - Live grep powered by Ripgrep (`<leader>fg`)
  - File search with hidden file visibility (`<leader>ff`)
  - Buffer picker (`<leader>fb`)
  - Code symbol and workspace diagnostic pickers (`<leader>fd`, `<leader>fs`)

### E. Syntax Parsing & AST Analysis (`lua/plugins/treesitter.lua`)
- **`nvim-treesitter`**:
  - Leverages Neovim 0.12 bundled native Windows DLL parsers (`c`, `lua`, `vim`, `vimdoc`, `query`, `markdown`, `markdown_inline`).
  - Preconfigured with **Zig** (`zig cc`) as an automated zero-dependency C cross-compiler on Windows.
  - On-demand parser compilation via `:TSInstall <lang>` with zero startup lock contention.
  - Treesitter text objects for instant function/class selection (`af`, `if`, `ac`, `ic`).
  - Auto-tagging and auto-renaming of HTML/JSX tags via `nvim-ts-autotag`.

### F. Language Server Protocol (LSP) (`lua/plugins/lsp.lua`)
- **`mason.nvim`**: In-editor package manager for language servers, formatters, and debug adapters.
- **`nvim-lspconfig`**: Configured with pre-tuned language servers:
  - `lua_ls` (Lua / Neovim runtime)
  - `pyright` (Python)
  - `ts_ls` (TypeScript & JavaScript)
  - `rust_analyzer` (Rust)
  - `jsonls`, `yamlls`, `html`, `cssls`
- Modern Inlay Hints supported (`<leader>th`).

### G. Autocompletion & Snippets (`lua/plugins/completion.lua`)
- **`nvim-cmp`**: Asynchronous autocomplete engine sourcing from:
  - LSP completions
  - Snippets (`LuaSnip`)
  - Filesystem paths (`cmp-path`)
  - Buffer words (`cmp-buffer`)
- Super-Tab key navigation (`<Tab>` / `<S-Tab>`) with full snippet expansion.
- VS Code style pictograms via `lspkind.nvim`.

### H. Formatting & Linting (`lua/plugins/formatting.lua` & `linting.lua`)
- **`conform.nvim`**: Non-blocking asynchronous formatting on save with Prettier, Black, isort, Stylua, and Rustfmt.
- **`nvim-lint`**: Independent asynchronous linting on save without locking the editor thread.

### I. Version Control (`lua/plugins/git.lua`)
- **`gitsigns.nvim`**: Real-time gutter hunk diffs, hunk staging (`<leader>hs`), and inline git blame (`<leader>tb`).
- **`lazygit.nvim`**: Floating full terminal interface for Git (`<leader>gg`).
- **`diffview.nvim`**: Side-by-side 2-way and 3-way visual merge and diff review tool (`<leader>gd`).

### J. Interactive Debugging (`lua/plugins/dap.lua`)
- **`nvim-dap`**: Debug Adapter Protocol client.
- **`nvim-dap-ui`**: Four-pane IDE debug layout: Scopes, Breakpoints, Call Stacks, and Watches.
- **`nvim-dap-virtual-text`**: Displays variable values directly inline next to source code statements.
- Preconfigured for Python (`debugpy`) and C/C++/Rust (`codelldb`).

### K. Integrated Terminal (`lua/plugins/terminal.lua`)
- **`toggleterm.nvim`**: Persistent floating, horizontal, and vertical terminals (`<C-\>`, `<leader>tt`, `<leader>tf`).

### L. Cyberpunk Startup Dashboard (`lua/plugins/dashboard.lua`)
- **`alpha-nvim`**:
  - Neovim ASCII art header with custom Tokyo Night colors.
  - Interactive quick-start shortcuts for file discovery, new buffers, recent files, live grep, and session restore.
  - Live footer telemetry displaying Neovim version, active plugins count, and startup latency in milliseconds.

### M. Diagnostic & Problem Trees (`lua/plugins/trouble.lua`)
- **`trouble.nvim` (v3)**:
  - Collapsible IDE tree views for workspace diagnostics (`<leader>xx`) and file diagnostics (`<leader>xX`).
  - Hierarchical symbols outline (`<leader>cs`) displaying classes, interfaces, and methods.
  - LSP definitions, references, and usages inspector (`<leader>cl`).

### N. IDE Breadcrumbs & Aesthetics (`lua/plugins/ui.lua`)
- **`dropbar.nvim`**: Pinned breadcrumb navigation at the top of code buffers showing clickable breadcrumb trail (`path > file > class > function`).
- **`nvim-colorizer.lua`**: Instantaneous in-buffer color highlighting for Hex, RGB, HSL, CSS names, and Tailwind tokens.
- **`neoscroll.nvim`**: Smooth cinematic scrolling physics for viewport jumps (`<C-u>`, `<C-d>`, `zz`).

### O. Merge Conflict Resolution & Live Renaming
- **`git-conflict.nvim`** (`lua/plugins/git.lua`):
  - Visual color-coded diff blocks for Git merge conflicts.
  - 1-key conflict resolution: `co` (ours), `ct` (theirs), `cb` (both), `c0` (none), `]x` / `[x` (jump).
- **`inc-rename.nvim`** (`lua/plugins/lsp.lua`):
  - Real-time incremental LSP symbol renaming as you type on screen (`<leader>cr`).
