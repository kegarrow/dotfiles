# LSP, Treesitter, Formatting & Linting Architecture

This guide explains the code intelligence engine powering this Neovim IDE, including the Language Server Protocol (LSP), Treesitter AST parser compilation, asynchronous formatting, and background linting.

---

## 1. High-Level Architecture

```
                                 ┌─────────────────────────┐
                                 │       Neovim Core       │
                                 └────────────┬────────────┘
                                              │
                      ┌───────────────────────┼─────────────────────────┐
                      ▼                       ▼                         ▼
            ┌───────────────────┐   ┌───────────────────┐     ┌───────────────────┐
            │  nvim-treesitter  │   │  nvim-lspconfig   │     │    conform.nvim   │
            │   (AST Parser)    │   │   (LSP Client)    │     │   (Format Engine) │
            └─────────┬─────────┘   └─────────┬─────────┘     └─────────┬─────────┘
                      │                       │                         │
                      ▼                       ▼                         ▼
            ┌───────────────────┐   ┌───────────────────┐     ┌───────────────────┐
            │    Zig (zig cc)   │   │    Mason.nvim     │     │ Prettier / Black  │
            │  Parser Compiler  │   │  (Package Hub)    │     │ Stylua / Rustfmt  │
            └───────────────────┘   └─────────┬─────────┘     └───────────────────┘
                                              │
                                              ▼
                                   ┌──────────────────────┐
                                   │ Language Servers:    │
                                   │ • pyright            │
                                   │ • ts_ls              │
                                   │ • rust_analyzer      │
                                   │ • lua_ls             │
                                   │ • jsonls / yamlls    │
                                   │ • html / cssls       │
                                   └──────────────────────┘
```

---

## 2. Treesitter & Parser Compilation

### Why Treesitter?
Unlike traditional regex-based syntax highlighters that easily break on complex code, Treesitter builds a concrete syntax tree (AST) in memory. This enables:
- Accurate context-aware syntax highlighting.
- AST-level code navigation (jumping between functions, classes, and parameter blocks).
- Incremental visual selection (`<C-Space>` expands selection to enclosing expression/block, `<BS>` shrinks selection).
- Code indentation based on AST hierarchy.

### Compiler on Windows (Zig Toolchain)
Neovim Treesitter compiles language parsers written in C. On Windows, compiling without heavyweight Visual Studio Build Tools can be challenging.
In this configuration, **Zig** (`0.17.0`) is installed and configured as the preferred compiler:
```lua
local ok_install, install = pcall(require, "nvim-treesitter.install")
if ok_install then
  install.compilers = { "zig", "clang", "gcc", "cl" }
end
```
Zig acts as a zero-dependency C compiler (`zig cc`) capable of compiling all Treesitter grammars cleanly out of the box.

---

## 3. Language Server Protocol (LSP) Engine

### Mason Package Manager
`mason.nvim` manages LSP servers, DAP debuggers, linters, and formatters directly inside Neovim.
- Open Mason UI: `<leader>cm`
- Check package status: Installed (`✓`), Pending (`➜`), Uninstalled (`✗`).

### Preconfigured Language Servers
The configuration includes turnkey setups for the following languages:

| Language | Language Server | Key Features Configured |
| :--- | :--- | :--- |
| **Lua** | `lua_ls` | Neovim Lua API typings (`lazydev.nvim`), global `vim` resolution, telemetry disabled. |
| **Python** | `pyright` | Auto search paths, type analysis, library code navigation, workspace diagnostics. |
| **TypeScript / JS**| `ts_ls` | Inlay parameter name hints, variable type hints, auto imports. |
| **Rust** | `rust_analyzer` | Cargo all features, Clippy lint integration on check, inlay hints. |
| **Web (HTML/CSS)**| `html`, `cssls` | Tag completion, CSS property completion and validation. |
| **Data (JSON/YAML)**| `jsonls`, `yamlls` | Schema validation for package.json, docker-compose, and GitHub actions. |

### LSP Keybindings
When an LSP server attaches to any buffer, the following keybindings become active:
- `gd`: Jump to definition
- `gD`: Jump to declaration
- `gr`: Search references in Telescope
- `gi`: Search interface implementations in Telescope
- `gy`: Jump to type definition
- `K`: Display hover documentation
- `<C-k>`: Display function signature help
- `<leader>ca`: Open Code Action menu (auto-imports, refactorings, quick fixes)
- `<leader>cr`: Project-wide symbol rename
- `<leader>th`: Toggle Inlay Hints (inline type and argument names)

---

## 4. Asynchronous Code Formatting (Conform.nvim)

`conform.nvim` provides non-blocking code formatting:
- **Format on Save**: Enabled automatically with a 1500ms safety timeout.
- **LSP Fallback**: If a dedicated formatter is not installed, it cleanly falls back to the active Language Server's built-in formatting engine.
- **Manual Trigger**: Format any buffer or visual selection with `<leader>cf`.

### Formatter Toolchain Mapping

| Filetype | Formatters Configured |
| :--- | :--- |
| **Lua** | `stylua` |
| **Python** | `isort`, `black` |
| **JavaScript / TypeScript** | `prettierd` (fallback to `prettier`) |
| **JSON / JSONC / YAML** | `prettierd` (fallback to `prettier`) |
| **HTML / CSS / Markdown** | `prettierd` (fallback to `prettier`) |
| **Rust** | `rustfmt` |
| **Shell / Bash** | `shfmt` |

---

## 5. Background Static Analysis & Linting (Nvim-lint)

`nvim-lint` runs linters asynchronously on `BufEnter`, `BufWritePost`, and `InsertLeave` without blocking typing:
- **Python**: `ruff` / `flake8`
- **JavaScript / TypeScript**: `eslint_d`
- **Manual Trigger**: Run `<leader>cl` to invoke linting on demand.
- **Executable Validation**: The configuration validates linter binary existence before invocation, eliminating spurious notification warnings.
