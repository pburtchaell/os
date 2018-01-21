#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs Homebrew.

sh brew/install.sh
sh node/install.sh
sh node/setup.sh
sh ruby/setup.sh
sh macos/setup.sh

exit 0
