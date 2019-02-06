#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

# misc
brew install ack
brew install tree
brew install wget
brew install logstalgia
brew install htop
brew install goaccess
brew install reattach-to-user-namespace # needed for tmux
brew install git
brew install tmux
brew install zsh
brew install z
brew install neovim/neovim/neovim
brew install --with-cocoa --srgb emacs
brew linkapps emacs
brew install pyenv
brew install pyenv-virtualenv

# dev env
brew install nvm
brew install elixir
# brew cask install java
# brew install neo4j

# Latex (MacTex)
# brew cask install mactex

# exit 0
