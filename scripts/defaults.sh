#!/bin/bash
# Description: Configures macOS system preferences for development

# Exit on error, but allow individual commands to fail gracefully
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/utils.sh"
enable_simulate

echo ""
log "Configuring macOS preferences"

# Note: Safari preferences are stored in a sandboxed container on modern macOS.
# These commands require Full Disk Access for Terminal, or they will be skipped.
if defaults write com.apple.Safari ShowFavoritesBar -bool false 2>/dev/null; then
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    defaults write com.apple.Safari HomePage -string "about:blank"
    defaults write com.apple.Safari AutoFillPasswords -bool false
    defaults write -g AutoFillPasswords -bool false
    success "Safari configured" 1
else
    warn "Safari skipped (requires Full Disk Access for Terminal)" 1
fi

if [ -d "/Applications/Google Chrome.app" ]; then
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome DisablePrintPreview -bool true
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    defaults write com.google.Chrome DnsPrefetchingEnabled -bool false
    defaults write com.google.Chrome BackgroundModeEnabled -bool false
    success "Google Chrome configured" 1
else
    warn "Google Chrome not installed, skipping" 1
fi

defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
success "General UX settings configured" 1

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
success "Keyboard configured" 1

defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0
success "Trackpad configured" 1

defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
success "Screen capture configured" 1

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
success "Finder configured" 1

defaults write com.apple.dock show-process-indicators -bool true
success "Dock configured" 1

defaults write com.apple.terminal StringEncodings -array 4
touch ~/.hushlogin
success "Terminal configured" 1

defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
success "TextEdit configured" 1

defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
success "Activity Monitor configured" 1

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AllowPreReleaseInstallation -bool false
defaults write com.apple.commerce AutoUpdate -bool true
success "Software Update configured" 1

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
success "Menu Bar & Control Center configured" 1

success "macOS preferences configured successfully"

# Offer a reboot (skipped in simulate mode); otherwise restart affected apps.
if [ "${SIMULATE:-0}" != "1" ] && confirm "Reboot your Mac now?"; then
    log "Rebooting..." 1
    sudo reboot
else
    warn "Skipping reboot. Some changes may require a restart to take effect." 1

    # Restart affected applications only if not rebooting
    for app in "Activity Monitor" \
        "cfprefsd" \
        "Dock" \
        "Finder" \
        "SystemUIServer"; do
        killall "${app}" >/dev/null 2>&1 || true
    done

    success "Applications restarted" 1
fi

exit 0
