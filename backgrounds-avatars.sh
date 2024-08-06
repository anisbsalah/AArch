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
CURRENT_DIR="$(pwd)"
##################################################################################################################

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Installing personal backgrounds and avatars..."
echo "######################################################################################################"
tput sgr0
echo

[[ -d /usr/share/backgrounds/AbS-Wallpapers ]] || sudo mkdir -p /usr/share/backgrounds/AbS-Wallpapers
sudo cp -v "${CURRENT_DIR}"/Personal/settings/backgrounds/* /usr/share/backgrounds/AbS-Wallpapers/
sudo cp -v "${CURRENT_DIR}/Personal/settings/.face" /usr/share/backgrounds/AbS-Wallpapers/avatar.png
cp -v "${CURRENT_DIR}/Personal/settings/.face" "${HOME}/.face"

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Images installed"
echo "######################################################################################################"
tput sgr0
echo
