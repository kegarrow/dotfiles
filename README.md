# Modern Neovim Full-Blown IDE Dotfiles

[![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1%20%2F%20LuaJIT-000080?logo=lua&logoColor=white)](https://luajit.org)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)](#installation)
[![Security](https://img.shields.io/badge/Security-Hardened%20%26%20Pinned-success)](#security-architecture)
[![Plugin Manager](https://img.shields.io/badge/Manager-lazy.nvim-ff69b4)](https://github.com/folke/lazy.nvim)

> A blazing fast, fully featured, secure, and reproducible Neovim IDE configuration crafted for professional software development across Windows, Linux, and macOS.

---

## Highlights

- **Smart Viewport Text Wrapping**: Soft line wrapping enabled across all viewports with word-boundary wrapping (`linebreak = true`), matching indentation continuation (`breakindent = true`), visual glyphs (`showbreak = "↳ "`), natural visual line navigation (`j`/`k`), and dynamic toggle (`<leader>tw`).
- **Cyberpunk Startup Dashboard**: Custom animated startup screen (`alpha-nvim`) featuring ASCII art, instant access keys, session restoration, and real-time plugin load telemetry.
- **IDE Breadcrumbs Navigation**: Sticky breadcrumbs at the top of the buffer (`dropbar.nvim`) displaying current directory, file, class, method, and function context.
- **Enterprise-Grade Security**: Global modeline attack mitigation (CVE-2019-12735), isolated undo permissions (`0700`), sandbox protections, strict HTTPS Git protocols, and 100% deterministic dependency pinning via `lazy-lock.json`.
- **Intelligent Diagnostics Tree**: Modern IDE problem panel (`trouble.nvim` v3) organizing project-wide diagnostics, symbols, and references into a clean collapsible tree (`<leader>xx`, `<leader>cs`).
- **Live Incremental Renaming**: Interactive real-time symbol renaming on screen (`inc-rename.nvim`) powered by Language Server Protocol.
- **Interactive 3-Way Git Conflict Resolver**: Colored diff conflict blocks with 1-key resolution (`co` ours, `ct` theirs, `cb` both, `c0` none) via `git-conflict.nvim`.
- **Intelligent Code Intelligence (LSP)**: Turnkey Language Server Protocol support via `nvim-lspconfig` and `mason.nvim` with inlay hints, code actions, references, and hover docs.
- **AST-Powered Syntax Highlighting**: Real-time syntax parsing with `nvim-treesitter` backed by bundled native parsers in Neovim 0.12 and automated **Zig** (`zig cc`) cross-compilation on Windows.
- **Interactive Full IDE Debugging (DAP)**: Four-pane visual debugger (`nvim-dap` & `nvim-dap-ui`) with breakpoints, call stacks, variable watches, and virtual inline text.
- **Visual Color Previews & Smooth Physics**: Real-time hex/rgb/hsl color highlighting (`nvim-colorizer.lua`) and smooth cinematic physics scrolling (`neoscroll.nvim`).
- **Complete Git Integration**: Real-time gutter hunk indicators, hunk staging, inline blame, floating `lazygit.nvim` terminal GUI, and side-by-side reviews via `diffview.nvim`.
- **Asynchronous Formatting & Linting**: Zero-lag format-on-save via `conform.nvim` (Prettier, Black, Stylua, Rustfmt) and background static analysis with `nvim-lint`.

---

## Architecture & Directory Layout

```
dotfiles/
├── .gitignore
├── install.ps1                 # Automated Windows PowerShell installer
├── install.sh                  # Automated Linux/macOS POSIX installer
├── README.md                   # Complete repository documentation
├── docs/
│   ├── ARCHITECTURE.md         # Modular design, lifecycle & lazy-loading strategy
│   ├── KEYMAPS.md              # Exhaustive cheatsheet of all keybindings
│   ├── LSP_FORMAT_LINT.md      # Language servers, formatters & linting setup
│   ├── OPTIONS.md              # Option-by-option breakdown & rationale
│   ├── PLUGINS.md              # Complete guide to the curated plugin stack
│   └── SECURITY.md             # Threat model, CVE mitigations & hardening
└── nvim/
    ├── init.lua                # Clean entrypoint (<leader> = Space)
    ├── lazy-lock.json          # Pinned Git commit hashes for reproducibility
    └── lua/
        ├── config/
        │   ├── autocmds.lua    # Event lifecycle hooks (highlight on yank, auto-resize)
        │   ├── keymaps.lua     # Core ergonomic keybindings
        │   ├── lazy.lua        # Lazy.nvim bootstrap & HTTPS git enforcement
        │   ├── options.lua     # Modern IDE defaults, tabs, hybrid line numbers
        │   └── security.lua    # Modeline mitigation, exrc sandbox & path permissions
        └── plugins/
            ├── completion.lua  # nvim-cmp, LuaSnip & friendly-snippets
            ├── dap.lua         # Interactive debugger (nvim-dap & dap-ui)
            ├── dashboard.lua   # Cyberpunk startup screen (alpha-nvim)
            ├── editor.lua      # which-key, autopairs, surround, comment, flash
            ├── explorer.lua    # Neo-tree file tree & Oil.nvim directory editor
            ├── finder.lua      # Telescope fuzzy search & live grep
            ├── formatting.lua  # conform.nvim asynchronous format-on-save
            ├── git.lua         # gitsigns, lazygit, diffview & git-conflict
            ├── linting.lua     # nvim-lint background static analysis
            ├── lsp.lua         # Mason, LSP servers, inlay hints & inc-rename
            ├── terminal.lua    # toggleterm floating & split terminals
            ├── treesitter.lua  # Syntax parsing & AST text objects
            ├── trouble.lua     # Trouble.nvim diagnostics & symbol tree
            └── ui.lua          # Tokyo Night, dropbar, colorizer, neoscroll & lualine
```

---

## Quickstart & Installation

### Windows Installation (Automated)

Run the included PowerShell installer script:
```powershell
powershell -ExecutionPolicy RemoteSigned -File ".\install.ps1"
```

The installer automatically:
1. Detects and installs required CLI tools via `winget` (`ripgrep`, `fd`, `fzf`, `lazygit`, `node`, `python`, `zig`).
2. Configures `pynvim` for Python Neovim integration.
3. Deploys the configuration to `$env:LOCALAPPDATA\nvim` (creating a timestamped backup if an existing config exists).
4. Runs headless plugin synchronization to compile parsers and lock dependencies.

### Linux / macOS Installation (Automated)

```bash
chmod +x ./install.sh
./install.sh
```

---

## Core Keybindings Quick Reference

The leader key is mapped to **`Space`** (`<leader> = " "`).

### Navigation & Files
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<leader>tw` | Toggle Wrap | Toggle soft text wrapping in the viewport |
| `j` / `k` | Visual Motion | Navigate smoothly across wrapped lines (`gj`/`gk`) |
| `<leader>e` | Toggle Neo-tree | Open or close the sidebar file explorer |
| `-` | Open Oil | Edit directory directly like a text buffer |
| `<leader><space>` | Find Files | Fuzzy search project files |
| `<leader>fg` | Live Grep | Search text across entire workspace (Ripgrep) |
| `<leader>fb` | Buffers | Search open buffer tabs |
| `<leader>w` | Save | Write current buffer to disk |
| `<leader>q` | Quit | Close current window |
| `[b` / `]b` | Buffer Cycle | Switch between open buffer tabs |
| `<leader>bd` | Close Buffer | Close buffer without disrupting split window layout |

### Code Intelligence (LSP) & Diagnostics
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `gd` | Definition | Jump to symbol definition |
| `gr` | References | List all symbol references in Telescope |
| `K` | Hover | Show documentation and parameter types |
| `<leader>ca` | Code Action | Open refactoring / auto-import options |
| `<leader>cr` | IncRename | Live interactive symbol renaming with instant preview |
| `<leader>xx` | Diagnostics Tree | Open Trouble.nvim project-wide diagnostics tree |
| `<leader>cs` | Symbols Tree | Open Trouble.nvim code symbols outline |
| `<leader>cf` | Format | Format buffer (Prettier / Black / Stylua) |
| `<leader>th` | Inlay Hints | Toggle parameter and variable inline type hints |
| `[d` / `]d` | Diagnostics | Jump to previous / next error or warning |
| `<leader>cd` | Line Diagnostic | Display full error message popup |

### Version Control & Conflict Resolution
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `]h` / `[h` | Hunk Jump | Jump to next / previous Git diff hunk |
| `<leader>hs` | Stage Hunk | Stage current hunk to Git index |
| `<leader>hr` | Reset Hunk | Discard changes in current hunk |
| `<leader>hp` | Preview Hunk | Popup preview of hunk diff |
| `<leader>hb` | Blame Line | Detailed Git commit author and timestamp |
| `<leader>gg` | LazyGit | Open full-screen floating LazyGit terminal UI |
| `<leader>gd` | Diffview | Open side-by-side interactive visual diff |
| `co` / `ct` | Merge Conflicts | Choose ours (`co`) or choose theirs (`ct`) |
| `cb` / `c0` | Merge Conflicts | Choose both (`cb`) or choose none (`c0`) |
| `]x` / `[x` | Conflict Jump | Jump to next / previous merge conflict |

### Interactive Debugging (DAP)
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<F5>` | Start / Continue | Launch debug adapter or continue execution |
| `<F10>` | Step Over | Step over function or line |
| `<F11>` | Step Into | Step into function call |
| `<F12>` | Step Out | Step out of current scope |
| `<leader>db` | Breakpoint | Toggle breakpoint on current line |
| `<leader>dB` | Cond. Breakpoint | Set conditional expression breakpoint |
| `<leader>du` | Toggle UI | Open or close debugger panels (Watches, Scopes) |

*For the complete list of 80+ keybindings, see [docs/KEYMAPS.md](docs/KEYMAPS.md).*

---

## Security Architecture

This configuration was designed under a strict **zero-trust, defense-in-depth** security model:

1. **Modeline CVE Mitigations**: Modeline parsing is disabled globally (`modeline = false`, `modelines = 0`), completely eliminating remote command injection vulnerabilities such as CVE-2019-12735.
2. **Project Config Sandboxing**: Automatic execution of untrusted `.exrc`, `.nvimrc`, and `.nvim.lua` files found in foreign repositories is blocked (`exrc = false`, `secure = true`).
3. **Reproducible Pinned Dependencies**: Every plugin is locked to an immutable Git commit hash in `lazy-lock.json`, preventing supply-chain attacks and breaking upstream changes.
4. **Encrypted Transport**: Lazy.nvim enforces HTTPS Git URLs for all network fetch operations.
5. **Private Persistent Undo**: Undo history is isolated exclusively to user-private app data (`0700` permissions), preventing credential leakage in shared environments.
6. **Sensitive File Warnings**: Automatic alerts when opening credentials (`.env`, `*.pem`, `*credentials*`).

*For full threat modeling details, see [docs/SECURITY.md](docs/SECURITY.md).*

---

## Detailed Documentation Directory

- **[docs/OPTIONS.md](docs/OPTIONS.md)**: Option-by-option reference manual explaining every Vim setting.
- **[docs/KEYMAPS.md](docs/KEYMAPS.md)**: Exhaustive cheatsheet of all keyboard shortcuts.
- **[docs/SECURITY.md](docs/SECURITY.md)**: In-depth security model and CVE mitigations.
- **[docs/PLUGINS.md](docs/PLUGINS.md)**: Complete guide to the curated plugin stack.
- **[docs/LSP_FORMAT_LINT.md](docs/LSP_FORMAT_LINT.md)**: LSP, Mason, Treesitter with Zig, and formatting/linting guide.
- **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**: Startup sequence, modular design, and lazy loading strategy.

---

## Verification & Health Check

Run Neovim's built-in health check anytime to verify your environment:
```vim
:checkhealth
```

Enjoy your full-blown Neovim IDE!
