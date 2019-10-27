#!/bin/sh
# Last Updated: 2019-10-27
# Description: Installs nvm and node

LOG_FILE="node-install.log"

install_node() {
  echo "🔄 Installing node..."
  nvm install stable > /dev/null 2>&1
  nvm alias default stable >> ${PWD}/tmp/node-install.log
}

install_nvm() {
  echo "🔄 Installing node version manager (nvm)..."
  "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.s)" >> ${PWD}/tmp/nvm-install.log
  
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

install_all() {
  install_nvm
  install_node
}

# Check for nvm and node
if [ -f $(which nvm) ]; then 
  echo "✅ node version manager (nvm) is installed."

  if [ -f $(which node) ]; then
    echo "✅ node is installed."
  else
    ANSWER=$(ask_question "node and node version manager (nvm)")
    if [ $ANSWER -eq 1 ]; then
      install_all
    fi
  fi
else 
  if [-f $(which node)]; then 
    echo "✅ node is installed."
  else
    ANSWER=$(ask_question "node version manager")
    if [ $ANSWER -eq 1 ]; then
      install_nvm
    fi
  fi
fi

exit 0
