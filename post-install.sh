#!/bin/bash

# Variables
default_theme="Ascent"
root_pswd=$1
non_root_username=$2
non_root_pswd=$3
#install_script_repo="https://github.com/AdamPopp98/JoyOS_Post_Install_Script"

create_new_user()
{
    cd /
    passwd
    echo "$root_pswd"
    echo "$root_pswd"
    useradd -m $non_root_username
    passwd $non_root_username
    echo "$non_root_pswd"
    echo "$non_root_pswd"
    cd ~
}

install_pacman_packages()
{
    while IFS=, read -r package_name;
    do
        sudo pacman -S --noconfirm $package_name;
    done < package_lists/pacman-packages.csv
}

install_aur_packages()
{
    sudo pacman -S --needed --noconfirm base-devel
    
    mkdir /home/build
    chgrp nobody /home/build
    chmod g+ws /home/build
    setfacl -m u::rwx,g::rwx /home/build
    setfacl -d --set u::rwx,g::rwx,o::- /home/build
    
    cd /home/build
    git clone https://aur.archlinux.org/paru.git
    git clone https://aur.archlinux.org/amp.git
    cd paru
    sudo -u nobody makepkg -si
    cd ../amp
    sudo -u nobody makepkg makepkg -isr
    cd ~/JoyOS_Post_Install_Script

    while IFS=, read -r package_name
    do
        sudo paru -S --noconfirm $package_name;
    done < package_lists/aur-packages.csv
}

#Installs basic utilities
create_new_user
install_pacman_packages
install_aur_packages
cp ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.xinitrc /home/adam/.xinitrc
rm ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.xinitrc


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