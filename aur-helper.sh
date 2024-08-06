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

clear
tput setaf 6
echo "######################################################################################################"
echo "################# Installing AUR helpers"
echo "######################################################################################################"
tput sgr0

function install_aur_helper() {
	# Define AUR array
	AUR=("yay" "yay-bin" "paru" "paru-bin" "trizen" "pikaur" "pakku" "aurman" "aura" "pacaur")

	# Print AUR array in multiple columns
	num_columns=2
	num_aur=${#AUR[@]}
	num_rows=$(((num_aur + num_columns - 1) / num_columns))
	for ((i = 0; i < num_rows; i++)); do
		for ((j = 0; j < num_columns; j++)); do
			index=$((j * num_rows + i))
			if ((index < num_aur)); then
				printf "%-2d) %-25s" "$((index + 1))" "${AUR[index]}"
			fi
		done
		echo
	done

	# Prompt user to select AUR
	tput setaf 5
	echo "#############################################"
	echo ":: Please enter your desired AUR helper(s):"
	echo "   (enter numbers separated by spaces)"
	echo "#############################################"
	tput sgr0

	read -er aur_nums_str

	# Convert user input to array of AUR names
	IFS=' ' read -ra aur_nums <<<"${aur_nums_str}"

	# Check if any valid AUR numbers were selected
	invalid_selection=0
	selected_aur=()

	for num in "${aur_nums[@]}"; do
		if ((num < 1 || num > ${#AUR[@]})); then
			tput setaf 9
			echo "######################################################################################################"
			echo "################# Invalid selection: ${num}"
			echo "######################################################################################################"
			tput sgr0

			invalid_selection=1
		else
			selected_aur+=("${AUR[num - 1]}")
		fi
	done

	if [ ! ${#selected_aur[@]} -eq 0 ]; then
		if ((invalid_selection == 0)); then

			# List AUR helper(s) to be installed
			tput setaf 13
			echo "########################"
			echo " AUR to be installed..."
			echo "########################"
			echo "* ${selected_aur[0]}"

			for ((i = 1; i < ${#selected_aur[@]}; i++)); do
				echo "* ${selected_aur[i]}"
			done

			echo "########################"
			tput sgr0
			echo

			# Install dependencies
			for deps in base-devel git; do
				if ! pacman -Qi "${deps}" &>/dev/null; then
					sudo pacman -S --noconfirm --needed "${deps}"
				fi
			done

			# Install selected AUR helper(s)
			for aur in "${selected_aur[@]}"; do
				if pacman -Qi "${aur%-bin}" &>/dev/null || pacman -Qi "${aur}" &>/dev/null; then
					tput setaf 2
					echo "######################################################################################################"
					echo "################# '${aur%-bin}' is already installed"
					echo "######################################################################################################"
					tput sgr0
					echo
					return 0
				else
					tput setaf 3
					echo "######################################################################################################"
					echo "################# Installing '${aur}'..."
					echo "######################################################################################################"
					tput sgr0
					echo
					(
						git clone "https://aur.archlinux.org/${aur}.git" "/tmp/${aur}"
						cd "/tmp/${aur}" || exit 1
						makepkg -si --noconfirm --needed
					)

					case ${aur} in
					"pacaur")
						mkdir -p "${HOME}/.config/pacaur"
						cp "${CURRENT_DIR}/Personal/settings/pacaur/config" "${HOME}/.config/pacaur/"
						;;
					*) ;;
					esac
				fi
			done

			echo
			tput setaf 2
			echo "######################################################################################################"
			echo "################# Installation complete"
			echo "######################################################################################################"
			tput sgr0
			echo
		fi
	else
		# If nothing selected
		install_aur_helper
	fi
}

install_aur_helper
