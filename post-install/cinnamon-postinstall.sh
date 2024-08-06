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
echo "################# Cinnamon post installation..."
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

# Appearance
gsettings set org.cinnamon.desktop.interface cursor-theme 'Qogir-Cursors'
gsettings set org.cinnamon.desktop.interface cursor-size 24
gsettings set org.cinnamon.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.cinnamon.theme name 'Arc-Dark'

gsettings set org.gnome.desktop.interface cursor-theme 'Qogir-Cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Desktop background
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/AbS-Wallpapers/desktop_bg.jpg'
gsettings set org.cinnamon.desktop.background picture-options 'stretched'

gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/AbS-Wallpapers/desktop_bg.jpg'
gsettings set org.gnome.desktop.background picture-options 'stretched'

# Font selection
gsettings set org.cinnamon.desktop.interface font-name 'Noto Sans 11'
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Noto Sans Bold 11'
gsettings set org.nemo.desktop font 'Noto Sans 11'

gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Hack 10'
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans Bold 11'

# Display manager slick greeter
gsettings set x.dm.slick-greeter background '/usr/share/backgrounds/AbS-Wallpapers/login_bg2.jpg'
gsettings set x.dm.slick-greeter background-color '#000000'
gsettings set x.dm.slick-greeter draw-user-backgrounds true
gsettings set x.dm.slick-greeter theme-name 'Arc-Dark'
gsettings set x.dm.slick-greeter icon-theme-name 'Papirus-Dark'
gsettings set x.dm.slick-greeter cursor-theme-name 'Qogir-Cursors'
gsettings set x.dm.slick-greeter font-name 'Noto Sans Bold 11'

# Keyboard & Touchpad
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false
gsettings set org.cinnamon.desktop.peripherals.touchpad edge-scrolling-enabled true
gsettings set org.cinnamon.desktop.peripherals.touchpad two-finger-scrolling-enabled false
gsettings set org.cinnamon.desktop.peripherals.touchpad natural-scroll false

# Nemo
gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
gsettings set org.nemo.preferences show-open-in-terminal-toolbar true

# Gedit
gsettings set org.gnome.gedit.plugins active-plugins "['wordcompletion', 'multiedit', 'colorpicker', 'codecomment', 'charmap', 'bracketcompletion', 'spell', 'sort', 'quickopen', 'quickhighlight', 'modelines', 'filebrowser', 'docinfo']"
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor use-default-font false
gsettings set org.gnome.gedit.preferences.editor editor-font 'JetBrainsMono Nerd Font 12'
gsettings set org.gnome.gedit.preferences.editor scheme 'arc-dark'
gsettings set org.gnome.gedit.preferences.editor highlight-current-line false
gsettings set org.gnome.gedit.preferences.editor wrap-mode 'none'

# Xedit
gsettings set org.x.editor.plugins active-plugins "['wordcompletion', 'time', 'textsize', 'taglist', 'sort', 'modelines', 'joinlines', 'filebrowser', 'docinfo', 'open-uri-context-menu', 'bracketcompletion']"
gsettings set org.x.editor.preferences.editor bracket-matching true
gsettings set org.x.editor.preferences.editor display-line-numbers true
gsettings set org.x.editor.preferences.editor use-default-font false
gsettings set org.x.editor.preferences.editor editor-font 'JetBrainsMono Nerd Font 12'
gsettings set org.x.editor.preferences.editor scheme 'oblivion'
gsettings set org.x.editor.preferences.editor highlight-current-line true
gsettings set org.x.editor.preferences.editor prefer-dark-theme true

# Default applications
gsettings set org.cinnamon.desktop.default-applications.terminal exec 'alacritty'

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo
