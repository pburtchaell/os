#!/bin/sh
# Last Updated: 2018-10-13
# Description:

LOG_FILE="hyper-terminal-install.log"

# Copy settings for VS Code
log "Installing Hyper Terminal settings..." $LOG_FILE
cp -P "./hyper.js" "$HOME/.hyper.js"
