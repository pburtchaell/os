#!/bin/bash
# Description: Configures the macOS Dock with preferred applications

set -e

echo "Configuring Dock..."

# Check if dockutil is installed
if ! command -v dockutil &> /dev/null; then
    echo "dockutil is required but not installed."
    
    # Check if Homebrew is available
    if command -v brew &> /dev/null; then
        read -p "Would you like to install dockutil now? (y/n): " install_choice
        case "$install_choice" in
            y|Y|yes|Yes)
                echo "Installing dockutil..."
                brew install dockutil
                ;;
            *)
                echo "Skipping Dock configuration. Install dockutil with: brew install dockutil"
                exit 0
                ;;
        esac
    else
        echo "Please install Homebrew first, then run: brew install dockutil"
        exit 1
    fi
fi

###############################################################################
# Clear existing dock items                                                   #
###############################################################################

# Remove all apps from dock except Finder (which cannot be removed)
dockutil --remove all --no-restart

###############################################################################
# Add core apps                                                               #
###############################################################################

# Add Messages
if [ -d "/System/Applications/Messages.app" ]; then
    dockutil --add "/System/Applications/Messages.app" --no-restart
fi

###############################################################################
# Add development apps (if installed)                                         #
###############################################################################

# Google Chrome
if [ -d "/Applications/Google Chrome.app" ]; then
    dockutil --add "/Applications/Google Chrome.app" --no-restart
fi

# GitHub Desktop
if [ -d "/Applications/GitHub Desktop.app" ]; then
    dockutil --add "/Applications/GitHub Desktop.app" --no-restart
fi

# Cursor
if [ -d "/Applications/Cursor.app" ]; then
    dockutil --add "/Applications/Cursor.app" --no-restart
fi

# Xcode
if [ -d "/Applications/Xcode.app" ]; then
    dockutil --add "/Applications/Xcode.app" --no-restart
fi

# Visual Studio Code
if [ -d "/Applications/Visual Studio Code.app" ]; then
    dockutil --add "/Applications/Visual Studio Code.app" --no-restart
fi

# Figma
if [ -d "/Applications/Figma.app" ]; then
    dockutil --add "/Applications/Figma.app" --no-restart
fi

# ChatGPT
if [ -d "/Applications/ChatGPT.app" ]; then
    dockutil --add "/Applications/ChatGPT.app" --no-restart
fi

# Claude
if [ -d "/Applications/Claude.app" ]; then
    dockutil --add "/Applications/Claude.app" --no-restart
fi

# Ghostty
if [ -d "/Applications/Ghostty.app" ]; then
    dockutil --add "/Applications/Ghostty.app" --no-restart
fi

###############################################################################
# Add folders                                                                 #
###############################################################################

# Add Downloads folder
dockutil --add "~/Downloads" --view grid --display folder --no-restart

###############################################################################
# Dock preferences                                                            #
###############################################################################

# Disable recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Restart Dock                                                                #
###############################################################################

killall Dock

echo "Dock configured successfully."
