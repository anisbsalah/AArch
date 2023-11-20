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
	ttf-bitstream-vera-mono-nerd
	ttf-cascadia-code-nerd
	otf-codenewroman-nerd
	ttf-dejavu-nerd
	ttf-fantasque-nerd
	ttf-firacode-nerd
	ttf-hack-nerd
	ttf-inconsolata-go-nerd
	ttf-inconsolata-lgc-nerd
	ttf-inconsolata-nerd
	ttf-iosevka-nerd
	ttf-iosevkaterm-nerd
	ttf-jetbrains-mono-nerd
	ttf-liberation-mono-nerd
	ttf-mononoki-nerd
	ttf-nerd-fonts-symbols
	ttf-nerd-fonts-symbols-mono
	ttf-noto-nerd
	ttf-roboto-mono-nerd
	ttf-sourcecodepro-nerd
	ttf-ubuntu-nerd
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
