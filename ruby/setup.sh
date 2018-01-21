#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs commonly used Ruby gems.

LOG_FILE="ruby-setup.log"

log "Installing commonly used Ruby gems..." $LOG_FILE

# Install Bundler
ANSWER=$(ask_question "Bundler")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which bundle)
  then
    log "Installing Bundler..." $LOG_FILE
    gem install bundler >> ${PWD}/tmp/$LOG_FILE
  else
    log "Bundler is already installed." $LOG_FILE
  fi
fi

# Install Ruby on Rails
ANSWER=$(ask_question "Ruby on Rails")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which rails)
  then
    log "Installing Ruby on Rails..." $LOG_FILE
    gem install rails >> ${PWD}/tmp/$LOG_FILE
  else
    log "Ruby on Rails is already installed." $LOG_FILE
  fi
fi

# Install Foreman
ANSWER=$(ask_question "Foreman")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which foreman)
  then
    log "Installing Foreman..." $LOG_FILE
    gem install foreman >> ${PWD}/tmp/$LOG_FILE
  else
    log "Foreman is already installed." $LOG_FILE
  fi
fi

exit 0
