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

# See: https://wiki.archlinux.org/title/Environment_variables#Using_shell_initialization_files

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Creating 'set_path' function to add directories to PATH..."
echo "######################################################################################################"
tput sgr0
echo

if grep -q 'set_path() {' /etc/profile; then

	echo
	tput setaf 2
	echo "######################################################################################################"
	echo "################# 'set_path' function already exists"
	echo "######################################################################################################"
	tput sgr0
	echo

else

	# shellcheck disable=SC2016
	echo '
set_path() {

	# Check if user id is 1000 or higher
	[[ "$(id -u)" -ge 1000 ]] || return

	for i in "$@"; do
		# Check if the directory exists
		[[ -d ${i} ]] || continue

		# Check if it is not already in your $PATH.
		echo "${PATH}" | grep -Eq "(^|:)${i}(:|$)" && continue

		# Then append it to $PATH and export it
		export PATH="${PATH}:${i}"
	done
}

set_path ~/bin ~/scripts ~/.local/bin' | sudo tee -a /etc/profile

fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
