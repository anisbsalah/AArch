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
echo "################# This script will install plymouth and themes"
echo "######################################################################################################"
tput sgr0
echo

sudo pacman -S --noconfirm --needed plymouth

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Changing the needed files"
echo "######################################################################################################"
tput sgr0
echo

FIND="base udev autodetect"
REPLACE="base udev plymouth autodetect"
sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/mkinitcpio.conf

FIND='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet'
REPLACE='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash vt.global_cursor_default=0'
sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/default/grub

sudo plymouth-set-default-theme -R spinner
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo
tput setaf 9
echo "######################################################################################################"
echo "################# You have to reboot"
echo "######################################################################################################"
tput sgr0
echo
