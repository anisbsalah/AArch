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
echo "################# VSCodium configuration..."
echo "######################################################################################################"
tput sgr0
echo

echo "Installing personal settings..."

cp -rf "${CURRENT_DIR}/Personal/settings/VSCodium" "${HOME}/.config/"

echo

extensions=(
	"EditorConfig.EditorConfig"
	"esbenp.prettier-vscode"
	"foxundermoon.shell-format"
	"jeff-hykin.better-nix-syntax"
	"JohnnyMorganz.stylua"
	"mkhl.shfmt"
	"ph-hawkins.arc-plus"
	"PKief.material-icon-theme"
	"rogalmic.bash-debug"
	"timonwong.shellcheck"
	"trunk.io"
)

for ext in "${extensions[@]}"; do
	codium --install-extension "${ext}" --force
done

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
