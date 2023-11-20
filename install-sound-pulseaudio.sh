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

# https://wiki.archlinux.org/title/PipeWire
# starting on an ArcoLinuxL iso
# https://wiki.archlinux.org/title/PipeWire#Bluetooth_devices

# Compare

sudo pacman -R --noconfirm gnome-bluetooth blueberry
sudo pacman -R --noconfirm pipewire-pulse
sudo pacman -R --noconfirm pipewire-alsa
sudo pacman -Rdd --noconfirm pipewire-jack
sudo pacman -R --noconfirm pipewire-media-session
sudo pacman -R --noconfirm pipewire-zeroconf
sudo pacman -Rdd --noconfirm pipewire

sudo pacman -S --noconfirm --needed pulseaudio
sudo pacman -S --noconfirm --needed pulseaudio-alsa
sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed pulseaudio-equalizer
sudo pacman -S --noconfirm --needed pulseaudio-zeroconf
sudo pacman -S --noconfirm --needed pulseaudio-jack
sudo pacman -S --noconfirm --needed jack2

sudo pacman -S --noconfirm --needed gnome-bluetooth blueberry

sudo systemctl enable bluetooth.service

echo "Reboot now"
