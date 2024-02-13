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
echo "################# Variables setup..."
echo "######################################################################################################"
tput sgr0
echo

#if grep -q "GTK_THEME=" /etc/environment; then
#	# Replace the existing value of GTK_THEME with "Arc-Dark"
#	sudo sed -i 's/GTK_THEME=.*/GTK_THEME=Arc-Dark/' /etc/environment
#else
#	# Write a new line with GTK_THEME=Arc-Dark
#	echo "GTK_THEME=Arc-Dark" | sudo tee -a /etc/environment
#fi

#if grep -q "QT_STYLE_OVERRIDE=" /etc/environment; then
#	# Replace the existing value of QT_STYLE_OVERRIDE with "kvantum"
#	sudo sed -i 's/QT_STYLE_OVERRIDE=.*/QT_STYLE_OVERRIDE=kvantum/' /etc/environment
#else
#	# Write a new line with QT_STYLE_OVERRIDE=kvantum
#	echo "QT_STYLE_OVERRIDE=kvantum" | sudo tee -a /etc/environment
#fi

function search_and_replace() {
	local FIND=$1
	local REPLACE=$2

	if grep -q "${FIND}" /etc/environment; then
		# Replace the existing value of the variable
		sudo sed -i "s/${FIND}.*/${REPLACE}/g" /etc/environment
	else
		# Write a new line with the variable
		echo "${REPLACE}" | sudo tee -a /etc/environment
	fi
}

search_and_replace "GTK_THEME=" "GTK_THEME=Arc-Dark"
search_and_replace "QT_STYLE_OVERRIDE=" "QT_STYLE_OVERRIDE=kvantum"
search_and_replace "EDITOR=" "EDITOR=nano"
search_and_replace "VISUAL=" "VISUAL=nano"

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
