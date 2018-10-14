#!/bin/sh
# Last Updated: 2018-10-13
# Description:

LOG_FILE="vs-code-install.log"

# Copy settings for VS Code
# log "Installing VS Code settings..." $LOG_FILE
cp -P "./settings.json" "$HOME/Library/Application Support/Code/User/"

# Copy snippets for VS Code
# log "Installing VS Code snippets..." $LOG_FILE
cp -P "./global.code-snippets" "$HOME/Library/Application Support/Code/Users/snippets"

# Install extensions for VS Code
# https://code.visualstudio.com/docs/editor/extension-gallery#_command-line-extension-management
# log "Installing VS Code extensions..." $LOG_FILE

declare -a extensions=(
    # Good list of extenstions
    # More here: https://github.com/viatsko/awesome-vscode
    "akamud.vscode-theme-onedark"
    "dbaeumer.vscode-eslint"
    "eg2.vscode-npm-script"
    "ms-vsliveshare.vsliveshare"
    "wallabyjs.quokka-vscode"
    "formulahendry.code-runner"
    "vsmobile.vscode-react-native"
    "msjsdiag.debugger-for-chrome"
    # Add autocomplete for shell scripts
    "truman.autocomplate-shell"
    # Add support for dotenv syntax
    "mikestead.dotenv"
    # Show the current spotify song in the bottom bar
    "shyykoserhiy.vscode-spotify"
)

for i in "${extensions[@]}"
do
   code --install-extension  "$i"
done
