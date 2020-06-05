#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

brew install tree
brew install wget
brew install htop
brew install git
brew install tmux
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.dotfiles/tmux/plugins/tmux-resurrect
brew install reattach-to-user-namespace # needed for tmux
brew install zsh
brew install z
brew install neovim/neovim/neovim
brew install emacs-plus --HEAD --without-spacemacs-icon --with-jansson --without-multicolor-fonts
brew install Schniz/tap/fnm
brew install pyenv
brew install pyenv-virtualenv
brew install fzf && $(brew --prefix)/opt/fzf/install
brew install ripgrep

