# Neovim IDE Keybindings & Cheatsheet

Leader key: **`<Space>`**  
Local leader key: **`\`**

---

## 1. General & Core Shortcuts

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<leader>w` | `n` | `:w<CR>` | Save current buffer |
| `<leader>q` | `n` | `:q<CR>` | Quit current window |
| `<leader>Q` | `n` | `:qa!<CR>` | Force quit all windows without saving |
| `<leader>tw` | `n` | Toggle Text Wrap | Toggle soft line wrapping in the viewport |
| `<leader>h` | `n` | `:nohlsearch<CR>` | Clear search highlighting |
| `<Esc>` | `n` | `:nohlsearch<CR><Esc>` | Clear search highlighting and return to normal state |
| `<leader>fn` | `n` | `:enew<CR>` | Open a new empty buffer |
| `x` | `n` | `"_x` | Delete single character without overwriting default clipboard |
| `<leader>d` | `n`, `v` | `"_d` | Delete selection to black hole register (no clipboard overwrite) |
| `p` | `x` | `P` | Paste over visual selection without clobbering the copied text |
| `J` | `n` | `mzJ`z` | Join lines below while keeping the cursor fixed in place |

---

## 2. Navigation & Viewport Centering

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `j` | `n`, `v` | Visual Down (`gj`) | Move down one visual line on wrapped text (preserves count) |
| `k` | `n`, `v` | Visual Up (`gk`) | Move up one visual line on wrapped text (preserves count) |
| `<C-d>` | `n` | `<C-d>zz` | Scroll down half-page with smooth physics & centered cursor |
| `<C-u>` | `n` | `<C-u>zz` | Scroll up half-page with smooth physics & centered cursor |
| `n` | `n` | `nzzzv` | Jump to next search result, open folds, and center cursor |
| `N` | `n` | `Nzzzv` | Jump to previous search result, open folds, and center cursor |
| `s` | `n`, `x`, `o` | Flash jump | Jump anywhere on screen with 2-character bi-directional search |
| `S` | `n`, `x`, `o` | Flash treesitter | Jump to any Treesitter AST node |

---

## 3. Window & Split Management

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<C-h>` | `n`, `t` | Window Left | Move focus to the left window split |
| `<C-j>` | `n`, `t` | Window Down | Move focus to the bottom window split |
| `<C-k>` | `n`, `t` | Window Up | Move focus to the top window split |
| `<C-l>` | `n`, `t` | Window Right | Move focus to the right window split |
| `<leader>ws` | `n` | `:split<CR>` | Create a new horizontal split below |
| `<leader>wv` | `n` | `:vsplit<CR>` | Create a new vertical split to the right |
| `<leader>wd` | `n` | `<C-w>c` | Close current split window |
| `<leader>w=` | `n` | `<C-w>=` | Equalize all split window dimensions |
| `<C-Up>` | `n` | `:resize +2<CR>` | Increase current window height by 2 rows |
| `<C-Down>` | `n` | `:resize -2<CR>` | Decrease current window height by 2 rows |
| `<C-Left>` | `n` | `:vertical resize -2<CR>` | Decrease current window width by 2 columns |
| `<C-Right>` | `n` | `:vertical resize +2<CR>` | Increase current window width by 2 columns |

---

## 4. Bufferline & Tab Management

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `[b` or `<S-h>` | `n` | `:bprevious<CR>` | Switch to previous buffer tab |
| `]b` or `<S-l>` | `n` | `:bnext<CR>` | Switch to next buffer tab |
| `<leader>bd` | `n` | Close buffer | Safely close active buffer without disrupting split layout |
| `<leader>bo` | `n` | Close others | Close all other buffers except current |
| `<leader>bp` | `n` | Toggle Pin | Pin or unpin buffer in the buffer tabline |
| `<leader>bP` | `n` | Close unpinned | Close all unpinned buffers |
| `<leader>br` | `n` | Close to right | Close all buffers to the right |
| `<leader>bl` | `n` | Close to left | Close all buffers to the left |

---

## 5. File Explorers (Neo-Tree & Oil)

### Neo-Tree (Sidebar Explorer)
| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<leader>e` | `n` | Toggle Neo-tree | Open or close sidebar file tree |
| `<leader>o` | `n` | Focus Neo-tree | Focus sidebar file tree |
| `<leader>ge` | `n` | Git Explorer | View modified git files in tree view |
| `<leader>be` | `n` | Buffer Explorer | View open buffers in tree view |
| `l` / `<CR>` | `n` (in tree) | Open file/folder | Open file or expand directory |
| `h` | `n` (in tree) | Close node | Collapse directory |
| `a` | `n` (in tree) | Add file/dir | Create new file or folder (suffix with `/`) |
| `d` | `n` (in tree) | Delete | Delete file/folder |
| `r` | `n` (in tree) | Rename | Rename file/folder |
| `y` | `n` (in tree) | Copy to clipboard | Copy file to Neo-tree clipboard |
| `x` | `n` (in tree) | Cut to clipboard | Cut file to Neo-tree clipboard |
| `p` | `n` (in tree) | Paste | Paste copied/cut file |
| `H` | `n` (in tree) | Toggle Hidden | Toggle visibility of hidden / dotfiles |

### Oil.nvim (Buffer-like Directory Editor)
| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `-` | `n` | Open Parent Directory | Edit parent directory like an ordinary text buffer |
| `<leader>-` | `n` | Open Oil Float | Edit directory in a floating modal |

---

## 6. Fuzzy Finding & Searching (Telescope)

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<leader><space>` | `n` | Find Files | Fuzzy search all workspace files (including hidden) |
| `<leader>ff` | `n` | Find Files | Fuzzy search all workspace files |
| `<leader>fo` | `n` | Recent Files | Search recently opened files (MRU) |
| `<leader>fb` | `n` | Open Buffers | Fuzzy search currently active buffer tabs |
| `<leader>fg` | `n` | Live Grep | Fast workspace text search powered by Ripgrep |
| `<leader>fw` | `n` | Grep Word | Search workspace for the word currently under cursor |
| `<leader>/` | `n` | Buffer Search | Fuzzy search lines within current buffer |
| `<leader>fd` | `n` | Document Diagnostics | Search diagnostics in current file |
| `<leader>fD` | `n` | Workspace Diagnostics | Search diagnostics across all project files |
| `<leader>fs` | `n` | Document Symbols | Fuzzy search functions, variables, and classes in file |
| `<leader>fS` | `n` | Workspace Symbols | Fuzzy search symbols across entire codebase |
| `<leader>ft` | `n` | Todo Search | Find all `TODO`, `FIXME`, `BUG`, `NOTE` comments |
| `<leader>fh` | `n` | Help Tags | Search Vim / Neovim documentation |
| `<leader>fk` | `n` | Search Keymaps | Interactive keymap lookup |
| `<leader>fc` | `n` | Colorscheme | Live preview and select colorschemes |
| `<leader>fr` | `n` | Resume Picker | Re-open the last active Telescope search session |

---

## 7. LSP (Language Server Protocol) & Code Intelligence

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `gd` | `n` | Definition | Jump to symbol definition |
| `gD` | `n` | Declaration | Jump to symbol declaration |
| `gr` | `n` | References | List all symbol references in Telescope |
| `gi` | `n` | Implementation | List interface implementations in Telescope |
| `gy` | `n` | Type Definition | Jump to type definition |
| `K` | `n` | Hover Docs | Show signature and docstring hover popup |
| `<C-k>` | `n`, `i` | Signature Help | Show parameter types while typing arguments |
| `<leader>ca` | `n`, `v` | Code Action | Open code fix and refactoring suggestions |
| `<leader>cr` | `n` | IncRename | Live interactive symbol renaming with real-time preview |
| `<leader>th` | `n` | Toggle Inlay Hints | Toggle inline parameter/variable type hints |
| `[d` | `n` | Previous Diagnostic | Jump to previous error / warning |
| `]d` | `n` | Next Diagnostic | Jump to next error / warning |
| `<leader>cd` | `n` | Line Diagnostics | Open floating popup with detailed error message |
| `<leader>cm` | `n` | Mason | Open Mason package manager UI |

---

## 8. Trouble.nvim (Diagnostics & Symbol Trees)

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<leader>xx` | `n` | Workspace Diagnostics | Toggle project-wide diagnostics tree |
| `<leader>xX` | `n` | Buffer Diagnostics | Toggle current buffer diagnostics tree |
| `<leader>cs` | `n` | Symbols Outline | Toggle code symbols outline (classes, methods, variables) |
| `<leader>cl` | `n` | LSP Usages | Open definition, reference, and implementation panel |
| `<leader>xL` | `n` | Location List | Toggle Neovim location list tree |
| `<leader>xQ` | `n` | Quickfix List | Toggle Neovim quickfix list tree |

---

## 9. Formatting & Linting

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<leader>cf` | `n`, `v` | Format Buffer | Asynchronous code format via Conform (Prettier/Black/Stylua/etc.) |
| `<leader>cl` | `n` | Trigger Lint | Manually trigger file linting via Nvim-lint |
| *Auto-save* | *Event* | Format on Save | Automatically formats code on buffer write with fallback to LSP |

---

## 10. Version Control, Git & Conflict Resolution

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `]h` | `n` | Next Hunk | Jump to next Git diff hunk |
| `[h` | `n` | Previous Hunk | Jump to previous Git diff hunk |
| `<leader>hs` | `n`, `v` | Stage Hunk | Stage hunk (or visual selection) to Git index |
| `<leader>hr` | `n`, `v` | Reset Hunk | Discard changes in current hunk |
| `<leader>hS` | `n` | Stage Buffer | Stage all changes in current file |
| `<leader>hu` | `n` | Undo Stage Hunk | Unstage hunk from Git index |
| `<leader>hR` | `n` | Reset Buffer | Discard all unstaged changes in buffer |
| `<leader>hp` | `n` | Preview Hunk | Floating popup showing hunk diff |
| `<leader>hb` | `n` | Blame Line | Detailed git blame modal for current line |
| `<leader>tb` | `n` | Toggle Blame | Toggle virtual text inline git blame |
| `<leader>hd` | `n` | Diff This | Open vimdiff against the Git index |
| `<leader>gg` | `n` | LazyGit | Open full-screen floating LazyGit terminal UI |
| `<leader>gf` | `n` | File History | Open LazyGit focused on current file log |
| `<leader>gd` | `n` | Diffview Open | Open side-by-side git diff review panel |
| `<leader>gD` | `n` | Diffview Close | Close side-by-side git diff review panel |
| `<leader>gh` | `n` | File History | Open interactive visual commit history for current file |
| `co` | `n` | Conflict: Choose Ours | Keep current branch changes in merge conflict |
| `ct` | `n` | Conflict: Choose Theirs | Accept incoming changes in merge conflict |
| `cb` | `n` | Conflict: Choose Both | Keep both sides in merge conflict |
| `c0` | `n` | Conflict: Choose None | Discard both sides of merge conflict |
| `]x` / `[x` | `n` | Next / Prev Conflict | Jump between git merge conflicts |
| `ih` | `o`, `x` | Inner Hunk Text Object | Operate on hunk (e.g. `dih` delete hunk, `yih` yank hunk) |

---

## 10. Interactive Debugger (DAP)

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<F5>` | `n` | Start / Continue | Launch debug adapter or continue execution |
| `<F10>` | `n` | Step Over | Step over next line |
| `<F11>` | `n` | Step Into | Step into function call |
| `<F12>` | `n` | Step Out | Step out of current scope |
| `<leader>db` | `n` | Toggle Breakpoint | Place / remove breakpoint on current line |
| `<leader>dB` | `n` | Conditional Breakpoint | Prompt for boolean expression condition |
| `<leader>du` | `n` | Toggle DAP UI | Toggle debugger UI panels (Scopes, Watches, Stacks) |
| `<leader>dr` | `n` | Open REPL | Open interactive debug evaluation prompt |
| `<leader>dl` | `n` | Run Last Session | Re-run previous debug session configuration |
| `<leader>dt` | `n` | Terminate Session | Stop debugger process |

---

## 11. Integrated Terminal (ToggleTerm)

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `<C-\>` | `n`, `t` | Toggle Float Term | Open or dismiss floating terminal |
| `<leader>tt` | `n` | Toggle Terminal | Toggle default terminal |
| `<leader>tf` | `n` | Float Terminal | Open floating terminal |
| `<leader>th` | `n` | Horizontal Term | Open horizontal bottom terminal split |
| `<leader>tv` | `n` | Vertical Term | Open vertical right terminal split |
| `<Esc><Esc>` | `t` | Exit Terminal Mode | Return from Terminal Mode to Normal Mode |

---

## 12. Editing & Code Transformations

| Keybinding | Mode | Action | Description |
| :--- | :---: | :--- | :--- |
| `J` | `v` | Move Line Down | Move highlighted lines down with auto-reindent |
| `K` | `v` | Move Line Up | Move highlighted lines up with auto-reindent |
| `<` | `v` | Shift Left | Indent left while maintaining visual selection |
| `>` | `v` | Shift Right | Indent right while maintaining visual selection |
| `gcc` | `n` | Toggle Comment Line | Toggle comment on current line |
| `gc` | `v` | Toggle Comment Block | Toggle comment on highlighted lines |
| `ys<motion><char>` | `n` | Add Surround | Add delimiter around motion (e.g., `ysiw"` quotes word) |
| `cs<old><new>` | `n` | Change Surround | Change surrounding delimiter (e.g., `cs"'` turns `"..."` into `'...'`) |
| `ds<char>` | `n` | Delete Surround | Delete surrounding delimiter (e.g., `ds(` removes parentheses) |
| `]t` / `[t` | `n` | Next / Prev TODO | Jump between TODO/FIXME comments |
| `<Tab>` | `i` | Super-Tab | Cycle completion or jump to next snippet placeholder |
| `<S-Tab>` | `i` | Super-Tab Prev | Cycle backwards or jump to previous snippet placeholder |
| `<C-Space>` | `i` | Trigger Completion | Open nvim-cmp completion popup |
| `<CR>` | `i` | Confirm Completion | Accept selected completion item |
| `<leader>qs` | `n` | Restore Session | Restore workspace session for current directory |
| `<leader>ql` | `n` | Restore Last | Restore the most recently saved session |
