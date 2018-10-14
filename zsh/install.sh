#!/bin/sh
# Last Updated: 2018-10-13
# Description:

LOG_FILE="hyper-terminal-install.log"

# Install Oh My Zsh
# https://github.com/robbyrussell/oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Copy settings for VS Code
log "Installing Hyper Terminal settings..." $LOG_FILE
cp -P "./zshrc" "$HOME/.zshrc"
