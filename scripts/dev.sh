#!/bin/bash
# Description: Installs development tools (Homebrew, Oh My Zsh, Node, pnpm, Python, Claude Code)
#
# Note: This script downloads and executes installers from the internet (Homebrew, Oh My Zsh).
# While these are official installation methods over HTTPS, review the scripts if concerned:
#   - Homebrew: https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
#   - Oh My Zsh: https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

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
    step_start "Installing Homebrew..."
    # Use NONINTERACTIVE to prevent prompts since we handle sudo separately
    if NONINTERACTIVE=1 /bin/bash -c "$(curl --fail -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        step_done "Homebrew installed"
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            step "Note: Add this to your shell profile for persistent PATH:"
            echo "      eval \"\$(/opt/homebrew/bin/brew shellenv)\""
        fi
    else
        step_skip "Homebrew installation failed"
        exit 1
    fi
fi

###############################################################################
# Oh My Zsh                                                                    #
###############################################################################

if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh is already installed"
else
    step_start "Installing Oh My Zsh..."
    # Use --unattended to prevent prompts; note this may modify ~/.zshrc
    if sh -c "$(curl --fail -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        step_done "Oh My Zsh installed"
    else
        step_skip "Oh My Zsh installation failed"
        exit 1
    fi
fi

###############################################################################
# Node.js                                                                      #
###############################################################################

if command -v node &>/dev/null; then
    success "Node.js is already installed ($(node --version))"
else
    if ! run_step "Installing Node.js..." brew install node; then
        exit 1
    fi
fi

###############################################################################
# pnpm                                                                         #
###############################################################################

if command -v pnpm &>/dev/null; then
    success "pnpm is already installed ($(pnpm --version))"
else
    if ! run_step "Installing pnpm..." brew install pnpm; then
        exit 1
    fi
fi

###############################################################################
# Python                                                                       #
###############################################################################

if brew list python &>/dev/null; then
    success "Python is already installed ($(python3 --version))"
else
    if ! run_step "Installing Python..." brew install python; then
        exit 1
    fi
fi

###############################################################################
# Claude Code                                                                  #
###############################################################################

if command -v claude &>/dev/null; then
    success "Claude Code is already installed"
else
    # Check if the formula exists before attempting installation
    if brew info claude-code &>/dev/null; then
        if ! run_step "Installing Claude Code..." brew install claude-code; then
            exit 1
        fi
    else
        warn "Claude Code formula not found in Homebrew"
        step "Install manually: npm install -g @anthropic-ai/claude-code"
    fi
fi

confirm "Development tools installed successfully"
exit 0
