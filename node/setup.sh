#!/bin/sh
# Last Updated: 2018-01-21
# Description: Installs global npm packages

LOG_FILE="node-setup.log"

log "Installing commonly used npm packages..." $LOG_FILE

# Install Create React Native App
ANSWER=$(ask_question "Create React Native App")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which create-react-native-app)
  then
    log "Installing Create React Native App..." $LOG_FILE
    npm install -g create-react-native-app >> ${PWD}/tmp/$LOG_FILE
  else
    log "Create React Native App is already installed." $LOG_FILE
  fi
fi

# Install Create React App
ANSWER=$(ask_question "Create React App")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which create-react-app)
  then
    log "Installing Create React App..." $LOG_FILE
    npm install -g create-react-app >> ${PWD}/tmp/$LOG_FILE
  else
    log "Create React App is already installed." $LOG_FILE
  fi
fi

# Install Gatsby
ANSWER=$(ask_question "Gatsby")

if [ $ANSWER -eq 1 ]; then
  if test ! $(which gatsby)
  then
    install_log "Gatsby" $LOG_FILE
    npm install -g gatsby-cli >> ${PWD}/tmp/$LOG_FILE
  else
    already_install_log "Gatsby" $LOG_FILE
  fi
fi

exit 0
