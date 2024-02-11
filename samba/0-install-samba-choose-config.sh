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
CURRENT_DIR="$(pwd)"
##################################################################################################################

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Installation of Samba software..."
echo "######################################################################################################"
tput sgr0
echo

sudo pacman -S --noconfirm --needed samba

echo

[[ ! -f /etc/samba/smb.conf ]] || sudo cp -anv /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo cp "${CURRENT_DIR}/config/"* /etc/samba/
### Get the arcolinux samba config file from the web:
sudo wget "https://raw.githubusercontent.com/arcolinux/arcolinux-system-config/master/etc/samba/smb.conf.arcolinux" -O /etc/samba/smb.conf.arcolinux

sudo cp -f "${CURRENT_DIR}/config/smb.conf.easy" /etc/samba/smb.conf

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Create a password for the current user to be able to access Samba server"
echo "######################################################################################################"
echo
tput sgr0

#read -erp "What is your login? It will be used to add this user to smb : " choice
#sudo smbpasswd -a "${choice}"

sudo smbpasswd -a "${USER}"

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Samba configuration"
echo "######################################################################################################"
tput sgr0
echo
echo "Choose your Samba configuration (enter a number):"
echo "1) Easy"
echo "2) Usershares"
echo
read -erp "#? " CHOICE
echo

case ${CHOICE} in

1)
	sudo cp -fv /etc/samba/smb.conf.easy /etc/samba/smb.conf
	[[ -d "${HOME}/SHARED" ]] || mkdir -p "${HOME}/SHARED"

	;;
2)
	sudo cp -fv /etc/samba/smb.conf.usershares /etc/samba/smb.conf
	[[ -d /var/lib/samba/usershares ]] || sudo mkdir -p /var/lib/samba/usershares

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Create a user group and add the user to the sambashare group"
	echo "######################################################################################################"
	echo
	tput sgr0

	sudo groupadd -r sambashare
	sudo gpasswd sambashare -a "${USER}"
	sudo chown root:sambashare /var/lib/samba/usershares
	sudo chmod 1770 /var/lib/samba/usershares

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing file sharing plugins..."
	echo "######################################################################################################"
	echo
	tput sgr0

	if pacman -Qi nemo &>/dev/null; then
		sudo pacman -S --noconfirm --needed nemo-share
	fi

	if pacman -Qi nautilus &>/dev/null; then
		sudo pacman -S --noconfirm --needed nautilus-share
	fi

	if pacman -Qi caja &>/dev/null; then
		sudo pacman -S --noconfirm --needed caja-share
	fi

	if pacman -Qi dolphin &>/dev/null; then
		sudo pacman -S --noconfirm --needed kdenetwork-filesharing
	fi

	if pacman -Qi thunar &>/dev/null; then
		sudo pacman -S --noconfirm --needed thunar-shares-plugin
	fi

	;;
*)
	echo
	tput setaf 9
	echo "######################################################################################################"
	echo "################# Choose the correct number"
	echo "################# No configuration set"
	echo "######################################################################################################"
	echo
	tput sgr0
	;;
esac

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Enabling services"
echo "######################################################################################################"
echo
tput sgr0

sudo systemctl enable --now smb.service
sudo systemctl enable --now nmb.service

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Network Discovery"
echo "######################################################################################################"
echo
tput sgr0

sudo pacman -S --noconfirm --needed avahi
sudo systemctl enable --now avahi-daemon.service

#shares on a linux
sudo pacman -S --noconfirm --needed gvfs-smb

#shares on a mac
sudo pacman -S --noconfirm --needed nss-mdns

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Getting latest /etc/nsswitch.conf from ArcoLinux"
echo "######################################################################################################"
echo
tput sgr0

sudo cp -anv /etc/nsswitch.conf /etc/nsswitch.conf.bak
sudo wget https://raw.githubusercontent.com/arcolinux/arcolinuxl-iso/master/archiso/airootfs/etc/nsswitch.conf -O /etc/nsswitch.conf || sudo cp -v "${CURRENT_DIR}/samba/nsswitch/abs/nsswitch.conf" /etc/nsswitch.conf

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Configuring the firewall service"
echo "######################################################################################################"
echo
tput sgr0

if pacman -Qi firewalld &>/dev/null; then
	sudo firewall-cmd --set-default-zone=home
	sudo firewall-cmd --permanent --add-service={samba,samba-client,samba-dc,ssh,ws-discovery,ws-discovery-client,ws-discovery-tcp,ws-discovery-udp,ipp,ipp-client} --zone=home

elif pacman -Qi ufw &>/dev/null; then
	sudo ufw allow CIFS

else
	tput setaf 11
	echo "########################################"
	echo " No firewall installed"
	echo "########################################"
	echo
	tput sgr0
fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Samba has been installed"
echo "################# Now reboot before sharing folders!"
echo "######################################################################################################"
tput sgr0
echo
