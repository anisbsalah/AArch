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
echo "################# Lightdm configuration..."
echo "######################################################################################################"
tput sgr0
echo

if pacman -Qi lightdm-gtk-greeter &>/dev/null; then

	FIND='[#[:space:]]*greeter-session=.*'
	REPLACE='greeter-session=lightdm-gtk-greeter'
	sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/lightdm/lightdm.conf

	sudo tee "/etc/lightdm/lightdm-gtk-greeter.conf" <<EOF
[greeter]
theme-name = Arc-Dark
icon-theme-name = Papirus-Dark
cursor-theme-name = Qogir-Cursors
cursor-theme-size = 24
font-name = Noto Sans Bold 11
user-background = false
background = /usr/share/backgrounds/AbS-Wallpapers/lightdm-gtk_bg.jpg
default-user-image = /usr/share/backgrounds/AbS-Wallpapers/avatar.png
EOF

elif pacman -Qi lightdm-slick-greeter &>/dev/null; then

	FIND='[#[:space:]]*greeter-session=.*'
	REPLACE='greeter-session=lightdm-slick-greeter'
	sudo sed -i "s/${FIND}/${REPLACE}/g" /etc/lightdm/lightdm.conf

	sudo tee "/etc/lightdm/slick-greeter.conf" <<EOF
[Greeter]
background=/usr/share/backgrounds/AbS-Wallpapers/lightdm-slick_bg.jpg
background-color=#000000
draw-user-backgrounds=false
theme-name=Arc-Dark
icon-theme-name=Papirus-Dark
cursor-theme-name=Qogir-Cursors
cursor-theme-size=24
EOF

fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
