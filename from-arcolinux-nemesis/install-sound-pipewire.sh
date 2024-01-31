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
sudo pacman -R --noconfirm pipewire-media-session
sudo pacman -Rdd --noconfirm jack2
sudo pacman -Rdd --noconfirm pulseaudio-alsa
sudo pacman -Rdd --noconfirm pulseaudio-bluetooth
sudo pacman -Rdd --noconfirm pulseaudio

sudo pacman -S --noconfirm --needed pipewire
sudo pacman -S --noconfirm --needed lib32-pipewire
sudo pacman -S --noconfirm --needed pipewire-audio
sudo pacman -S --noconfirm --needed pipewire-alsa
sudo pacman -S --noconfirm --needed pipewire-pulse
sudo pacman -S --noconfirm --needed pipewire-jack
sudo pacman -S --noconfirm --needed lib32-pipewire-jack
sudo pacman -S --noconfirm --needed wireplumber
sudo pacman -S --noconfirm --needed pipewire-zeroconf
sudo pacman -S --noconfirm --needed pipewire-docs

sudo pacman -S --noconfirm gnome-bluetooth blueberry

sudo systemctl enable bluetooth.service

echo "Reboot now"
