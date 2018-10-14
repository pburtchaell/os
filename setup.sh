#!/bin/sh
# Last Updated: 2018-01-20
# Description: Runs the setup for everything

# Make temporary folder for logs
if [ -d ${PWD}/tmp ]; then rm -rf ${PWD}/tmp; fi
mkdir ${PWD}/tmp

# Make folder for git repositorie
REPOSITORIES=${HOME}/Repositories
if [ ! -d ${REPOSITORIES} ]; then mkdir ${REPOSITORIES}; fi

# Function: ask_question
# Description: Ask a yes/no question and return boolean value based off answer.
ask_question() {
  read -p "Would you like to install $1 (y/n): " ANSWER

  case $ANSWER in
    y | Y | Yes | yes )
      status=1 # return true
      break
      ;;
    n | N | No | no)
      status=0 # return false
      break
      ;;
    * )
      echo "Invalid answer. Please enter either \"y/yes\" or \"n/no\""
      ask_question "$1" ANSWER
      break
      ;;
  esac

  echo $status
  return
}

# Function: install_log
# Description: Log an install message.
install_log() {
  echo "Installing $1..." | tee -a ${PWD}/tmp/$2

  return
}

# Function: already_install_log
# Description: Log an already installed message.
already_install_log() {
  echo "$1 is already installed." | tee -a ${PWD}/tmp/$2
}

# Function: log
# Description: Log a message to the console and to a file
log() {
  echo $1 | tee -a ${PWD}/tmp/$2
}

# Export functions
export -f ask_question
export -f install_log
export -f already_install_log
export -f log

# Install development and design tools
sh brew/install.sh
#sh node/install.sh
sh node/setup.sh
#sh ruby/install.sh
sh ruby/setup.sh

# Set macOS defaults
log "Installing macOS defaults..." "macos-setup.log"
MACOS_ANSWER=$(ask_question "macOS defaults")

if [ $MACOS_ANSWER -eq 1 ]; then
  sh macos/setup.sh
fi

exit 0
