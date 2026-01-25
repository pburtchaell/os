#!/bin/bash
# Description: Configures macOS system preferences for development

# Exit on error, but allow individual commands to fail gracefully
set -e

echo "Configuring macOS preferences..."

###############################################################################
# Safari                                                                      #
###############################################################################

# Hide Safari bookmark bar
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Do not send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Set Safari's home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Disable AutoFill for passwords and verification codes
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write -g AutoFillPasswords -bool false

###############################################################################
# Google Chrome                                                               #
###############################################################################

# Disable swipe controls for Google Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use system print dialog instead of Chrome's
defaults write com.google.Chrome DisablePrintPreview -bool true

# Expand print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

# Disable Chrome's built-in DNS prefetching
defaults write com.google.Chrome DnsPrefetchingEnabled -bool false

# Disable background apps when Chrome is closed
defaults write com.google.Chrome BackgroundModeEnabled -bool false

###############################################################################
# General UX                                                              #
###############################################################################

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Enable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Faster key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Set trackpad speed to maximum
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# Disable the drop shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show the ~/Library folder
chflags nohidden ~/Library || true

# Show the /Volumes folder
sudo chflags nohidden /Volumes || true

# Show external hard drives and removable media on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show hidden files and file extensions by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Hide tags in Finder sidebar
defaults write com.apple.finder ShowRecentTags -bool false

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Set default Finder location to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"

###############################################################################
# Dock                                                                        #
###############################################################################

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Software Update                                                             #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Disable beta updates
defaults write com.apple.SoftwareUpdate AllowPreReleaseInstallation -bool false

# Turn on automatic app update
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Menu Bar & Control Center                                                   #
###############################################################################

# Hide WiFi from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false

# Hide Battery from menu bar (show in Control Center only)
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowInControlCenter -bool true

# Hide Spotlight search from menu bar
defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool false

# Disable Spotlight suggestions (related content in search)
defaults write com.apple.Spotlight ShowSuggestionsInSpotlight -bool false

# Configure Spotlight search results (only Messages, Contacts, Calendar, Notes, Photos, System Settings)
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

# Hide Siri from menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false

# Hide Focus from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false

# Hide Sound from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool false

# Hide Keyboard from menu bar
defaults write com.apple.TextInputMenu visible -bool false

# Hide Display from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool false

# Hide Now Playing from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false

# Hide Timer from menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Timer" -bool false

# Show seconds in menu bar clock
defaults write com.apple.menuextra.clock ShowSeconds -bool true

###############################################################################
# Restart affected applications                                               #
###############################################################################

echo "Restarting affected applications..."

for app in "Activity Monitor" \
    "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
    killall "${app}" >/dev/null 2>&1 || true
done

echo "macOS preferences configured successfully."

# Prompt for reboot
read -p "Would you like to reboot your Mac now? (y/n): " choice
case "$choice" in
    y|Y|yes|Yes)
        echo "Rebooting..."
        sudo reboot
        ;;
    *)
        echo "Skipping reboot. Some changes may require a restart to take effect."
        ;;
esac

exit 0
