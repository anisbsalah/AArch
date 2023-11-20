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
tput setaf 3
echo "######################################################################################################"
echo "################# Installing poly-dark grub theme..."
echo "######################################################################################################"
tput sgr0
echo

grep "GRUB_THEME=" /etc/default/grub >/dev/null 2>&1 && sudo sed -i '/GRUB_THEME=/d' /etc/default/grub
grep "GRUB_BACKGROUND=" /etc/default/grub >/dev/null 2>&1 && sudo sed -i '/GRUB_BACKGROUND=/d' /etc/default/grub

sudo pacman -S --needed --noconfirm wget
wget -P /tmp https://github.com/anisbsalah/poly-dark/raw/master/install.sh
bash /tmp/install.sh

echo
tput setaf 2
echo "######################################################################################################"
echo "################# poly-dark grub theme has been installed"
echo "######################################################################################################"
tput sgr0
echo
