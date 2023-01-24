#!/bin/bash

#Installs basic utilities
sudo pacman -S xf86-video-fdev xorg xorg-init -y
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.xinitrc /home/adam/.xinitrc

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

#moves config files to proper directory
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/joshuto/joshuto.toml ~/.config/joshuto/joshuto.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/joshuto/bookmarks.toml ~/.config/joshuto/bookmarks.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/joshuto/mimetype.toml ~/.config/joshuto/mimetype.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/joshuto/keymap.toml ~/.config/joshuto/keymap.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/joshuto/theme.toml ~/.config/joshuto/theme.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/leftwm/themes.toml ~/.config/leftwm/themes.toml
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config/leftwm/config.ron ~/.config/leftwm/config.ron

#removes config files after they have been copied over.
rm -rf ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config

#paru -S lightdm --no-confirm
#sudo systemctl enable lightdm
#Installs terminal utilities
sudo pacman -S alacritty -y
sudo paru -S joshuto -y

git clone https://aur.archlinux.org/amp.git
cd amp
makepkg -isr
cd ../

#Installs additional apps
paru -S brave-bin spotify kmail-git protonmail-bridge -y