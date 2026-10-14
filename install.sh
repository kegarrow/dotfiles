#!/usr/bin/env bash
# ==============================================================================
# NVIM IDE AUTOMATED INSTALLER (LINUX / MACOS)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo -e "\033[1;36m==========================================================\033[0m"
echo -e "\033[1;36m       NEOVIM FULL-BLOWN IDE INSTALLER (POSIX)            \033[0m"
echo -e "\033[1;36m==========================================================\033[0m"

# 1. Dependency Check
echo -e "\n\033[1;33m[+] Checking Core CLI Dependencies...\033[0m"
for cmd in nvim git rg fd fzf node python3; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "  \033[0;32m[✓]\033[0m $cmd is installed"
    else
        echo -e "  \033[0;33m[!]\033[0m Warning: '$cmd' is not in PATH. Please install it using your system package manager."
    fi
done

# 2. Backup Existing Config
echo -e "\n\033[1;33m[+] Deploying Neovim configuration to: $CONFIG_DIR\033[0m"
if [ -d "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    BACKUP_DIR="${CONFIG_DIR}.backup.$(date +%Y%m%d%H%M%S)"
    echo -e "  \033[0;36m[*]\033[0m Existing configuration detected. Backing up to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

mkdir -p "$(dirname "$CONFIG_DIR")"
cp -r "$SCRIPT_DIR/nvim" "$CONFIG_DIR"
echo -e "  \033[0;32m[✓]\033[0m Configuration copied successfully."

# 3. Synchronize Plugins Headless
if command -v nvim >/dev/null 2>&1; then
    echo -e "\n\033[1;33m[+] Synchronizing plugins via lazy.nvim...\033[0m"
    nvim --headless "+Lazy! sync" +qa
    echo -e "  \033[0;32m[✓]\033[0m Plugins synchronized successfully!"
fi

echo -e "\n\033[1;36m==========================================================\033[0m"
echo -e "\033[1;32m [✓] NEOVIM IDE INSTALLATION COMPLETED SUCCESSFULLY!\033[0m"
echo -e "\033[1;36m Launch your IDE anytime by typing: nvim\033[0m"
echo -e "\033[1;36m==========================================================\033[0m"
