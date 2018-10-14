#!/bin/sh
# Last Updated: 2018-01-20
# Description: Runs the setup for everything

# Setup text styles
red_text=`tput setaf 1 && tput bold`
grn_text=`tput setaf 2 && tput bold`
rst_text=`tput sgr0 && tput rmso`

# Make temporary folder for logs
if [ -d ${PWD}/tmp ]; then rm -rf ${PWD}/tmp; fi
mkdir ${PWD}/tmp

# Make folder for git repositorie
REPOSITORIES=${HOME}/Repositories
if [ ! -d ${REPOSITORIES} ]; then mkdir ${REPOSITORIES}; fi

# Function: ask_question
# Description: Ask a yes/no question and return boolean value based off answer.
ask_question() {
  read -p "Would you like to install $(tput setaf 2 && tput bold)$1$(tput sgr0 && tput rmso)? You can say y/n: " ANSWER

  case $ANSWER in
    y | Y | Yes | yes )
      echo 1
      status=1 # return true
      break
      ;;
    n | N | No | no)
      echo 0
      status=0 # return false
      break
      ;;
    * )
      echo "Sorry, I don't understand. Please enter either \"y/yes\" or \"n/no\"."
      ask_question "$1" ANSWER
      break
      ;;
  esac

  echo $status
  return $status
}

# Function: install_log
# Description: Log an install message.
install_log() {
  echo "Installing $(tput setaf 2 && tput bold)$1$(tput sgr0 && tput rmso)..." | tee -a ${PWD}/tmp/$2

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

log_title() {
  declare -a log_title_expressions=(
    "Alrighty."
    "Next up."
    "Okay!"
    "Onward~~!"
    "You're the best."
  )

  get_random_log_title_expression() {
    echo ${log_title_expressions[$RANDOM % ${#log_title_expressions[@]} ]}
  }

  echo ""
  echo "~-~-~-~-~-~ ! ^_^ ! ~-~-~-~-~-~"
  echo "$(get_random_log_title_expression) We're going to do the $(tput setaf 2 && tput bold)$1$(tput sgr0 && tput rmso) part of setup now."
  echo "~-~-~-~-~-~ ! ._. ! ~-~-~-~-~-~"
  echo ""
  sleep 2
}

# Export functions
export -f ask_question
export -f install_log
export -f already_install_log
export -f log
export -f log_title

echo "^_^"
echo "Hello!"
sleep 3
echo "I suppose you need my help setting up this machine."
echo "I'm here to guide you through the process."
sleep 2

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
