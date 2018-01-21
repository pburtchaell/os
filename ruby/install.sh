#!/bin/sh
# Last Updated: 2018-01-21
# Description: Installs nvm and Node.

LOG_FILE="ruby-install.log"

# Function: install_ruby
# Description: Installs the stable version of Node.
install_ruby() {
  log "Installing a stable version of Ruby..." $LOG_FILE

  "$(rvm install ruby --latest)" >> ${PWD}/tmp/$LOG_FILE
}

# Function: install_all
# Description: Install both rvm and Ruby.
install_all() {
  if test ! $(which rvm)
  then
    log "rvm is already installed." $LOG_FILE

    install_ruby
  else
    log "Installing rvm..." $LOG_FILE

    # Following instructions from here: https://rvm.io/rvm/install
    # Install mpapis public key
    "$(gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB)" >> /tmp/rvm-install.log

    # Install rvm
    "$(curl -sSL https://get.rvm.io)" >> ${PWD}/tmp/$LOG_FILE

    # Install Ruby
    install_ruby
  fi
}

# Only install rvm and Ruby if the user would like to.
ANSWER=$(ask_question "rvm and Ruby")

if [ $ANSWER -eq 1 ]; then
  install_all
fi

exit 0
