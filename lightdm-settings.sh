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

	sudo sed -i 's/[#[:space:]]*greeter-session=.*/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf
	sudo tee "/etc/lightdm/lightdm-gtk-greeter.conf" <<EOF
[greeter]
theme-name = Arc-Dark
icon-theme-name = Papirus-Dark
font-name = Noto Sans Bold 11
background = /usr/share/backgrounds/AbS-Wallpapers/login_bg1.jpg
default-user-image = /usr/share/backgrounds/AbS-Wallpapers/avatar.jpg
EOF

elif pacman -Qi lightdm-slick-greeter &>/dev/null; then

	sudo sed -i 's/[#[:space:]]*greeter-session=.*/greeter-session=lightdm-slick-greeter/g' /etc/lightdm/lightdm.conf
	sudo tee "/etc/lightdm/slick-greeter.conf" <<EOF
[Greeter]
background=/usr/share/backgrounds/AbS-Wallpapers/login_bg2.jpg
draw-user-backgrounds=false
theme-name=Arc-Dark
icon-theme-name=Papirus-Dark
cursor-theme-name=Qogir-Cursors
EOF

fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
