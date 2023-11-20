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

if lsblk -f | grep btrfs >/dev/null 2>&1; then

	echo
	tput setaf 12
	echo "######################################################################################################"
	echo "################# You are using BTRFS"
	echo "######################################################################################################"
	tput sgr0

	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing Timeshift..."
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo pacman -S --needed --noconfirm timeshift timeshift-autosnap
	sudo systemctl enable --now cronie.service

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing inotify-tools..."
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo pacman -S --needed --noconfirm inotify-tools

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing grub-btrfs..."
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo pacman -S --needed --noconfirm grub-btrfs

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Enabling & starting grub-btrfsd daemon"
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo sed -i 's/ExecStart=\/usr\/bin\/grub-btrfsd --syslog \/.snapshots/ExecStart=\/usr\/bin\/grub-btrfsd --syslog --timeshift-auto/' /usr/lib/systemd/system/grub-btrfsd.service
	sudo systemctl enable --now grub-btrfsd.service

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Updating grub"
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo grub-mkconfig
	sudo /etc/grub.d/41_snapshots-btrfs
	sudo grub-mkconfig -o /boot/grub/grub.cfg

	echo
	tput setaf 2
	echo "######################################################################################################"
	echo "################# Packages have been installed"
	echo "######################################################################################################"
	tput sgr0
	echo

else

	echo
	tput setaf 9
	echo "######################################################################################################"
	echo "################# Your harddisk/ssd/nvme is not formatted as BTRFS"
	echo "################# Packages will not be installed"
	echo "######################################################################################################"
	tput sgr0
	echo

fi
