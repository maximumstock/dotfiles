#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing homebrew packages..."

brew install tree
brew install wget
brew install htop
brew install git
brew install tmux
brew install reattach-to-user-namespace # needed for tmux
brew install zsh
brew install z
brew install neovim
brew install fnm && fnm install v20.1.0
brew install fzf && $(brew --prefix)/opt/fzf/install
brew install ripgrep
brew install --cask michaelvillar-timer
brew install starship
brew tap homebrew/cask-fonts && brew install font-hack-nerd-font # nerdfont patched Hack
