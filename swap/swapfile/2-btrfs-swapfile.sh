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
tput setaf 12
echo "######################################################################################################"
echo "Do you want to create a swap file on your system?"
echo "Answer with [Y/y] or [N/n]"
echo "######################################################################################################"
read -erp "Type your answer: " response
echo "######################################################################################################"
tput sgr0

case ${response} in

y | Y | yes | Yes | YES | 1)

	if [[ -f /swap/swapfile ]]; then

		echo
		tput setaf 13
		echo "######################################################################################################"
		echo "################# There is already a swap file"
		echo "################# Nothing to do"
		echo "######################################################################################################"
		tput sgr0
		echo

	else

		ROOT_BTRFS_FS=$(df --output=source / | tail -n 1)
		UUID_ROOT=$(lsblk -dno UUID "${ROOT_BTRFS_FS}")
		#UUID_ROOT=$(blkid -s UUID -o value "${ROOT_BTRFS_FS}")

		sudo mount "${ROOT_BTRFS_FS}" /mnt
		#sudo mount "${ROOT_BTRFS_FS}" -o subvolid=5 /mnt
		#sudo mount -t btrfs -o subvol=/ /dev/disk/by-uuid/"${UUID_ROOT}" /mnt

		echo

		sudo btrfs subvolume create /mnt/@swap

		echo

		### Get the ram size in bytes
		RAM_SIZE_B=$(free -b -t | awk 'NR == 2 {print $2}')

		sudo btrfs filesystem mkswapfile --size "${RAM_SIZE_B}" --uuid clear /mnt/@swap/swapfile

		sudo mkdir /mnt/@/swap

		sudo umount /mnt

		echo

		#sudo bash -c "echo UUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}")   /swap   btrfs   defaults,noatime,subvol=/@swap   0   0 >> /etc/fstab"
		#echo -e "\nUUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}") /swap           btrfs   defaults,noatime,subvol=/@swap 0       0" | sudo tee -a /etc/fstab
		echo "UUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}") /swap           btrfs   defaults,noatime,subvol=/@swap 0       0" | sudo tee -a /etc/fstab

		echo

		#sudo bash -c "echo /swap/swapfile  none    swap    defaults    0   0 >> /etc/fstab"
		echo "/swap/swapfile                            none            swap    defaults      0       0" | sudo tee -a /etc/fstab

		echo

		sudo systemctl daemon-reload
		sudo mount -av

		sudo swapon /swap/swapfile
		#sudo swapon -p 100 /swap/swapfile
		#sudo swapon --priority 100 /swap/swapfile

		sudo systemctl daemon-reload

		echo
		tput setaf 2
		echo "######################################################################################################"
		echo "################# Swap file created successfully"
		echo "######################################################################################################"
		tput sgr0
		echo
	fi
	;;

n | N | no | No | NO | 0)

	echo
	tput setaf 13
	echo "######################################################################################################"
	echo "################# We did nothing as per your request"
	echo "######################################################################################################"
	tput sgr0
	echo
	;;
*)
	echo
	tput setaf 9
	echo "######################################################################################################"
	echo "Invalid choice."
	echo "Try again."
	echo "######################################################################################################"
	tput sgr0

	exec "${0}"
	exit $?
	;;

esac
