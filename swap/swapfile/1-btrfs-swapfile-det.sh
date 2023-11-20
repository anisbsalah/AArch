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

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Mounting the root btrfs filesystem to create the @swap subvolume"
		echo "######################################################################################################"
		tput sgr0
		echo

		ROOT_BTRFS_FS=$(df --output=source / | tail -n 1)
		UUID_ROOT=$(lsblk -dno UUID "${ROOT_BTRFS_FS}")
		#UUID_ROOT=$(blkid -s UUID -o value "${ROOT_BTRFS_FS}")

		sudo mount "${ROOT_BTRFS_FS}" /mnt
		#sudo mount "${ROOT_BTRFS_FS}" -o subvolid=5 /mnt
		#sudo mount -t btrfs -o subvol=/ /dev/disk/by-uuid/"${UUID_ROOT}" /mnt

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Creating the @swap subvolume"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo btrfs subvolume create /mnt/@swap

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Unmounting ${ROOT_BTRFS_FS} from /mnt"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo umount /mnt

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Creating the mount point directory for the @swap subvolume"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo mkdir /swap

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Mounting the @swap subvolume to the swap directory"
		echo "######################################################################################################"
		tput sgr0
		echo

		sudo mount -o defaults,noatime,subvol=/@swap "${ROOT_BTRFS_FS}" /swap

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Creating the swap file"
		echo "######################################################################################################"
		tput sgr0
		echo

		### Get the ram size in bytes
		RAM_SIZE_B=$(free -b -t | awk 'NR == 2 {print $2}')

		sudo btrfs filesystem mkswapfile --size "${RAM_SIZE_B}" --uuid clear /swap/swapfile

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Editing the fstab configuration to add an entry for the @swap and the swap file"
		echo "######################################################################################################"
		tput sgr0
		echo

		#sudo bash -c "echo UUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}")   /swap   btrfs   defaults,noatime,subvol=/@swap   0   0 >> /etc/fstab"
		#echo -e "\nUUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}") /swap           btrfs   defaults,noatime,subvol=/@swap 0       0" | sudo tee -a /etc/fstab
		echo "UUID=$(lsblk -no UUID "${ROOT_BTRFS_FS}") /swap           btrfs   defaults,noatime,subvol=/@swap 0       0" | sudo tee -a /etc/fstab

		echo

		#sudo bash -c "echo /swap/swapfile  swap    swap    defaults    0   0 >> /etc/fstab"
		echo "/swap/swapfile                            swap            swap    defaults      0       0" | sudo tee -a /etc/fstab

		echo

		sudo systemctl daemon-reload
		sudo mount -av

		echo
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Activating the swap file"
		echo "######################################################################################################"
		tput sgr0
		#echo

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
