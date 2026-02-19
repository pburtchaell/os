#!/bin/bash
# Description: Configures macOS system preferences for development

# Exit on error, but allow individual commands to fail gracefully
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo ""
info "Configuring macOS preferences"

# Note: Safari preferences are stored in a sandboxed container on modern macOS.
# These commands require Full Disk Access for Terminal, or they will be skipped.
step_start "Configuring Safari..."
if defaults write com.apple.Safari ShowFavoritesBar -bool false 2>/dev/null; then
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    defaults write com.apple.Safari HomePage -string "about:blank"
    defaults write com.apple.Safari AutoFillPasswords -bool false
    defaults write -g AutoFillPasswords -bool false
    step_done "Safari configured"
else
    step_skip "Safari skipped (requires Full Disk Access for Terminal)"
fi

if [ -d "/Applications/Google Chrome.app" ]; then
    step_start "Configuring Google Chrome..."
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome DisablePrintPreview -bool true
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    defaults write com.google.Chrome DnsPrefetchingEnabled -bool false
    defaults write com.google.Chrome BackgroundModeEnabled -bool false
    step_done "Google Chrome configured"
else
    step_skip "Google Chrome not installed, skipping"
fi

step_start "Configuring general UX settings..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
step_done "General UX settings configured"

step_start "Configuring keyboard..."
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
step_done "Keyboard configured"

step_start "Configuring trackpad..."
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0
step_done "Trackpad configured"

step_start "Configuring screen capture..."
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
step_done "Screen capture configured"

step_start "Configuring Finder..."
chflags nohidden ~/Library || true
sudo chflags nohidden /Volumes || true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
step_done "Finder configured"

step_start "Configuring Dock..."
defaults write com.apple.dock show-process-indicators -bool true
step_done "Dock configured"

step_start "Configuring Terminal..."
defaults write com.apple.terminal StringEncodings -array 4
touch ~/.hushlogin
step_done "Terminal configured"

step_start "Configuring TextEdit..."
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
step_done "TextEdit configured"

step_start "Configuring Activity Monitor..."
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
step_done "Activity Monitor configured"

step_start "Configuring Software Update..."
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AllowPreReleaseInstallation -bool false
defaults write com.apple.commerce AutoUpdate -bool true
step_done "Software Update configured"

step_start "Configuring Menu Bar & Control Center..."
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
defaults write "$HOME/Library/Preferences/ByHost/com.apple.controlcenter.plist" BatteryShowInControlCenter -bool true
defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool false
defaults write com.apple.Spotlight ShowSuggestionsInSpotlight -bool false
defaults write com.apple.Spotlight orderedItems -array \
    '{"enabled" = 0;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 1;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "DIRECTORIES";}' \
    '{"enabled" = 0;"name" = "FONTS";}' \
    '{"enabled" = 1;"name" = "IMAGES";}' \
    '{"enabled" = 1;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "PDF_DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 0;"name" = "TIPS";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}'
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool false
defaults write com.apple.TextInputMenu visible -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Timer" -bool false
defaults write com.apple.menuextra.clock ShowSeconds -bool true
step_done "Menu Bar & Control Center configured"

confirm "macOS preferences configured successfully"

# Prompt for reboot before restarting apps (so prompt displays correctly)
read -p "  Would you like to reboot your Mac now? (y/n): " reboot_choice
case "$reboot_choice" in
    y|Y|yes|Yes)
        step "Rebooting..."
        sudo reboot
        ;;
    *)
        warn "Skipping reboot. Some changes may require a restart to take effect."

        # Restart affected applications only if not rebooting
        step_start "Restarting affected applications..."

        for app in "Activity Monitor" \
            "cfprefsd" \
            "Dock" \
            "Finder" \
            "SystemUIServer"; do
            killall "${app}" >/dev/null 2>&1 || true
        done

        step_done "Applications restarted"
        ;;
esac

exit 0
