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

# Source fedora 23 : https://opsech.io/posts/2016/Apr/06/sharing-files-with-kde-and-samba.html

echo
if pacman -Qi samba &>/dev/null; then
	tput setaf 2
	echo "######################################################################################################"
	echo "################# Samba is installed"
	echo "######################################################################################################"
	tput sgr0
else
	tput setaf 9
	echo "######################################################################################################"
	echo "################# First use our script to install Samba and Network Discovery"
	echo "######################################################################################################"
	tput sgr0
	exit 1
fi

FILE=/etc/samba/smb.conf

if test -f "${FILE}"; then
	echo
	tput setaf 2
	echo "~> /etc/samba/smb.conf has been found"
	tput sgr0
else
	tput setaf 9
	echo "######################################################################################################"
	echo "################# We did not find /etc/samba/smb.conf"
	echo "################# First use our script to install Samba and Network Discovery"
	echo "######################################################################################################"
	tput sgr0
	exit 1
fi

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Installing file sharing plugins..."
echo "######################################################################################################"
echo
tput sgr0

# Checking if filemanager is installed then install extra packages
if pacman -Qi caja &>/dev/null; then
	sudo pacman -S --noconfirm --needed caja-share
fi

if pacman -Qi dolphin &>/dev/null; then
	sudo pacman -S --noconfirm --needed kdenetwork-filesharing
fi

if pacman -Qi nautilus &>/dev/null; then
	sudo pacman -S --noconfirm --needed nautilus-share
fi

if pacman -Qi nemo &>/dev/null; then
	sudo pacman -S --noconfirm --needed nemo-share
fi

if pacman -Qi thunar &>/dev/null; then
	echo "Select what package you would like to install:"
	echo "0.  Do nothing"
	echo "1.  Default thunar-shares-plugin"
	echo "2.  Default thunar-shares-plugin-git"
	echo "Type the number..."

	read -r CHOICE

	case ${CHOICE} in

	0)
		echo
		tput setaf 13
		echo "######################################################################################################"
		echo "################# We did nothing as per your request"
		echo "######################################################################################################"
		tput sgr0
		;;
	1)
		sudo pacman -S --noconfirm --needed thunar-shares-plugin
		;;
	2)
		sudo pacman -S --noconfirm --needed thunar-shares-plugin-git
		;;
	*)
		tput setaf 9
		echo "######################################################################################################"
		echo "################# Choose the correct number"
		echo "################# Nothing installed - install manually"
		echo "######################################################################################################"
		tput sgr0
		;;
	esac
fi

echo
tput setaf 3
echo "######################################################################################################"
echo "################# usershares configuration"
echo "######################################################################################################"
echo
tput sgr0

file="/etc/samba/smb.conf"

sudo sed -i '/^\[global\]/a \
\
usershare path = /var/lib/samba/usershares \
usershare max shares = 100 \
usershare allow guests = yes \
usershare owner only = yes' "${file}"

[[ -d /var/lib/samba/usershares ]] || sudo mkdir -p /var/lib/samba/usershares
sudo groupadd -r sambashare
sudo gpasswd -a "${USER}" sambashare
sudo chown root:sambashare /var/lib/samba/usershares
sudo chmod 1770 /var/lib/samba/usershares

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Now reboot before sharing folders!"
echo "######################################################################################################"
tput sgr0
echo
