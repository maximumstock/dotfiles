#!/bin/bash

echo -e "\n\nConfiguring Apache"
echo "=============================="

######################################################
# Apache setup
######################################################

DOTFILES=$HOME/.dotfiles

# for now we want to keep Apache
# let it listen on 8080 though
sudo sed -i '' -e "s/Listen.*/Listen 8080/g" /etc/apache2/httpd.conf

# link our user directory alias config into the users folder
sudo mkdir -p /etc/apache2/users
sudo sed -i '' -e "s/user/$USER/g" $DOTFILES/apache2/user.conf
sudo ln -F -s $DOTFILES/apache2/user.conf /etc/apache2/users/$USER.conf

# actually let apache search for user configs by uncommenting the include statement
sudo sed -i '' -e "s/#Include/Include/g" /etc/apache2/extra/httpd-userdir.conf

sudo apachectl restart
