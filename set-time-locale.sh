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

BOLD="$(tput bold)"
RESET="$(tput sgr0)"

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Setting Timezone"
echo "######################################################################################################"
tput sgr0
echo

read -rep "${BOLD}:: Enter your timezone (e.g. Africa/Tunis): ${RESET}" TIMEZONE
timedatectl --no-ask-password set-timezone "${TIMEZONE}"
timedatectl --no-ask-password set-ntp 1

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Setting locale"
echo "######################################################################################################"
tput sgr0
echo

read -rep "${BOLD}:: Enter your keyboard layout (e.g. fr): ${RESET}" KEYBOARD_LAYOUT
localectl --no-ask-password set-keymap "${KEYBOARD_LAYOUT}"
localectl --no-ask-password set-x11-keymap "${KEYBOARD_LAYOUT}"
localectl --no-ask-password set-locale LANG=en_US.UTF-8 LC_ADDRESS=en_US.UTF-8 LC_IDENTIFICATION=en_US.UTF-8 LC_MEASUREMENT=en_US.UTF-8 LC_MONETARY=en_US.UTF-8 LC_NAME=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LC_PAPER=en_US.UTF-8 LC_TELEPHONE=en_US.UTF-8 LC_TIME=en_US.UTF-8

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo

echo
tput setaf 5
echo "######################################################################################################"
echo "################# Rebooting now after 5 seconds"
echo "################# Press Ctrl+c to stop script"
echo "######################################################################################################"
tput sgr0
echo

sleep 5
sudo reboot
