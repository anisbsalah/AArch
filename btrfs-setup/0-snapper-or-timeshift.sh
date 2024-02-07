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
	echo
	echo "Select the system restore utility to install:"
	echo "0) Do nothing"
	echo "1) Snapper"
	echo "2) Timeshift"
	echo
	read -erp "Enter a number (0/1/2): " CHOICE
	echo

	case ${CHOICE} in

	0)
		tput setaf 13
		echo "######################################################################################################"
		echo "################# We did nothing as per your request"
		echo "######################################################################################################"
		tput sgr0
		echo
		;;
	1)
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Snapper to be installed..." # with the default snapper layout (perfectly working)
		echo "######################################################################################################"
		tput sgr0
		echo

		if [[ -d /.snapshots ]]; then
			sudo umount /.snapshots
			sudo rm -rf /.snapshots
		fi

		# Snapper create-config automatically creates a subvolume `.snapshots` with the root subvolume @ as its parent.
		# Therefore, `@snapshots` is no more needed.
		ROOT_BTRFS_FS=$(df --output=source / | tail -n 1)
		UUID_ROOT=$(lsblk -dno UUID "${ROOT_BTRFS_FS}")
		sudo mount -t btrfs -o subvol=/ /dev/disk/by-uuid/"${UUID_ROOT}" /mnt
		sudo btrfs subvolume delete /mnt/@snapshots
		sudo umount /mnt
		sudo sed -i '/@snapshots/s/^/# /' /etc/fstab # Uncomment the line that contains `@snapshots` in fstab
		#sudo sed -i '/.*@snapshots.*/d' /etc/fstab # Delete the line that contains `@snapshots` in fstab
		sudo systemctl daemon-reload

		sudo pacman -S --needed --noconfirm btrfs-assistant # An application for managing BTRFS subvolumes and Snapper snapshots
		sudo pacman -S --needed --noconfirm grub-btrfs inotify-tools
		sudo pacman -S --needed --noconfirm snapper
		sudo pacman -S --needed --noconfirm snap-pac-git    # Pacman hooks that use snapper to create pre/post btrfs snapshots like openSUSE's YaST
		sudo pacman -S --needed --noconfirm snap-pac-grub   # Pacman hook to update GRUB entries for grub-btrfs after snap-pac made snapshots
		sudo pacman -S --needed --noconfirm snapper-support # Support package for enabling Snapper with snap-pac and grub-btrfs support
		#sudo pacman -S --needed --noconfirm snapper-tools-git # A highly opinionated Snapper GUI and CLI

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Snapper configuration for root"
		echo "######################################################################################################"
		tput sgr0
		echo

		# sudo snapper -c root create-config /

		sudo snapper -c root set-config 'ALLOW_GROUPS=wheel'
		sudo snapper -c root set-config 'SYNC_ACL=yes'
		sudo snapper -c root set-config 'NUMBER_LIMIT=10'
		sudo snapper -c root set-config 'TIMELINE_CREATE=yes'
		sudo snapper -c root set-config 'TIMELINE_LIMIT_HOURLY=5'
		sudo snapper -c root set-config 'TIMELINE_LIMIT_DAILY=7'
		sudo snapper -c root set-config 'TIMELINE_LIMIT_WEEKLY=0'
		sudo snapper -c root set-config 'TIMELINE_LIMIT_MONTHLY=0'
		sudo snapper -c root set-config 'TIMELINE_LIMIT_YEARLY=0'

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Snapper configuration for home"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo snapper -c home create-config /home

		sudo snapper -c home set-config 'ALLOW_GROUPS=wheel'
		sudo snapper -c home set-config 'SYNC_ACL=yes'
		sudo snapper -c home set-config 'NUMBER_LIMIT=10'
		sudo snapper -c home set-config 'TIMELINE_CREATE=no'
		sudo snapper -c home set-config 'TIMELINE_LIMIT_HOURLY=5'
		sudo snapper -c home set-config 'TIMELINE_LIMIT_DAILY=7'
		sudo snapper -c home set-config 'TIMELINE_LIMIT_WEEKLY=0'
		sudo snapper -c home set-config 'TIMELINE_LIMIT_MONTHLY=0'
		sudo snapper -c home set-config 'TIMELINE_LIMIT_YEARLY=0'

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Setting permissions to access for non-root users"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo chmod 750 /.snapshots
		sudo chmod a+rx /.snapshots
		sudo chown -R :wheel /.snapshots

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Snapper services"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo systemctl enable --now snapper-cleanup.timer
		sudo systemctl enable --now snapper-timeline.timer
		sudo systemctl disable --now snapper-boot.timer

		echo
		tput setaf 2
		echo "######################################################################################################"
		echo "################# Snapper has been installed"
		echo "######################################################################################################"
		tput sgr0
		echo
		;;
	2)
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Timeshift to be installed..."
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo pacman -S --needed --noconfirm timeshift timeshift-autosnap grub-btrfs inotify-tools
		sudo systemctl enable --now cronie.service

		sudo sed -i 's/ExecStart=\/usr\/bin\/grub-btrfsd --syslog \/.snapshots/ExecStart=\/usr\/bin\/grub-btrfsd --syslog --timeshift-auto/' /usr/lib/systemd/system/grub-btrfsd.service
		sudo systemctl enable --now grub-btrfsd.service

		sudo grub-mkconfig
		sudo /etc/grub.d/41_snapshots-btrfs
		sudo grub-mkconfig -o /boot/grub/grub.cfg

		echo
		tput setaf 2
		echo "######################################################################################################"
		echo "################# Timeshift has been installed"
		echo "######################################################################################################"
		tput sgr0
		echo
		;;
	*)
		tput setaf 9
		echo "######################################################################################################"
		echo "################# Choose the correct number"
		echo "################# Nothing installed - install manually"
		echo "######################################################################################################"
		tput sgr0
		echo
		;;
	esac

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
