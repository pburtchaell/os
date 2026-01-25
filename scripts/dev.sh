#!/bin/bash
# Description: Installs development tools (Homebrew, Oh My Zsh, Node, pnpm, Claude Code)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo ""
info "Installing development tools"

###############################################################################
# Homebrew                                                                     #
###############################################################################

if command -v brew &>/dev/null; then
    success "Homebrew is already installed"
else
    if run_step "Installing Homebrew..." /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        exit 1
    fi
fi

###############################################################################
# Oh My Zsh                                                                    #
###############################################################################

if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh is already installed"
else
    run_step "Installing Oh My Zsh..." sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || exit 1
fi

###############################################################################
# Node.js                                                                      #
###############################################################################

if command -v node &>/dev/null; then
    success "Node.js is already installed ($(node --version))"
else
    run_step "Installing Node.js..." brew install node || exit 1
fi

###############################################################################
# pnpm                                                                         #
###############################################################################

if command -v pnpm &>/dev/null; then
    success "pnpm is already installed ($(pnpm --version))"
else
    run_step "Installing pnpm..." brew install pnpm || exit 1
fi

###############################################################################
# Claude Code                                                                  #
###############################################################################

if command -v claude &>/dev/null; then
    success "Claude Code is already installed"
else
    run_step "Installing Claude Code..." brew install claude || exit 1
fi

confirm "Development tools installed successfully"
exit 0
