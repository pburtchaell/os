#!/bin/sh
# Last Updated: 2019-10-27
# Description: Clones the git repo and checks if the script should run

if [ ! -d "$HOME/.os/.osrc" ]; then
    echo "Cloning github.com/pburtchaell/os.gi git repository..."
    git clone --depth=1 https://github.com/pburtchaell/os.git "$HOME/.os"
    cd "$HOME/.os"
    sh ./setup.sh
else
    echo "It looks like everything is already installed and configured."
fi
