#!/bin/sh
# Last Updated: 2019-10-27
# Description: Runs the setup for everything

# Welcome messages
echo "Hi! Let's setup your new Mac <3"

# Ask for administrator password
echo "Your password is used to configure macOS settings and to install software like Homebrew and node."
sudo -v

# Update existing `sudo` time stamp until the script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make temporary folder for logs
if [ -d ${PWD}/tmp ]; then rm -rf ${PWD}/tmp; fi
mkdir ${PWD}/tmp

# Make folder for git repositories
REPOSITORIES=${HOME}/Repositories
if [ ! -d ${REPOSITORIES} ]; then mkdir ${REPOSITORIES}; fi

# Function: ask_question
# Description: Ask a yes/no question and return boolean value based off answer.
ask_question() {
  read -p "🔼 Would you like to install $1 (y/n): " ANSWER

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
      echo "Sorry, didn't get that. Please tell me \"y/yes\" or \"n/no\""
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
  echo "🔄 Installing $1..." | tee -a ${PWD}/tmp/$2

  return
}

# Function: already_install_log
# Description: Log an already installed message.
already_install_log() {
  echo "✅ $1 is installed." | tee -a ${PWD}/tmp/$2
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

sh brew/install.sh
sh node/install.sh
sh node/setup.sh
MACOS_ANSWER=$(ask_question "macOS defaults")

if [ $MACOS_ANSWER -eq 1 ]; then
  log "🔄 Installing macOS defaults..." "macos-setup.log"
  sh macos/setup.sh
fi

exit 0
