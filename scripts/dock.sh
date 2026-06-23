#!/bin/bash
# Description: Configures the macOS Dock with preferred applications

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
enable_simulate

space
log "Configuring Dock"

# Check if dockutil is installed
if ! command -v dockutil &> /dev/null; then
    warn "dockutil is required but not installed"

    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        if confirm "Install dockutil now?"; then
            spin "Installing dockutil..." brew install dockutil || exit 1
        else
            warn "Skipping Dock configuration. Install dockutil with: brew install dockutil"
            exit 0
        fi
    else
        error "Please install Homebrew first, then run: brew install dockutil"
        exit 1
    fi
fi

###############################################################################
# Clear existing dock items                                                   #
###############################################################################

dockutil --remove all --no-restart 2>/dev/null || true
success "Dock cleared" 1

###############################################################################
# Add core apps                                                               #
###############################################################################

# Helper function to add an app to the dock
add_app() {
    local app_path="$1"
    local app_name="$2"
    if [ ! -d "$app_path" ]; then
        warn "$app_name not installed" 2
        return
    fi
    if dockutil --add "$app_path" --no-restart &>/dev/null; then
        success "$app_name added" 2
    else
        warn "$app_name failed to add" 2
    fi
}

log "Adding apps to Dock:" 1

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

log "Adding folders to Dock:" 1
if dockutil --add "$HOME/Downloads" --view grid --display folder --no-restart &>/dev/null; then
    success "Downloads added" 2
else
    warn "Downloads failed to add" 2
fi

###############################################################################
# Dock preferences                                                            #
###############################################################################

defaults write com.apple.dock show-recents -bool false
success "Dock preferences configured" 1

###############################################################################
# Restart Dock                                                                #
###############################################################################

killall Dock
success "Dock restarted" 1

success "Dock configured successfully"
