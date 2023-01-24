#!/bin/bash

#Installs basic utilities
sudo pacman -S xf86-video-fdev xorg xorg-init --no-confirm

#Sets up Arch User Repository
sudo pacman -S --needed base-devel --no-confirm
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --no-confirm
cd ../

#Installs display manager, window manager and compositor
sudo pacman -S leftwm leftwm-theme picom --no-confirm
#paru -S lightdm --no-confirm
#sudo systemctl enable lightdm
#Installs terminal utilities
sudo pacman -S alacritty --no-confirm
sudo paru -S joshuto

git clone https://aur.archlinux.org/amp.git
cd amp
makepkg -isr
cd ../

#Installs additional apps
paru -S brave-bin spotify kmail-git protonmail-bridge --no-confirm