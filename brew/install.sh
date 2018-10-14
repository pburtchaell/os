#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs Homebrew.

LOG_FILE="homebrew-install.log"

log_title "Homebrew"

# Check for Homebrew
if test ! $(which brew)
then
  log "Installing Homebrew..." $LOG_FILE
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >> ${PWD}/tmp/homebrew-install.log
fi

log "Setting up Homebrew..." $LOG_FILE

log "Checking for Homewbrew updates..." $LOG_FILE
brew update >> ${PWD}/tmp/homebrew-install.log

log "Updating Homebrew..." $LOG_FILE
brew upgrade >> ${PWD}/tmp/homebrew-install.log

# Install the Homebrew packages I use on a day-to-day basis.
log "Installing Homebrew packages..." $LOG_FILE
if test ! $(which yarn);
  then brew install yarn >> ${PWD}/tmp/$LOG_FILE; fi
if test ! $(which tree);
  then brew install tree >> ${PWD}/tmp/$LOG_FILE; fi
if test ! $(which fuck);
  then brew install thefuck >> ${PWD}/tmp/$LOG_FILE; fi
if test ! $(which pg_ctl);
  then brew install postgres >> ${PWD}/tmp/$LOG_FILE; fi

# Tap into the Homebrew caskroom
log "Tapping into Homebrew casks..." $LOG_FILE
brew tap caskroom/cask >> ${PWD}/tmp/$LOG_FILE

log_title "macOS Appplications"

declare -a apps_to_install_app_name=(
  "Hyper Terminal"
  "Origami Studio"
  "Github"
  "Sketch"
  "Spotify"
  "Chrome"
  "Firefox"
  "Slack"
  "Dropbox"
  "Paw"
  "Steam"
  "Discord"
  "Dashlane"
  "VS Code"
  "Bartender"
  "Flux"
  "Rescue Time"
)

declare -a apps_to_install_package_name=(
  "hyper"
  "origami-studio"
  "github"
  "sketch"
  "spotify"
  "chrome"
  "firefox"
  "slack"
  "dropbox"
  "paw"
  "steam"
  "discord"
  "dashlane"
  "visual-studio-code"
  "bartender"
  "flux"
  "rescuetime"
)

# Install Homebrew packages from the caskrooms
# This is mostly applications for design and general uses
for i in "${!apps_to_install_package_name[@]}"; do
  package_name="${apps_to_install_package_name[i]}"
  app_name="${apps_to_install_app_name[i]}"

  while [ $(ask_question $app_name) -eq 1 ]; do
    install_log $app_name $LOG_FILE
    brew cask install $package_name
  done
done

exit 0
