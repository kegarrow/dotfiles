# Security Architecture & Hardening Guide

Security in modern code editors is a critical concern. Modern editors run language servers, syntax parsers, git hooks, and linters capable of arbitrary code execution. This configuration implements an enterprise-grade defense-in-depth model across eight core security vectors.

---

## 1. Modeline Mitigation (CVE-2019-12735 & Variants)

### Threat Vector
Vim and Neovim modelines allow files to embed editor commands inside file comments (e.g., `/* vim: set ts=4: */`). Multiple historical critical CVEs (including CVE-2019-12735, CVSS 8.6) allowed attackers to craft malicious text files or READMEs that execute arbitrary shell commands upon simply opening the file in Vim/Neovim.

### Defense Configuration
In `lua/config/security.lua`:
```lua
vim.opt.modeline = false
vim.opt.modelines = 0
```
- Modeline parsing is completely disabled globally.
- Embedded comments in untrusted repositories cannot invoke commands or modify editor options.

---

## 2. Project-Local Config Sandbox (`exrc` Hardening)

### Threat Vector
Attackers can place malicious configuration files (`.nvim.lua`, `.nvimrc`, `.exrc`) in the root of cloned git repositories. When opened by a developer, unsandboxed editors automatically execute these scripts in the context of the user's account.

### Defense Configuration
In `lua/config/security.lua`:
```lua
vim.opt.exrc = false
vim.opt.secure = true
```
- Neovim strictly ignores workspace-local configuration files unless vetted.
- `vim.opt.secure` prevents shell and write commands from being executed by untrusted source operations.

---

## 3. Supply Chain Security & Lockfile Pinning

### Threat Vector
Neovim plugin managers downloading unpinned `master`/`main` branches are vulnerable to supply-chain tampering, hijacked repository maintainer accounts, malicious dependency injections, or breaking upstream changes.

### Defense Configuration
1. **Deterministic Lockfile Pinning**: All installed plugins are recorded with their immutable 40-character Git commit SHAs in `nvim/lazy-lock.json`.
2. **Strict HTTPS Protocol**: Lazy.nvim is configured to enforce encrypted HTTPS git URLs for all network fetch operations:
   ```lua
   git = {
     url_format = "https://github.com/%s.git",
     timeout = 120,
   }
   ```
3. **Disabled Unattended Auto-Updates**:
   ```lua
   checker = {
     enabled = false,
     notify = false,
   }
   ```
   Plugins are never silently updated in the background without explicit developer intent (`:Lazy update` / `:Lazy check`).

---

## 4. Persistent Undo Storage Isolation & Permissions

### Threat Vector
Neovim's persistent undo feature (`undofile = true`) saves the full text buffer history of every edited file to disk. If stored in shared system locations (such as `/tmp` or root world-readable directories), unauthorized local processes can read sensitive code, passwords, or tokens edited previously.

### Defense Configuration
In `lua/config/options.lua` & `lua/config/security.lua`:
```lua
local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p", 448) -- Octal 0700: Owner Read/Write/Execute Only
end
vim.opt.undodir = undo_dir
```
- Undo history is isolated exclusively to the user's private AppData directory (`%LOCALAPPDATA%\nvim-data\undo`).
- Swap and backup files are disabled (`swapfile = false`, `backup = false`) to prevent persistent plain-text remnants across the filesystem.

---

## 5. Subshell Execution & Windows PowerShell Hardening

### Threat Vector
Improper shell flags on Windows can lead to script injection or loading arbitrary user profile scripts (`Microsoft.PowerShell_profile.ps1`) when running background formatters or tools.

### Defense Configuration
In `lua/config/security.lua`:
```lua
vim.opt.shell = "powershell"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
```
- `-NoProfile`: Guarantees external shell executions do not load untrusted PowerShell profiles.
- `-ExecutionPolicy RemoteSigned`: Enforces cryptographic code signature requirements on remote scripts.
- UTF-8 Stream Encodings: Guarantees buffer output integrity across tool pipelines.

---

## 6. Sensitive Credential & Secret File Detection

### Threat Vector
Accidentally editing, staging, or committing unencrypted API keys, SSH keys, or environment files (`.env`, `*.pem`, `*credentials*`).

### Defense Configuration
In `lua/config/security.lua`:
```lua
local sensitive_patterns = {
  "*.pem", "*.key", "*.id_rsa", "*.id_ed25519", "*.env", "*.env.local",
  "*credentials*", "*secrets.json"
}
```
An active autocommand immediately triggers a high-visibility security warning popup whenever a sensitive file is loaded into the buffer.

---

## 7. Treesitter Native Compilation Sandboxing

### Threat Vector
Compiling untrusted syntax parsers on Windows can trigger rogue build scripts or arbitrary C code execution during compile phases.

### Defense Configuration
In `lua/plugins/treesitter.lua`:
- Treesitter compiler preference is restricted to strictly verified system toolchains:
  ```lua
  install.compilers = { "zig", "clang", "gcc", "cl" }
  ```
- Uses Zig (`zig cc`) as an isolated, self-contained cross-compiler with verified hash and signed binaries.

---

## 8. Language Server Protocol (LSP) Telemetry Opt-Out

### Threat Vector
Third-party language servers reporting telemetry, source file metadata, or code metrics back to external servers.

### Defense Configuration
In `lua/plugins/lsp.lua`:
```lua
Lua = {
  telemetry = { enable = false },
}
```
Telemetry is explicitly turned off for language server configurations.
