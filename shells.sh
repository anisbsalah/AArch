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
echo "################# bash..."
echo "######################################################################################################"
tput sgr0
echo

[[ -f "${HOME}/.bashrc" ]] && cp -an "${HOME}/.bashrc" "${HOME}/.bashrc.bak"
cp -v "${CURRENT_DIR}/Personal/settings/bash/.bashrc" "${HOME}/"

echo
tput setaf 3
echo "######################################################################################################"
echo "################# Zsh..."
echo "######################################################################################################"
tput sgr0
echo

sudo pacman -S --noconfirm --needed zsh zsh-autosuggestions zsh-syntax-highlighting

if [[ ! ${SHELL} =~ zsh ]]; then
	printf '\n[*] Making Zsh your default shell...\n\n'
	sudo chsh -s "$(command -v zsh)" "${USER}"
fi

if ! grep -q 'ZDOTDIR=' /etc/zsh/zshenv &>/dev/null; then
	# shellcheck disable=SC2016
	printf '\n[*] Setting $ZDOTDIR...\n\n'
	# shellcheck disable=SC2016
	echo '
export ZDOTDIR=${HOME}/.config/zsh' | sudo tee -a /etc/zsh/zshenv
fi

printf '\n[*] Copying dotfiles...\n\n'
[[ ! -d ${HOME}/.config/zsh ]] && mkdir -p "${HOME}/.config/zsh"
if pacman -Qi oh-my-zsh &>/dev/null || pacman -Qi oh-my-zsh-git &>/dev/null; then
	cp -av "${CURRENT_DIR}/Personal/settings/oh-my-zsh/"* "${HOME}/.config/zsh/"
	sudo sed -i 's|HISTFILE=.*|HISTFILE="$HOME/.config/zsh/.zsh_history"|' /usr/share/oh-my-zsh/lib/history.zsh
else
	cp -rfv "${CURRENT_DIR}/Personal/settings/zsh" "${HOME}/.config/"

fi

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
