#!/bin/bash

#Installs basic utilities
sudo pacman -S xf86-video-fdev xorg xorg-init -y

#Sets up Arch User Repository
sudo pacman -S --needed base-devel - y
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ../


#create directories for config files
mkdir ~/.config

mkdir ~/.config/alacritty
touch ~/.config/alacritty/alacritty.yml

mkdir ~/.config/joshuto
touch ~/.config/joshuto/joshuto.toml
touch ~/.config/joshuto/bookmarks.toml
touch ~/.config/joshuto/mimetype.toml
touch ~/.config/joshuto/theme.toml
touch ~/.config/joshuto/keymap.toml

mkdir ~/.config/leftwm
touch ~/.config/leftwm/config.ron
touch ~/.config/leftwm/themes.toml

#Installs display manager, window manager and compositor
sudo pacman -S leftwm leftwm-theme picom -y
leftwm-theme update
leftwm-theme install "Ascent"
leftwm-theme apply "Ascent"
leftwm-config -n # Generate new config
#paru -S lightdm --no-confirm
#sudo systemctl enable lightdm
#Installs terminal utilities
sudo pacman -S alacritty
sudo paru -S joshuto

git clone https://aur.archlinux.org/amp.git
cd amp
makepkg -isr
cd ../

#Installs additional apps
paru -S brave-bin spotify kmail-git protonmail-bridge