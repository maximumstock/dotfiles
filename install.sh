#!/bin/bash

echo "Installing dotfiles"

echo "Initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "Running on OSX"

    echo "Brewing all the things"
    source install/brew.sh

    echo "Updating OSX settings"
    source install/osx.sh

    echo "Installing node (from nvm)"
    source install/nvm.sh
fi

echo "Configuring zsh as default shell"
sudo chsh -s $(which zsh) $(whoami)

echo "Done."
