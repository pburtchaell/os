#!/bin/bash
# Description: Configures the macOS Dock with preferred applications

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo ""
info "Configuring Dock"

# Check if dockutil is installed
if ! command -v dockutil &> /dev/null; then
    warn "dockutil is required but not installed"
    
    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        read -p "  Would you like to install dockutil now? (y/n): " install_choice
        case "$install_choice" in
            y|Y|yes|Yes)
                if run_step "Installing dockutil..." brew install dockutil; then
                    :  # run_step already shows success message
                else
                    error "Failed to install dockutil"
                    exit 1
                fi
                ;;
            *)
                warn "Skipping Dock configuration. Install dockutil with: brew install dockutil"
                exit 0
                ;;
        esac
    else
        error "Please install Homebrew first, then run: brew install dockutil"
        exit 1
    fi
fi

###############################################################################
# Clear existing dock items                                                   #
###############################################################################

step_start "Removing existing Dock items..."
dockutil --remove all --no-restart 2>/dev/null || true
step_done "Dock cleared"

###############################################################################
# Add core apps                                                               #
###############################################################################

# Helper function to add an app to the dock
add_app() {
    local app_path="$1"
    local app_name="$2"
    if [ -d "$app_path" ]; then
        substep_start "Adding $app_name..."
        if dockutil --add "$app_path" --no-restart &>/dev/null; then
            substep_done "$app_name added"
        else
            substep_skip "$app_name failed to add"
        fi
    else
        substep_skip "$app_name not installed"
    fi
}

step "Adding apps to Dock:"

# Core apps
add_app "/System/Applications/Messages.app" "Messages"
add_app "/Applications/Google Chrome.app" "Google Chrome"
add_app "/Applications/ChatGPT.app" "ChatGPT"
add_app "/Applications/Claude.app" "Claude"
add_app "/Applications/GitHub Desktop.app" "GitHub Desktop"
add_app "/Applications/Ghostty.app" "Ghostty"
add_app "/Applications/Cursor.app" "Cursor"
add_app "/Applications/Xcode.app" "Xcode"

###############################################################################
# Add folders                                                                 #
###############################################################################

step "Adding folders to Dock:"
substep_start "Adding Downloads..."
if dockutil --add "$HOME/Downloads" --view grid --display folder --no-restart &>/dev/null; then
    substep_done "Downloads added"
else
    substep_skip "Downloads failed to add"
fi

###############################################################################
# Dock preferences                                                            #
###############################################################################

step_start "Configuring Dock preferences..."
defaults write com.apple.dock show-recents -bool false
step_done "Dock preferences configured"

###############################################################################
# Restart Dock                                                                #
###############################################################################

step_start "Restarting Dock..."
killall Dock
step_done "Dock restarted"

confirm "Dock configured successfully"
