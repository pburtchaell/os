#!/bin/sh
# Last Updated: 2018-01-20
# Description: Runs the setup for everything.

if [ ! -d "$HOME/.os/.osrc" ]; then
    echo "Cloning Git repository..."
    git clone --depth=1 https://github.com/pburtchaell/os.git "$HOME/.os"
    cd "$HOME/.os"
    sh ./setup.sh
else
    echo "Everything is already installed and setup."
fi
