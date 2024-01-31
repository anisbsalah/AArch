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

if grep -q arcolinux_repo /etc/pacman.conf; then

	echo
	tput setaf 2
	echo "######################################################################################################"
	echo "ArcoLinux repos are already in /etc/pacman.conf"
	echo "######################################################################################################"
	tput sgr0
	echo

	exit 0

else

	echo
	tput setaf 4
	echo "######################################################################################################"
	echo "> Getting the keys and mirrors for ArcoLinux"
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo pacman -Sy --noconfirm --needed wget

	echo
	tput setaf 3
	echo "[*] Getting the ArcoLinux keys from the ArcoLinux repo..."
	tput sgr0
	echo

	sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst -O /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst
	sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst

	######################################################################################################################

	echo
	tput setaf 3
	echo "[*] Getting the latest ArcoLinux mirrors file..."
	tput sgr0
	echo

	sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst -O /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst
	sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst
	echo '

#[arcolinux_repo_testing]
#SigLevel = PackageRequired DatabaseNever
#Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_3party]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_xlarge]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "Updating database..."
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo pacman -Sy

	echo
	tput setaf 2
	echo "######################################################################################################"
	echo "ArcoLinux mirrors and keys added successfully"
	echo "######################################################################################################"
	echo
	tput sgr0

fi
