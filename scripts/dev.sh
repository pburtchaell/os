#!/bin/bash
# Description: Installs development tools (Homebrew, Oh My Zsh, Node, pnpm, Python, Claude Code, Mole)
#
# Note: This script downloads and executes installers from the internet (Homebrew, Oh My Zsh, Claude Code).
# While these are official installation methods over HTTPS, review the scripts if concerned:
#   - Homebrew: https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
#   - Oh My Zsh: https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#   - Claude Code: https://claude.ai/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
enable_simulate

space
log "Installing development tools"

###############################################################################
# Homebrew                                                                     #
###############################################################################

if command -v brew &>/dev/null; then
    success "Homebrew is already installed" 1
elif [ "${SIMULATE:-0}" = "1" ]; then
    success "Homebrew installed" 1
# Use NONINTERACTIVE to prevent prompts since we handle sudo separately
elif spin "Installing Homebrew..." env NONINTERACTIVE=1 /bin/bash -c "$(curl --fail -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        log "Add this to your shell profile for persistent PATH:" 1
        echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\""
    fi
else
    exit 1
fi

###############################################################################
# Oh My Zsh                                                                    #
###############################################################################

if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh is already installed" 1
elif [ "${SIMULATE:-0}" = "1" ]; then
    success "Oh My Zsh installed" 1
# Use --unattended to prevent prompts; note this may modify ~/.zshrc
elif ! spin "Installing Oh My Zsh..." sh -c "$(curl --fail -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
    exit 1
fi

###############################################################################
# Node.js                                                                      #
###############################################################################

if command -v node &>/dev/null; then
    success "Node.js is already installed ($(node --version))" 1
else
    spin "Installing Node.js..." brew install node || exit 1
fi

###############################################################################
# pnpm                                                                         #
###############################################################################

if command -v pnpm &>/dev/null; then
    success "pnpm is already installed ($(pnpm --version))" 1
else
    spin "Installing pnpm..." brew install pnpm || exit 1
fi

###############################################################################
# Python                                                                       #
###############################################################################

if brew list python &>/dev/null; then
    success "Python is already installed ($(python3 --version))" 1
else
    spin "Installing Python..." brew install python || exit 1
fi

###############################################################################
# Claude Code                                                                  #
###############################################################################

if command -v claude &>/dev/null; then
    success "Claude Code is already installed" 1
elif [ "${SIMULATE:-0}" = "1" ]; then
    success "Claude Code installed" 1
# Native installer (https://claude.ai/install.sh)
elif ! spin "Installing Claude Code..." bash -c "$(curl --fail -fsSL https://claude.ai/install.sh)"; then
    exit 1
fi

###############################################################################
# Mole                                                                         #
###############################################################################

if command -v mole &>/dev/null; then
    success "Mole is already installed" 1
else
    spin "Installing Mole..." brew install mole || exit 1
fi

success "Development tools installed successfully"
exit 0
