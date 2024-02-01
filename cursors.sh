#!/bin/bash
#set -e
##################################################################################################################
# Author  :  anisbsalah
# Github  :  https://github.com/anisbsalah
##################################################################################################################
#
# DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
# CURRENT_DIR="$(pwd)"
##################################################################################################################

echo
tput setaf 6
echo "######################################################################################################"
echo "CURSORS"
echo "######################################################################################################"
tput sgr0

echo
tput setaf 3
echo '====================================='
echo '[*] Installing Catppuccin cursors...'
echo '====================================='
tput sgr0
echo

git clone https://github.com/anisbsalah/Catppuccin-Cursors.git /tmp/Catppuccin-Cursors
sudo cp -rf /tmp/Catppuccin-Cursors/usr/share/icons/Catppuccin-Latte-Light-Cursors /usr/share/icons/
# sudo find /usr/share/icons/default/ -name "index.theme" -exec sed -i 's/Inherits=.*/Inherits=Catppuccin-Latte-Light-Cursors/g' {} \;

echo
tput setaf 3
echo '================================'
echo '[*] Installing Qogir cursors...'
echo '================================'
tput sgr0
echo

git clone https://github.com/anisbsalah/Qogir-Cursors.git /tmp/Qogir-Cursors
sudo cp -rf /tmp/Qogir-Cursors/usr/share/icons/Qogir-Cursors /usr/share/icons/
sudo find /usr/share/icons/default/ -name "index.theme" -exec sed -i 's/Inherits=.*/Inherits=Qogir-Cursors/g' {} \;

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Cursors have been installed"
echo "######################################################################################################"
tput sgr0
echo
