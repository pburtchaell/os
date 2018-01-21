#!/bin/sh
# Last Updated: 2018-01-21
# Description: Installs nvm and Node.

LOG_FILE="node-install.log"

# Function: install_node
# Description: Installs the stable version of Node.
install_node() {
  echo "Installing a stable version of Node..."

  # Install the stable version.
  nvm install stable > /dev/null 2>&1

  # Use the stable version by default.
  nvm alias default stable >> ${PWD}/tmp/node-install.log
}

# Function: install_all
# Description: Install both nvm and Mode.
install_all() {
  if [ test ! $(which nvm) ]
  then
    echo "nvm is already installed."

    install_node
  else
    echo "Installing nvm..."
    "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.s)" >> ${PWD}/tmp/nvm-install.log

    install_node
  fi
}

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Only install nvm and Node if the user wants it.
ANSWER=$(ask_question "nvm and Node")

if [ $ANSWER -eq 1 ]; then
  install_all
fi

exit 0
