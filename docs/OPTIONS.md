# Neovim IDE Options Reference Manual

This document provides a comprehensive, option-by-option breakdown of every setting configured in `lua/config/options.lua`.

---

## 1. Line Numbers & Cursor Positioning

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.number` | `true` | Displays the absolute line number on the line where the cursor currently rests. |
| `vim.opt.relativenumber` | `true` | Displays relative line numbers above and below the cursor line. This enables instantaneous jump calculations (e.g., typing `12k` or `8j` jumps directly to the target line without mental arithmetic). |
| `vim.opt.cursorline` | `true` | Highlights the current screen line horizontally, allowing instant visual tracking of the active cursor position across large multi-split displays. |
| `vim.opt.scrolloff` | `8` | Guarantees a minimum of 8 buffer lines are kept visible above and below the cursor when scrolling. Prevents the cursor from hitting the top or bottom edge of the screen. |
| `vim.opt.sidescrolloff` | `8` | Guarantees a minimum of 8 screen columns are visible to the left and right of the cursor when moving horizontally across long lines. |
| `vim.opt.virtualedit` | `"block"` | Allows the cursor to be positioned anywhere in Visual Block mode (`<C-v>`), even where there are no characters, making multi-line columnar edits effortless. |

---

## 2. Tabs, Indentation & Formatting

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.tabstop` | `2` | Width in visual spaces that a TAB character occupies. Standardized to 2 spaces for modern web, cloud, and systems development. |
| `vim.opt.shiftwidth` | `2` | Number of spaces inserted for each step of indentation (when pressing `>>`, `<<`, or auto-indenting). |
| `vim.opt.softtabstop` | `2` | Number of spaces that a `<Tab>` key counts for while performing editing operations in insert mode. |
| `vim.opt.expandtab` | `true` | Automatically converts all inserted `<Tab>` keypresses into spaces, avoiding inconsistent tab character rendering across different platforms and editors. |
| `vim.opt.smartindent` | `true` | Automatically adds indentation when opening new lines inside syntax blocks (e.g., after `{` or function definitions). |
| `vim.opt.autoindent` | `true` | Copies the indentation level of the current line when pressing Enter to create a new line. |
| `vim.opt.wrap` | `true` | Enables soft line wrapping so lines never overflow horizontally out of the viewport. |
| `vim.opt.linebreak` | `true` | Wraps lines intelligently at convenient word boundaries and punctuation rather than awkwardly breaking words mid-character. |
| `vim.opt.breakindent` | `true` | Continues wrapped lines with the identical indentation level as the parent line, preserving code structure and readability. |
| `vim.opt.showbreak` | `"↳ "` | Prepends a clean visual continuation glyph at the start of each wrapped line. |
| `vim.opt.formatoptions` | `-c -r -o` | Prevents Neovim from automatically prepending comment characters when breaking lines or pressing `o`/`O` in normal mode. |

---

## 3. Search & Pattern Matching

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.ignorecase` | `true` | Makes pattern searches case-insensitive by default. |
| `vim.opt.smartcase` | `true` | Overrides `ignorecase` if the search query contains at least one uppercase letter (e.g., `/user` matches `User` and `user`, but `/User` matches only `User`). |
| `vim.opt.hlsearch` | `true` | Highlights all matches found by the previous search query. Easily cleared with `<Esc>` or `<leader>h`. |
| `vim.opt.incsearch` | `true` | Shows incremental search results dynamically as each character of the query is typed. |
| `vim.opt.wildmode` | `"longest:full,full"` | Command-line completion mode: completes up to the longest common match on the first tab, and opens a full cycle list on subsequent tabs. |

---

## 4. Window Splits & Layout Management

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.splitbelow` | `true` | Directs horizontal window splits (`:split`, `<leader>ws`) to open below the current window rather than above it, matching natural reading flow and modern IDE behavior. |
| `vim.opt.splitright` | `true` | Directs vertical window splits (`:vsplit`, `<leader>wv`) to open to the right of the current window rather than to the left. |
| `vim.opt.fillchars` | `{ eob = " ", vert = "│", horiz = "─" }` | Replaces tilde characters (`~`) on empty buffer lines with clean empty space and sets polished Unicode borders for split separators. |

---

## 5. Visual Rendering & UI Polishing

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.termguicolors` | `true` | Enables 24-bit TrueColor RGB output in the terminal emulator, allowing Tokyo Night, Catppuccin, and syntax tokens to render with full color fidelity. |
| `vim.opt.signcolumn` | `"yes"` | Forces the gutter signcolumn to always remain visible. Prevents distracting screen flickering and layout jumps when Git signs or LSP diagnostic icons appear/disappear. |
| `vim.opt.pumheight` | `10` | Limits the maximum number of items displayed simultaneously in the autocompletion popup menu (`pum`), preventing it from obscuring the entire viewport. |
| `vim.opt.pumblend` | `10` | Implements subtle 10% alpha blending/transparency on popup menus for aesthetic depth. |
| `vim.opt.winblend` | `10` | Implements subtle 10% alpha blending/transparency on floating windows and hover popups. |
| `vim.opt.showmode` | `false` | Suppresses the built-in `-- INSERT --`, `-- VISUAL --` message in the command bar, since the mode is already dynamically rendered by the Lualine status bar. |
| `vim.opt.ruler` | `false` | Suppresses built-in cursor coordinate rendering in favor of the Lualine location indicator. |
| `vim.opt.conceallevel` | `2` | Renders formatted markdown, links, and code blocks cleanly while hiding raw markup syntax until the cursor enters the line. |

---

## 6. History, Undo & Safety

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.undofile` | `true` | Enables persistent undo history on disk. Allows undoing edits across Neovim restarts, crashes, or machine reboots. |
| `vim.opt.undolevels` | `10000` | Sets the maximum undo history capacity to 10,000 operations per buffer. |
| `vim.opt.undodir` | `stdpath("data")/undo` | Isolates all persistent undo files into a dedicated, user-private directory with restricted access permissions (`0700`). |
| `vim.opt.swapfile` | `false` | Disables Vim `.swp` files. Modern fast storage, Git version control, and persistent undo files eliminate the need for cluttering working directories with recovery swap files. |
| `vim.opt.backup` | `false` | Prevents creation of unwanted backup files (e.g., `file.txt~`). |
| `vim.opt.writebackup` | `false` | Prevents temporary backup file creation during buffer writes. |

---

## 7. Performance & Responsiveness

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.updatetime` | `200` | Reduces idle latency from Vim's default 4,000ms down to 200ms. Enables instantaneous Git hunk updates in the gutter, faster cursor-hold diagnostics, and snappy code-completion popups. |
| `vim.opt.timeoutlen` | `300` | Reduces key sequence timeout from 1,000ms to 300ms, making which-key menus appear quickly and eliminating perceived lag on multi-key shortcuts. |
| `vim.opt.redrawtime` | `1500` | Prevents slow syntax redrawing from freezing the editor on massive files. |

---

## 8. Integration & Clipboard

| Option | Setting | Purpose & Rationale |
| :--- | :--- | :--- |
| `vim.opt.clipboard` | `"unnamedplus"` | Synchronizes Neovim's default register with the system clipboard (Windows Clipboard, macOS pasteboard, or X11/Wayland clipboard). Allows seamless copy/pasting between Neovim and external applications. |
| `vim.opt.mouse` | `"a"` | Enables full mouse support across all modes (Normal, Visual, Insert, Command, Terminal), allowing smooth mouse wheel scrolling, split resizing, and visual selection. |
| `vim.opt.encoding` | `"utf-8"` | Enforces UTF-8 character encoding internally. |
| `vim.opt.fileencoding` | `"utf-8"` | Enforces UTF-8 encoding when saving buffers to disk. |
