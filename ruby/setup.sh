#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs commonly used Ruby gems.

echo "Installing commonly used Ruby gems..."

# Install Bundler
if test ! $(which bundle)
then
  echo "\tInstalling Bundler..."
  gem install bundler >> /tmp/ruby-setup.log
else
  echo "\tBundler is already installed."
fi

# Install Ruby on Rails
if test ! $(which rails)
then
  echo "\tInstalling Ruby on Rails..."
  gem install rails >> /tmp/ruby-setup.log
else
  echo "\tRuby on Rails is already installed."
fi

# Install Foreman
if test ! $(which foreman)
then
  echo "\tInstalling Foreman..."
  gem install foreman >> /tmp/ruby-setup.log
else
  echo "\tForeman is already installed."
fi

exit 0
