#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs global npm packages

echo "Installing commonly used npm packages..."

# Install Create React Native App
if test ! $(which create-react-native-app)
then
  echo "\tInstalling Create React Native App..."
  npm install -g create-react-native-app
else
  echo "\tCreate React Native App is already installed."
fi

# Install Create React App
if test ! $(which create-react-app)
then
  echo "\tInstalling Create React App..."
  npm install -g create-react-app
else
  echo "\tCreate React App is already installed."
fi

# Install Gatsby
if test ! $(which gatsby)
then
  echo "\tInstalling Gatsby..."
  npm install -g gatsby-cli
else
  echo "\tGatsby is already installed."
fi

exit 0
