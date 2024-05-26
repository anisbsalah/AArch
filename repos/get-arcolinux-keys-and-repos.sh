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
tput setaf 4
echo "######################################################################################################"
echo "> Getting the keys and mirrors for ArcoLinux"
echo "######################################################################################################"
tput sgr0
echo

sudo pacman -Sy --noconfirm --needed wget jq

arco_repo_db=$(wget -qO- https://api.github.com/repos/arcolinux/arcolinux_repo/contents/x86_64)

echo
tput setaf 3
echo "[*] Getting the ArcoLinux keys from the ArcoLinux repo..."
tput sgr0
echo

sudo wget "$(echo "${arco_repo_db}" | jq -r '[.[] | select(.name | contains("arcolinux-keyring")) | .name] | .[0] | sub("arcolinux-keyring-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-")')" -O /tmp/arcolinux-keyring-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-git-any.pkg.tar.zst

######################################################################################################################

echo
tput setaf 3
echo "[*] Getting the latest ArcoLinux mirrors file..."
tput sgr0
echo

sudo wget "$(echo "${arco_repo_db}" | jq -r '[.[] | select(.name | contains("arcolinux-mirrorlist-git-")) | .name] | .[0] | sub("arcolinux-mirrorlist-git-"; "https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-")')" -O /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-any.pkg.tar.zst

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
