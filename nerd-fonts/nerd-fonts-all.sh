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
##################################################################################################################
#
# DECLARATION OF FUNCTIONS
#
##################################################################################################################

func_install() {
	if pacman -Qi "$1" &>/dev/null; then
		tput setaf 2
		echo "######################################################################################################"
		echo "################# The package '$1' is already installed"
		echo "######################################################################################################"
		echo
		tput sgr0
	else
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Installing $1"
		echo "######################################################################################################"
		echo
		tput sgr0
		sudo pacman -S --noconfirm --needed "$1"
	fi
}

func_category() {
	tput setaf 6
	echo "######################################################################################################"
	echo "Installing software for category '$1'"
	echo "######################################################################################################"
	echo
	tput sgr0
}

###############################################################################

func_category Fonts

list=(
	ttf-3270-nerd
	ttf-agave-nerd
	ttf-anonymouspro-nerd
	ttf-arimo-nerd
	otf-aurulent-nerd
	ttf-bigblueterminal-nerd
	ttf-bitstream-vera-mono-nerd
	ttf-cascadia-code-nerd
	otf-codenewroman-nerd
	otf-comicshanns-nerd
	ttf-cousine-nerd
	ttf-daddytime-mono-nerd
	ttf-dejavu-nerd
	otf-droid-nerd
	ttf-fantasque-nerd
	ttf-firacode-nerd
	otf-firamono-nerd
	ttf-go-nerd
	ttf-hack-nerd
	otf-hasklig-nerd
	ttf-heavydata-nerd
	otf-hermit-nerd
	ttf-iawriter-nerd
	ttf-ibmplex-mono-nerd
	ttf-inconsolata-go-nerd
	ttf-inconsolata-lgc-nerd
	ttf-inconsolata-nerd
	ttf-iosevka-nerd
	ttf-iosevkaterm-nerd
	ttf-jetbrains-mono-nerd
	ttf-lekton-nerd
	ttf-liberation-mono-nerd
	ttf-lilex-nerd
	ttf-meslo-nerd
	ttf-monofur-nerd
	ttf-monoid-nerd
	ttf-mononoki-nerd
	ttf-mplus-nerd
	ttf-nerd-fonts-symbols
	ttf-nerd-fonts-symbols-common
	ttf-nerd-fonts-symbols-mono
	ttf-noto-nerd
	otf-opendyslexic-nerd
	otf-overpass-nerd
	ttf-profont-nerd
	ttf-proggyclean-nerd
	ttf-roboto-mono-nerd
	ttf-sharetech-mono-nerd
	ttf-sourcecodepro-nerd
	ttf-space-mono-nerd
	ttf-terminus-nerd
	ttf-tinos-nerd
	ttf-ubuntu-mono-nerd
	ttf-ubuntu-nerd
	ttf-victor-mono-nerd
)

count=0
for name in "${list[@]}"; do
	count=$((count + 1))
	tput setaf 3
	echo "Installing package nr. ${count} - ${name}"
	tput sgr0
	func_install "${name}"
done

###############################################################################

tput setaf 2
echo "######################################################################################################"
echo "Software has been installed"
echo "######################################################################################################"
echo
tput sgr0
