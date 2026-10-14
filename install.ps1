# ==============================================================================
# NVIM IDE AUTOMATED INSTALLER (WINDOWS POWERSHELL)
# ==============================================================================
# Run with: powershell -ExecutionPolicy RemoteSigned -File .\install.ps1

[CmdletBinding()]
param(
  [switch]$SkipDependencies = $false,
  [switch]$Symlink = $false
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "       NEOVIM FULL-BLOWN IDE INSTALLER (WINDOWS)          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Update Execution Policy for Current User
try {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Write-Host "[✓] ExecutionPolicy configured to RemoteSigned" -ForegroundColor Green
} catch {
  Write-Host "[!] Could not set execution policy, continuing..." -ForegroundColor Yellow
}

# 2. Dependency Verification & Installation
if (-not $SkipDependencies) {
  Write-Host "`n[+] Checking Core CLI Dependencies..." -ForegroundColor Yellow

  $wingetPackages = @(
    @{ Name = "ripgrep";  Id = "BurntSushi.ripgrep.MSVC"; Command = "rg" },
    @{ Name = "fd";       Id = "sharkdp.fd";              Command = "fd" },
    @{ Name = "fzf";      Id = "junegunn.fzf";            Command = "fzf" },
    @{ Name = "lazygit";  Id = "JesseDuffield.lazygit";   Command = "lazygit" },
    @{ Name = "nodejs";   Id = "OpenJS.NodeJS.LTS";       Command = "node" },
    @{ Name = "python";   Id = "Python.Python.3.12";      Command = "python" },
    @{ Name = "zig";      Id = "zig.zig";                 Command = "zig" }
  )

  foreach ($pkg in $wingetPackages) {
    if (Get-Command $pkg.Command -ErrorAction SilentlyContinue) {
      Write-Host "  [✓] $($pkg.Name) is already installed" -ForegroundColor Green
    } else {
      Write-Host "  [-] Installing $($pkg.Name) via WinGet..." -ForegroundColor Yellow
      winget install $pkg.Id --scope user --accept-package-agreements --accept-source-agreements
    }
  }

  # Refresh Session Environment Path
  $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')

  # Install Python Neovim Client (pynvim)
  if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "`n[+] Ensuring Python Neovim integration (pynvim)..." -ForegroundColor Yellow
    python -m pip install --upgrade --quiet pynvim
    Write-Host "  [✓] pynvim installed" -ForegroundColor Green
  }
}

# 3. Deploy Neovim Configuration to $LOCALAPPDATA\nvim
$sourceDir = Join-Path $PSScriptRoot "nvim"
$targetDir = Join-Path $env:LOCALAPPDATA "nvim"

Write-Host "`n[+] Deploying Neovim configuration to: $targetDir" -ForegroundColor Yellow

if (Test-Path $targetDir) {
  $backupDir = "$targetDir.backup.$((Get-Date).ToString('yyyyMMddHHmmss'))"
  Write-Host "  [*] Existing configuration detected. Backing up to $backupDir" -ForegroundColor Cyan
  Move-Item $targetDir $backupDir -Force
}

if ($Symlink) {
  Write-Host "  [+] Creating directory symlink..." -ForegroundColor Yellow
  New-Item -ItemType SymbolicLink -Path $targetDir -Target $sourceDir | Out-Null
} else {
  Write-Host "  [+] Copying configuration files..." -ForegroundColor Yellow
  Copy-Item -Recurse -Force $sourceDir $targetDir
}

# 4. Synchronize Plugins via lazy.nvim
Write-Host "`n[+] Synchronizing plugins headless..." -ForegroundColor Yellow
if (Get-Command nvim -ErrorAction SilentlyContinue) {
  nvim --headless "+Lazy! sync" +qa
  Write-Host "  [✓] Plugins synchronized successfully!" -ForegroundColor Green
} else {
  Write-Host "  [!] Neovim binary not found in PATH. Please ensure Neovim is installed." -ForegroundColor Red
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " [✓] NEOVIM IDE INSTALLATION COMPLETED SUCCESSFULLY!     " -ForegroundColor Green
Write-Host " Launch your IDE anytime by typing: nvim                  " -ForegroundColor Cyan
Write-Host " Documentation is available in: $PSScriptRoot\docs      " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
