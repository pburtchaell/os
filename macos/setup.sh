#!/bin/sh
# Last Updated: 2018-10-12
# Description: Configures defaults (settings) for macOS

# Ask for the administrator password
sudo -v

# Update existing `sudo` time stamp until the script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Set computer name
# Todo: use functions to allow people to input names
#sudo scutil --set ComputerName "Patrick's MacBook Pro"
#sudo scutil --set HostName "pburtchaell-mbp"
#sudo scutil --set LocalHostName "pburtchaell-mbp"

###############################################################################
# Safari
###############################################################################

# Show the bookmark bar
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Set up Safari for web development
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write -g WebKitDeveloperExtras -bool true

# Do not send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Set the home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

###############################################################################
#  Terminal
###############################################################################

# Only use UTF-8 in Terminal
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Print
###############################################################################

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Google Chrome
###############################################################################

# Disable Swipe controls for Google Chrome
defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE

###############################################################################
# App Store
###############################################################################

# Turn on automatic update checks
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Turn on automatic updates
defaults write com.apple.commerce AutoUpdate -bool true

# Check for software updates daily, not weekly
defaults write com.assple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Mail
###############################################################################

# Disable inline attachments in Mail, showing just the icons
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

###############################################################################
# Activity Monitor
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Input - Trackpad, mouse, keyboard, bluetooth, etc.
###############################################################################

# Map bottom right corner of Apple trackpad to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write com.apple.trackpad.enableSecondaryClick -bool true

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Enable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool true

# Set language and text formats (USD and imperial units)
defaults write -g AppleLanguages -array "en" "nl"
defaults write -g AppleLocale -string "en_US@currency=USD"
defaults write -g AppleMeasurementUnits -string "Inches"
defaults write -g AppleMetricUnits -bool false

###############################################################################
# Screen
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to a screenshots folder
mkdir "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

# Save screenshots as png files
defaults write com.apple.screencapture type -string "png"

# Disable the drop shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel rendering on non-Apple LCD monitors
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder
###############################################################################

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Use AirDrop over every interface
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Set the Finder preferences for showing a few different volumes on the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show hidden files and file extensions by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning when opening applications from the internet
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Allow text selection in Quick Preview
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning before emptying the trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable auto correct (spell check)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable the "Resume" feature
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable window animations for better performance
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# Disable icons on the desktop
defaults write com.apple.finder CreateDesktop false

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

###############################################################################
# TextEdit
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Dock
###############################################################################

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Show the Dock instantly when show/hide is enabled
defaults write com.apple.dock expose-animation-duration -int 0;

# Minimize applications to the Dock more quickly by using the scale effect
efaults write com.apple.dock mineffect -string scale

###############################################################################
# Kill applications
###############################################################################

for app in "Activity Monitor" \
  "Calendar" \
  "Contacts" \
  "cfprefsd" \
  "Dock" \
  "Finder" \
  "Google Chrome Canary" \
  "Google Chrome" \
  "Mail" \
  "Messages" \
  "Safari" \
  "SystemUIServer" \
  "Calendar"; do
  killall "${app}" &> /dev/null 2>&1

  # > /dev/null 2>&1
  # This line prevents standard and error output
done

echo "macoS defaults are set, but some changes require a reboot."

# See if you want to reboot.
function reboot() {
  read -p "Do you want to reboot your machine now? (y/n): " choice

  case "$choice" in
    y | Yes | yes ) echo "Yes"; exit;; # If y | yes, reboot
    n | N | No | no) echo "No"; exit;; # If n | no, exit
    * ) echo "\tInvalid answer. Enter \"y/yes\" or \"n/no\"" && return;;
  esac
}

# Call on the function
if [[ "Yes" == $(reboot) ]]
then
    echo "Rebooting."
    sudo reboot
    exit 0
else
    exit 1
fi
