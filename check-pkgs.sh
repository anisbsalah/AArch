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

##################################################################################################################
#
# DECLARATION OF FUNCTION
#
##################################################################################################################

function check_pkgs() {
	MISSING_PKGS='/tmp/missing_pkgs.log'
	[[ -f ${MISSING_PKGS} ]] && rm "${MISSING_PKGS}"

	backmessage="Arch Linux Packages"
	message="Checking for missing packages..."
	TERM=ansi whiptail --backtitle "${backmessage}" \
		--title "Package Check" --infobox "${message}" 8 0

	missing_pkgs=()
	printf "=== MISSING PKGS (IF ANY) ===\n\n" &>>"${MISSING_PKGS}"

	for pkg_arr in "${all_pkgs[@]}"; do
		declare -n arr_name=${pkg_arr} # make a namespace for each pkg_array
		for pkg_name in "${arr_name[@]}"; do
			if ! pacman -Sp "${pkg_name}" &>/dev/null; then
				#echo -e "\n'${pkg_name}' from '${pkg_arr}' is missing...\n" &>>"${MISSING_PKGS}" 2>&1
				printf "\n'%s' from '%s' is missing...\n" "${pkg_name}" "${pkg_arr}" &>>"${MISSING_PKGS}" 2>&1
				missing_pkgs+=("${pkg_arr}::${pkg_name}")
			fi
		done
	done
	# printf "%s\n" "${missing_pkgs[@]}" &>>"${MISSING_PKGS}"
	printf "\n===  END OF MISSING PKGS  ===\n" &>>"${MISSING_PKGS}"

	whiptail --backtitle "${backmessage}" --title "Missing Packages" \
		--textbox "${MISSING_PKGS}" --scrolltext 30 90
}

##################################################################################################################
#
# PACKAGES ARRAYS
#
##################################################################################################################

base_pkgs=(base base-devel linux linux-headers linux-firmware)

essential_pkgs=(bash-completion git man-db man-pages texinfo terminus-font nano pacman-contrib sudo zstd)

xorg_pkgs=(xorg xorg-xkill)

drivers=(
	# ------------------------ Graphics
	xf86-video-amdgpu
	xf86-video-ati
	xf86-video-intel
	xf86-video-nouveau
	xf86-video-fbdev
	xf86-video-vesa
	xf86-video-vmware
	mesa lib32-mesa
	vulkan-icd-loader vulkan-intel vulkan-radeon
	lib32-vulkan-icd-loader lib32-vulkan-intel lib32-vulkan-radeon
	libva-intel-driver lib32-libva-intel-driver
	mesa-vdpau lib32-mesa-vdpau
	libva-mesa-driver lib32-libva-mesa-driver
	# ------------------------ Wifi
	dkms broadcom-wl-dkms
	# ------------------------ Input
	libinput xf86-input-libinput xf86-input-evdev
	xf86-input-elographics xf86-input-synaptics
)

cinnamon_desktop=(cinnamon cinnamon-translations
	lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
	blueman gnome-screenshot gnome-system-monitor
	nemo-fileroller nemo-share xed)

gnome_desktop=(gnome gnome-extra gnome-bluetooth)

kde_desktop=(plasma-meta dolphin dolphin-plugins kate konsole sddm
	ark audiocd-kio bluedevil extra-cmake-modules ffmpegthumbs
	ghostwriter gwenview kate kcodecs kcoreaddons kcron kdeconnect
	kdegraphics-thumbnailers kdenetwork-filesharing kdialog kimageformats
	kinit kio-fuse kompare libksysguard networkmanager-qt5 okular packagekit-qt6
	partitionmanager plasma-wayland-protocols print-manager solid spectacle
	svgpart xsettingsd xwaylandvideobridge yakuake)

mate_desktop=(mate mate-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings)

xfce_desktop=(xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings)

networking_pkgs=(avahi bind bridge-utils curl dhclient dnsmasq dnsutils
	git ifplugd inetutils ipset mobile-broadband-provider-info
	modemmanager net-tools netctl network-manager-applet networkmanager
	networkmanager-openconnect networkmanager-openvpn nfs-utils
	nm-connection-editor nss-mdns ntp openbsd-netcat openconnect
	openresolv openssh openvpn wget wireless-regdb wireless_tools wpa_supplicant)

bluetooth_pkgs=(bluez bluez-libs bluez-utils)

sound_pkgs=(wireplumber pipewire-jack pipewire pipewire-alsa pipewire-audio pipewire-pulse pavucontrol
	alsa-card-profiles alsa-firmware alsa-lib alsa-plugins alsa-utils sof-firmware
	pipewire-docs pipewire-ffado pipewire-roc pipewire-v4l2 pipewire-x11-bell
	pipewire-zeroconf lib32-pipewire lib32-pipewire-jack
	gst-plugin-pipewire gstreamer gst-libav gst-plugins-bad
	gst-plugins-base gst-plugins-good gst-plugins-ugly playerctl)

printing_pkgs=(cups cups-pdf cups-filters cups-pk-helper
	foomatic-db foomatic-db-engine foomatic-db-gutenprint-ppds
	foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds
	ghostscript gsfonts gutenprint gtk3-print-backends libcups system-config-printer)

laptop_pkgs=(acpi acpid acpi_call tlp)

archive_pkgs=(arj cabextract file-roller gzip lzop p7zip sharutils
	unace unarchiver unrar unzip usbutils xz zip zstd)

disk_pkgs=(btrfs-progs cifs-utils dosfstools e2fsprogs exfat-utils
	fuse2 fuse3 fuseiso gpart gparted
	gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
	ifuse mtools mtpfs nfs-utils nilfs-utils ntfs-3g
	os-prober partclone partimage squashfs-tools sshfs udiskie udisks2 uudeview)

font_pkgs=(noto-fonts noto-fonts-emoji terminus-font ttf-hack
	ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-mononoki-nerd
	ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono)

pacman_pkgs=(alacritty arc-gtk-theme autoconf automake bash-completion
	cronie dconf-editor dialog evince exa expac ffmpegthumbs htop icoutils
	imagemagick kitty kvantum libreoffice-still libx11 libxft libxinerama
	make meld nano nano-syntax-highlighting papirus-icon-theme pkgconf
	qbittorrent ranger reflector rofi rsync shellcheck shfmt telegram-desktop
	vlc which xdg-desktop-portal xdg-user-dirs xdg-utils yad zenity
	zsh zsh-autosuggestions zsh-syntax-highlighting)

all_pkgs=(
	base_pkgs
	essential_pkgs
	xorg_pkgs
	drivers
	cinnamon_desktop
	gnome_desktop
	kde_desktop
	mate_desktop
	xfce_desktop
	networking_pkgs
	sound_pkgs
	bluetooth_pkgs
	printing_pkgs
	archive_pkgs
	disk_pkgs
	laptop_pkgs
	font_pkgs
	pacman_pkgs
)

######################################################################################################
# Initialize the package database
sudo pacman -Sy &>/dev/null

# Search for missing packages
check_pkgs
######################################################################################################
