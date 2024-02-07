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
	echo "################# Installing Snapper..." # with the suggested filesystem layout from arch wiki
	echo "######################################################################################################"
	tput sgr0
	echo

	if [[ -d /.snapshots ]]; then
		sudo umount /.snapshots
		sudo rm -rf /.snapshots
	fi

	# Comment the line containing `@snapshots` (if it exists) in fstab
	# To prevent failure of snapper configuration creation.
	sudo sed -i '/@snapshots/s/^/# /' /etc/fstab
	sudo systemctl daemon-reload

	sudo pacman -S --needed --noconfirm btrfs-assistant # An application for managing BTRFS subvolumes and Snapper snapshots
	sudo pacman -S --needed --noconfirm grub-btrfs inotify-tools
	sudo pacman -S --needed --noconfirm snapper
	sudo pacman -S --needed --noconfirm snap-pac-git     # Pacman hooks that use snapper to create pre/post btrfs snapshots like openSUSE's YaST
	sudo pacman -S --needed --noconfirm snap-pac-grub    # Pacman hook to update GRUB entries for grub-btrfs after snap-pac made snapshots
	sudo pacman -S --needed --noconfirm snapper-support  # Support package for enabling Snapper with snap-pac and grub-btrfs support
	sudo pacman -S --needed --noconfirm snapper-rollback # Script for rolling back to a previous snapper-managed BTRFS snapshot using the arch wiki suggested subvolume layout
	#sudo pacman -S --needed --noconfirm snapper-tools-git # A highly opinionated Snapper GUI and CLI

	# snapper-rollback configuration
	ROOT_BTRFS_FS=$(df --output=source / | tail -n 1)
	sudo sed -i "s|^#dev = /dev/sda42|dev = ${ROOT_BTRFS_FS}|" /etc/snapper-rollback.conf

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Deleting the default configuration" # so that the created snapshots when installing snapper would be deleted
	echo "######################################################################################################"
	tput sgr0
	echo

	sleep 3
	sudo snapper -c root delete-config

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Creating snapper configuration for root"
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo snapper -c root create-config /

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
	echo "################# Creating snapper configuration for home"
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
	echo "################# Creating snapshots directory & setting permissions to access for non-root users"
	echo "######################################################################################################"
	tput sgr0
	echo

	sudo btrfs subvolume delete /.snapshots

	sudo mkdir /.snapshots
	sudo chmod 750 /.snapshots
	sudo chmod a+rx /.snapshots
	sudo chown -R :wheel /.snapshots

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Checking if @snapshots subvolume exists"
	echo "######################################################################################################"
	tput sgr0
	echo

	if sudo btrfs subvolume list / | grep -q '@snapshots' >/dev/null 2>&1; then
		tput setaf 13
		echo '==> @snapshots subvolume already exists'
		tput sgr0
		echo
	else
		# Create @snapshots subvolume
		tput setaf 13
		echo '==> @snapshots subvolume being created...'
		tput sgr0
		echo

		ROOT_BTRFS_FS=$(df --output=source / | tail -n 1)
		UUID_ROOT=$(lsblk -dno UUID "${ROOT_BTRFS_FS}")
		sudo mount -t btrfs -o subvol=/ /dev/disk/by-uuid/"${UUID_ROOT}" /mnt
		#sudo mount "${ROOT_BTRFS_FS}" /mnt
		#sudo mount -o subvolid=5 "${ROOT_BTRFS_FS}" /mnt

		sudo btrfs subvolume create /mnt/@snapshots
		sudo umount /mnt
	fi

	if grep -q '@snapshots' /etc/fstab >/dev/null 2>&1; then
		# Uncomment the line containing `@snapshots` (if it already exists)
		sudo sed -i '/@snapshots/s/^[#[:space:]]*//' /etc/fstab
	else
		# Add an entry for @subvolume in fstab
		echo
		echo "UUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}") /.snapshots	btrfs	defaults,noatime,compress=zstd,subvol=/@snapshots 0       0" | sudo tee -a /etc/fstab
		#sudo mount -o defaults,noatime,compress=zstd,subvol=/@snapshots "${ROOT_BTRFS_FS}" /.snapshots
	fi

	echo
	sudo systemctl daemon-reload
	sudo mount -av

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

	# echo
	# tput setaf 3
	# echo "######################################################################################################"
	# echo "################# Setting root as the default subvolume"
	# echo "######################################################################################################"
	# tput sgr0
	# echo
	# id_root_subvol=$(btrfs inspect-internal rootid /)
	# sudo btrfs subvolume set-default $id_root_subvol /

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
