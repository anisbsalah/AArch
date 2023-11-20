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
tput setaf 6
echo "######################################################################################################"
echo "GRUB SETTINGS"
echo "######################################################################################################"
tput sgr0

tput setaf 3
echo "######################################################################################################"
echo "################# Editing grub file"
echo "######################################################################################################"
tput sgr0
echo

### Backup grub config
[[ ! -f /etc/default/grub ]] || sudo cp -anv /etc/default/grub /etc/default/grub.bak

### Resolution
#MONITOR_RESOLUTION=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')
MONITOR_RESOLUTION=$(xdpyinfo | awk '/dimensions/{print $2}')
sudo sed -i "s/GRUB_GFXMODE=auto/GRUB_GFXMODE=${MONITOR_RESOLUTION}/" /etc/default/grub
#sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE='${MONITOR_RESOLUTION}'/' /etc/default/grub

### Grub background
grep "GRUB_THEME=" /etc/default/grub >/dev/null 2>&1 && sudo sed -i '/GRUB_THEME=/d' /etc/default/grub
grep "GRUB_BACKGROUND=" /etc/default/grub >/dev/null 2>&1 && sudo sed -i '/GRUB_BACKGROUND=/d' /etc/default/grub
sudo cp -fv "${CURRENT_DIR}/Personal/settings/backgrounds/grub_bg.jpg" /boot/grub/grub_bg.jpg
echo 'GRUB_BACKGROUND=/boot/grub/grub_bg.jpg' | sudo tee -a /etc/default/grub
echo
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Grub file edited"
echo "######################################################################################################"
tput sgr0
echo
