#!/bin/sh
# Last Updated: 2019-12-28
# Description: Installs Zsh and Oh My Zsh
# zsh FYI: https://www.zsh.org/
# ohmyzsh FYI: https://ohmyz.sh/

install_zsh() {
  # See more: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
  echo "ℹ️ macOS ships with Zsh installed, but it's outdated. This will reinstall with Homebrew."
  echo "🔄 Installing Zsh..."
  brew install zsh
}

install_oh_my_zsh() {
  echo "🔄 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

config_shell() {
  echo "🔄 Setting Zsh as your default shell..."
  echo "ℹ️ You might need to enter your password."
  chsh -s /bin/zsh
}

exit 0
