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
echo "################# Plasma post installation..."
echo "######################################################################################################"
tput sgr0
echo

DESKTOP_BG="/usr/share/backgrounds/AbS-Wallpapers/desktop_bg.jpg"
LOOKANDFEEL="org.kde.breezedark.desktop"
COLORSCHEME="ArcDark"
KVANTUM_THEME="ArcDark"
DESKTOPTHEME="Arc-Dark"
GTK_THEME="Arc-Dark"
ICON_THEME="Papirus-Dark"
CURSOR_THEME="Breeze_Light"
SOUND_THEME="ocean"

# -------------------------------------------------

SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
SDDM_THEME="breeze"
SDDM_CURSOR_THEME="Breeze_Light"
SDDM_FONT="Noto Sans,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1"
SDDM_THEME_CONF="/usr/share/sddm/themes/${SDDM_THEME}/theme.conf.user"
SDDM_BG="/usr/share/backgrounds/AbS-Wallpapers/sddm_bg.jpg"

echo "[*] Sddm settings..."

sudo tee "${SDDM_CONF}" <<EOF
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=${SDDM_THEME}
CursorTheme=${SDDM_CURSOR_THEME}
Font=${SDDM_FONT}

[Users]
MaximumUid=60513
MinimumUid=1000
EOF

sudo tee "${SDDM_THEME_CONF}" <<EOF
[General]
background=${SDDM_BG}
type=image
EOF

# -------------------------------------------------

echo "[*] Setting system fonts..."
kwriteconfig6 --file kdeglobals --group "General" --key "font" "Noto Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group "General" --key "fixed" "Hack,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group "General" --key "smallestReadableFont" "Noto Sans,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group "General" --key "toolBarFont" "Noto Sans,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group "General" --key "menuFont" "Noto Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group "WM" --key "activeFont" "Noto Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group "General" --key "XftAntialias" "true"
kwriteconfig6 --file kdeglobals --group "General" --key "XftHintStyle" "hintslight"
kwriteconfig6 --file kdeglobals --group "General" --key "XftSubPixel" "rgb"

# -------------------------------------------------

echo "[*] Setting wallpaper image..."
plasma-apply-wallpaperimage "${DESKTOP_BG}"

# -------------------------------------------------

echo "[*] Setting colors and themes..."
# plasma-apply-lookandfeel -a "${LOOKANDFEEL}" # lookandfeeltool -a "${LOOKANDFEEL}"
plasma-apply-colorscheme "${COLORSCHEME}"
kwriteconfig6 --file kdeglobals --group "KDE" --key "widgetStyle" "kvantum"
kvantummanager --set "${KVANTUM_THEME}"
qdbus6 org.kde.GtkConfig /GtkConfig org.kde.GtkConfig.setGtkTheme "${GTK_THEME}"
plasma-apply-desktoptheme "${DESKTOPTHEME}"
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key "library" "org.kde.kwin.aurorae"
kwriteconfig6 --file kwinrc --group "org.kde.kdecoration2" --key "theme" "__aurorae__svg__Arc-Dark"
kwriteconfig6 --file kdeglobals --group "Icons" --key "Theme" "${ICON_THEME}"
kwriteconfig6 --file kdeglobals --group "Sounds" --key "Theme" "${SOUND_THEME}"
plasma-apply-cursortheme "${CURSOR_THEME}"
kwriteconfig6 --file ksplashrc --group "KSplash" --key "Engine" "none"
kwriteconfig6 --file ksplashrc --group "KSplash" --key "Theme" "None"

# -------------------------------------------------

echo "[*] Setting dark GTK..."
function set_dark_gtk {
	local gtk3_settings=~/.config/gtk-3.0/settings.ini
	local gtk4_settings=~/.config/gtk-4.0/settings.ini
	GTK_SETTINGS=("${gtk3_settings}" "${gtk4_settings}")

	for gtk_settings in "${GTK_SETTINGS[@]}"; do
		mkdir -p "$(dirname "${gtk_settings}")"

		cat >"${gtk_settings}" <<EOF
[Settings]
gtk-application-prefer-dark-theme=true
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=Breeze_Light
gtk-cursor-theme-size=24
gtk-font-name=Noto Sans,  10
gtk-modules=colorreload-gtk-module
gtk-sound-theme-name=ocean
EOF
	done
}

set_dark_gtk

# -------------------------------------------------

echo "[*] Setting screen locking appearance..."
LOCK_IMAGE="/usr/share/backgrounds/AbS-Wallpapers/sddm_bg.jpg"
LOCK_PRVIEWIMAGE="/usr/share/backgrounds/AbS-Wallpapers/sddm_bg.jpg"
kwriteconfig6 --file kscreenlockerrc --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" --key "Image" "${LOCK_IMAGE}"
kwriteconfig6 --file kscreenlockerrc --group "Greeter" --group "Wallpaper" --group "org.kde.image" --group "General" --key "PreviewImage" "${LOCK_PRVIEWIMAGE}"

# -------------------------------------------------

echo "[*] Setting services to be shown in the context menu..."
kwriteconfig6 --file kservicemenurc --group "Show" --key "kompare" "false"
kwriteconfig6 --file kservicemenurc --group "Show" --key "OpenAsRootKDE5" "true"
kwriteconfig6 --file kservicemenurc --group "Show" --key "runInKonsole" "true"
kwriteconfig6 --file kservicemenurc --group "Show" --key "selected" "true"
kwriteconfig6 --file kservicemenurc --group "Show" --key "selectedsudo" "true"

# -------------------------------------------------

echo "[*] Setting keyboard layout..."
kwriteconfig6 --file kxkbrc --group "Layout" --key "DisplayNames" ","
kwriteconfig6 --file kxkbrc --group "Layout" --key "LayoutList" "fr,ara"
kwriteconfig6 --file kxkbrc --group "Layout" --key "Options" "grp:win_space_toggle"
kwriteconfig6 --file kxkbrc --group "Layout" --key "ResetOldOptions" "true"
kwriteconfig6 --file kxkbrc --group "Layout" --key "Use" "true"
kwriteconfig6 --file kxkbrc --group "Layout" --key "VariantList" ",azerty"

# -------------------------------------------------

echo "[*] Setting touchpad options..."
kwriteconfig6 --file touchpadxlibinputrc --group "AlpsPS/2 ALPS GlidePoint" --key "scrollEdge" "true"
kwriteconfig6 --file touchpadxlibinputrc --group "AlpsPS/2 ALPS GlidePoint" --key "scrollTwoFinger" "false"
kwriteconfig6 --file touchpadxlibinputrc --group "AlpsPS/2 ALPS GlidePoint" --key "tapToClick" "true"

# -------------------------------------------------

echo "[*] Setting default applications..."
kwriteconfig6 --file kdeglobals --group "General" --key "BrowserApplication" "brave-browser.desktop"
kwriteconfig6 --file kdeglobals --group "General" --key "TerminalApplication" "alacritty"
kwriteconfig6 --file kdeglobals --group "General" --key "TerminalService" "Alacritty.desktop"

# -------------------------------------------------

echo "[*] Pinning applications to task manager..."
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
	--group "Containments" \
	--group "2" \
	--group "Applets" \
	--group "5" \
	--group "Configuration" \
	--group "General" \
	--key "launchers" "applications:systemsettings.desktop,applications:Alacritty.desktop,preferred://filemanager,applications:brave-browser.desktop,applications:org.gnome.Meld.desktop"

# -------------------------------------------------

echo "[*] Setting application settings..."
kwriteconfig6 --file yakuakerc --group "Appearance" --key "Skin" "arc-dark"
kwriteconfig6 --file yakuakerc --group "Dialogs" --key "FirstRun" false
kwriteconfig6 --file yakuakerc --group "Window" --key "KeepAbove" false

kwriteconfig6 --file konsolerc --group "Desktop Entry" --key "DefaultProfile" "AbS.profile"
kwriteconfig6 --file konsolerc --group "General" --key "ConfigVersion" 1
kwriteconfig6 --file konsolerc --group "MainWindow" --key "ToolBarsMovable" Disabled

# --------------------------------------------------

echo "[*] Installing Plasma dotfiles..."
cp -rf "${CURRENT_DIR}"/Personal/settings/plasma/.config ~/
cp -rf "${CURRENT_DIR}"/Personal/settings/plasma/.local ~/
sudo cp -rf "${CURRENT_DIR}"/Personal/settings/plasma/usr /

# --------------------------------------------------

echo
tput setaf 2
echo "######################################################################################################"
echo "################# Done"
echo "######################################################################################################"
tput sgr0
echo