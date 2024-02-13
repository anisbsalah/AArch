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
echo "################# Installing nano..."
echo "######################################################################################################"
tput sgr0
echo

printf "[*] Installing nano & nano-syntax-highlighting...\n\n"
sudo pacman -S --noconfirm --needed nano nano-syntax-highlighting

printf "\n[*] Copying a local configuration file...\n\n"
[[ ! -d "${HOME}/.config/nano" ]] && mkdir -p "${HOME}/.config/nano"
cp -v /etc/nanorc ~/.config/nano/nanorc

printf "\n[*] Enabling syntax highlighting...\n\n"
function add_entry() {
	local ENTRY=$1
	if ! grep -q "^${ENTRY}" "${HOME}/.config/nano/nanorc" >/dev/null 2>&1; then
		# Write a new line for the new entry
		echo "${ENTRY}" | tee -a "${HOME}/.config/nano/nanorc"
	fi
}

add_entry 'include "/usr/share/nano/*.nanorc"'
add_entry 'include "/usr/share/nano/extra/*.nanorc"'
add_entry 'include "/usr/share/nano-syntax-highlighting/*.nanorc"'
sudo sed -i 's/icolor brightnormal/icolor normal/g' /usr/share/nano-syntax-highlighting/nanorc.nanorc

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
