#!/bin/bash

echo -e "\n\nInstalling nginx"
echo "=============================="

######################################################
# nginx setup
######################################################

DOTFILES=$HOME/.dotfiles

# run nginx when os x starts
sudo cp -R /usr/local/opt/nginx/homebrew.mxcl.nginx.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

mkdir -p /usr/local/etc/nginx/sites-enabled
mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf.orig
ln -s $DOTFILES/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

sites=$( ls $DOTFILES/nginx/sites-available)
for site in $sites ; do
    echo "linking $site"
    ln -s $DOTFILES/nginx/sites-available/$site /usr/local/etc/nginx/sites-enabled/$site
done
