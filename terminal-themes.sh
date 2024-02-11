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

if pacman -Qi "alacritty" &>/dev/null; then

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing themes for alacritty terminal..."
	echo "######################################################################################################"
	tput sgr0
	echo

	[[ -d "${HOME}/.config/alacritty/themes" ]] || mkdir -p "${HOME}/.config/alacritty/themes"
	cp -v "${CURRENT_DIR}/Personal/settings/terminal-themes/alacritty/"* "${HOME}/.config/alacritty/themes/"
fi

if pacman -Qi "gnome-terminal" &>/dev/null; then

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing themes for gnome-terminal..."
	echo "######################################################################################################"
	tput sgr0
	echo

	export TERMINAL=gnome-terminal
	bash "${CURRENT_DIR}/Personal/settings/terminal-themes/gnome-terminal/gnome-terminal-themes.sh"
fi

if pacman -Qi "xfce4-terminal" &>/dev/null; then

	echo
	tput setaf 3
	echo "######################################################################################################"
	echo "################# Installing themes for xfce terminal..."
	echo "######################################################################################################"
	tput sgr0
	echo

	[[ -d "${HOME}/.local/share/xfce4/terminal/colorschemes" ]] || mkdir -p "${HOME}/.local/share/xfce4/terminal/colorschemes"
	cp -v "${CURRENT_DIR}/Personal/settings/terminal-themes/xfce-terminal/"* "${HOME}/.local/share/xfce4/terminal/colorschemes"
fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
