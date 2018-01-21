#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi

echo "Setting up Homebrew..."

echo "\tChecking for Homewbrew updates..."
brew update >> /tmp/homebrew-install.log

echo "\tInstalling Homebrew upgrades..."
brew upgrade >> /tmp/homebrew-install.log

# Install the Homebrew packages I use on a day-to-day basis.
echo "\tInstalling Homebrew packages..."
if test ! $(which yarn);
  then brew install yarn >> /tmp/homebrew-install.log; fi
if test ! $(which tree);
  then brew install tree >> /tmp/homebrew-install.log; fi
if test ! $(which fuck);
  then brew install thefuck >> /tmp/homebrew-install.log; fi

# Tap into the Homebrew caskroom
brew tap caskroom/cask

# Install Homebrew packages from the caskrooms
# This is mostly applications for design and general uses
# Todo: list all applications
# Todo: check if an application is installed firstsssss
echo "\tInstalling Homebrew casks..."
#brew cask install\
  #origami-studio\
  #framer\
  #sketch\
  #spotify\

exit 0
