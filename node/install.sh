#!/bin/sh
# Last Updated: 2018-01-20
# Description: Installs the stable version of Node.

# Node
if test ! $(which nvm)
then
  echo "Installing a stable version of Node..."

  # Load nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Install the stable version.
  nvm install stable > /dev/null 2>&1

  # Use the stable version by default.
  nvm alias default stable >> /tmp/node-install.log
fi

exit 0
