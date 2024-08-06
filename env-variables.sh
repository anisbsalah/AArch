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

function search_and_replace() {
	local FIND=$1
	local REPLACE=$2
	local FILE=$3

	if grep -q "${FIND}" "${FILE}"; then
		# Replace the existing value of the variable
		sudo sed -i "s/${FIND}.*/${REPLACE}/g" "${FILE}"
	else
		# Write a new line with the variable
		echo "${REPLACE}" | sudo tee -a "${FILE}"
	fi
}

# Environment variables
search_and_replace "GTK_THEME=" "GTK_THEME=Arc-Dark" "/etc/environment"
search_and_replace "QT_STYLE_OVERRIDE=" "QT_STYLE_OVERRIDE=kvantum" "/etc/environment"
search_and_replace "EDITOR=" "EDITOR=nano" "/etc/environment"
search_and_replace "VISUAL=" "VISUAL=nano" "/etc/environment"

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
