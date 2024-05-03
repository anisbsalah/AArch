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
tput setaf 3
echo "######################################################################################################"
echo "################# Microcode..."
echo "######################################################################################################"
tput sgr0
echo

PROC_TYPE=$(lscpu)
if grep -Eiq "GenuineIntel" <<<"${PROC_TYPE}"; then
	printf "[*] Installing Intel microcode...\n\n"
	pacman -S --noconfirm --needed intel-ucode
elif grep -Eiq "AuthenticAMD" <<<"${PROC_TYPE}"; then
	printf "[*] Installing AMD microcode...\n\n"
	pacman -S --noconfirm --needed amd-ucode
fi

SEP="########################################"

echo
echo "########################################"
echo "[*] Adding microcode to HOOKS..."
echo "########################################"

grep '^HOOKS=' /etc/mkinitcpio.conf | if grep -q "microcode"; then echo "    microcode already in." && echo "${SEP}"; else sed -i '/^HOOKS=/s/autodetect\( \|$\)/autodetect microcode\1/g' /etc/mkinitcpio.conf; fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
