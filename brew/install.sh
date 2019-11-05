#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs Homebrew.

LOG_FILE="homebrew-install.log"

# Check for Homebrew
if hash brew 2>/dev/null; then 
  echo "✅ Homebrew is installed."
  
  log "⬆️ Checking Homebrew for updates..." $LOG_FILE
  brew update >> ${PWD}/tmp/homebrew-install.log

  log "⬆️ Checking Homebrew for upgrades..." $LOG_FILE
  brew upgrade >> ${PWD}/tmp/homebrew-install.log
else
  log "🔄 Installing Homebrew..." $LOG_FILE
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" $LOG_FILE

  log "⬆️ Checking Homebrew for updates..." $LOG_FILE
  brew update >> ${PWD}/tmp/homebrew-install.log

  log "⬆️ Checking Homebrew for upgrades..." $LOG_FILE
  brew upgrade >> ${PWD}/tmp/homebrew-install.log
fi

# Install the Homebrew packages I use on a day-to-day basis.
if hash yarn 2>/dev/null; then
  echo "✅ Yarn is installed."
else
  log "🔄 Installing Yarn..." $LOG_FILE
  brew install yarn >> ${PWD}/tmp/$LOG_FILE
fi

exit 0
