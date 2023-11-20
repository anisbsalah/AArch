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

# Define fonts array
fonts=("3270" "agave" "anonymouspro" "arimo" "bigblueterminal" "bitstream-vera-mono" "cascadia-code" "cousine" "daddytime-mono" "dejavu" "fantasque" "firacode" "go" "hack" "heavydata" "iawriter" "ibmplex-mono" "inconsolata-go" "inconsolata-lgc" "inconsolata" "iosevka" "iosevkaterm" "jetbrains-mono" "lekton" "liberation-mono" "lilex" "meslo" "monofur" "monoid" "mononoki" "mplus" "noto" "profont" "roboto-mono" "sharetech-mono" "sourcecodepro" "space-mono" "terminus" "tinos" "ubuntu-mono" "ubuntu" "victor-mono")

# Prompt user to select font
echo "****************************************"
echo " Which fonts would you like to install?"
echo "****************************************"
select font in "${fonts[@]}"; do
	if [[ " ${fonts[@]} " =~ " ${font} " ]]; then
		tput setaf 3
		echo "######################################################################################################"
		echo "################# Installing ${font}..."
		echo "######################################################################################################"
		tput sgr0
		break
	else
		tput setaf 9
		echo "######################################################################################################"
		echo "################# Invalid selection."
		echo "################# Please choose a number from 1 to ${#fonts[@]}."
		echo "######################################################################################################"
		tput sgr0
	fi
done

# Install the font using pacman
sudo pacman -S --noconfirm ttf-"${font}"-nerd

# Check if the installation was successful
if [[ $? -eq 0 ]]; then
	tput setaf 2
	echo "######################################################################################################"
	echo "################# ${font} has been installed."
	echo "######################################################################################################"
	tput sgr0
else
	tput setaf 9
	echo "######################################################################################################"
	echo "################# Failed to install ${font}."
	echo "######################################################################################################"
	tput sgr0
	exit 1
fi
