#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs Homebrew.

LOG_FILE="homebrew-install.log"

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

# Install Homebrew packages from the caskrooms
# This is mostly applications for design and general uses
# Todo: list all applications
# Todo: check if an application is installed first
# log "Installing Homebrew casks..." $LOG_FILE
#brew cask install\
  #origami-studio\
  #github\
  #framer\
  #sketch\
  #spotify\
  #chrome\
  #firefox\
  #slack\
  #dropbox\

exit 0
