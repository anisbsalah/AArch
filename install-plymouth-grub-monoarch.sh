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

# https://wiki.archlinux.org/title/Plymouth

if [[ -d /boot/loader/entries ]]; then
	echo "You seem to be on a systemd-boot enabled system"
	echo "Run the script for systemd-boot"
	exit 1
fi

echo "######################################################################################################"
echo "################# This script will install plymouth and themes on a systemd-boot system"
echo "######################################################################################################"

sudo pacman -S --noconfirm --needed plymouth
sudo pacman -S --noconfirm --needed plymouth-theme-monoarch

echo "######################################################################################################"
echo "################# Changing the needed files"
echo "######################################################################################################"

FIND="base udev autodetect"
REPLACE="base udev plymouth autodetect"
sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/mkinitcpio.conf

FIND='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet'
REPLACE='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash vt.global_cursor_default=0'
sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/default/grub

sudo plymouth-set-default-theme -R monoarch

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "######################################################################################################"
echo "################# You have to reboot"
echo "######################################################################################################"
