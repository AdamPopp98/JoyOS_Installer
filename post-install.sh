#!/bin/bash

# Variables
default_theme="Ascent"
root_pswd=$1
non_root_username=$2
non_root_pswd=$3
installer_repo="https://raw.githubusercontent.com/AdamPopp98/JoyOS_Post_Install_Script/main"
admin_users="sys_admins"

set_makepkg_config()
{
    mkdir /home/packages
    chgrp $admin_users /home/packages
    chmod 775 /home/packages
    
    mkdir /home/pkgsrc
    chgrp $admin_users /home/pkgsrc
    chmod 775 /home/pkgsrc
    
    mkdir /home/pkglogs
    chgrp $admin_users /home/pkglogs
    chmod 555 /home/pkglogs
    
    curl "$installer_repo"/.config/makepkg.conf > /etc/makepkg.conf
}

create_new_user()
{
    cd /
    groupadd $admin_users
    (echo "$root_pswd"; echo "$root_pswd") | passwd
    useradd -m $non_root_username
    (echo "$non_root_pswd"; echo "$non_root_pswd") | passwd $non_root_username
    usermod -aG $admin_users,wheel,audio,video,optical,storage $non_root_username
    usermod -aG $admin_users root
    curl "$installer_repo"/.config/sudoers > /etc/sudoers
    cd ~
}

install_packages()
{
    install_pacman_packages
    install_aur_packages
}

install_pacman_packages()
{
    #pacman -Syu --noconfirm git
    curl "$installer_repo"/package_lists/pacman-packages.csv > ~/pacman-packages.csv
    while IFS=, read -r package_name;
    do
        sudo pacman -S --noconfirm $package_name;
    done < ~/pacman-packages.csv
    rm ~/pacman-packages.csv
}

install_aur_packages()
{
    cd /home/packages
    sudo pacman -S --needed --noconfirm base-devel
    git clone https://aur.archlinux.org/paru.git
    git clone https://aur.archlinux.org/amp.git
    (cd /home/packages/paru
    echo "$non_root_pswd" | sudo -u $non_root_username makepkg -si)
    echo "paru installed"
    sleep 3
    (cd /home/packages/amp
    echo "$non_root_pswd" | sudo -u $non_root_username makepkg -isr)
    echo "amp installed"
    sleep 3
    cd ~
    curl "$installer_repo"/package_lists/aur-packages.csv > ~/aur-packages.csv
    while IFS=, read -r package_name
    do
        echo "$non_root_pswd" | sudo -u $non_root_username paru -S --noconfirm $package_name;
    done < ~/aur-packages.csv
    rm ~/aur-packages.csv
}

#Installs basic utilities
create_new_user
set_makepkg_config
install_packages

#create directories for config files
mkdir ~/.config
curl "$installer_repo"/leaf-logo.png > ~/.config/JoyOS-Logo.png

mkdir ~/.config/alacritty
curl "$installer_repo"/.config/alacritty/alacritty.yml > ~/.config/alacritty/alacritty.yml

mkdir ~/.config/joshuto
curl "$installer_repo"/.config/joshuto/joshuto.toml > ~/.config/joshuto/joshuto.toml
curl "$installer_repo"/.config/joshuto/bookmarks.toml > ~/.config/joshuto/bookmarks.toml
curl "$installer_repo"/.config/joshuto/mimetype.toml > ~/.config/joshuto/mimetype.toml
curl "$installer_repo"/.config/joshuto/theme.toml > ~/.config/joshuto/theme.toml
curl "$installer_repo"/.config/joshuto/keymap.toml > ~/.config/joshuto/keymap.toml

mkdir ~/.config/leftwm
#curl "$installer_repo"/.config/leftwm/themes.toml > ~/.config/leftwm/themes.toml
curl "$installer_repo"/.config/leftwm/config.ron > ~/.config/leftwm/config.ron

#Installs display manager, window manager and compositor
leftwm-theme update
leftwm-theme install "$default_theme"
leftwm-theme apply "$default_theme"
#leftwm-config -n # Generate new config

#clear
echo "Clearing bash history to remove stored passwords"
history -c
echo "installation complete!"
jp2a --colors ~/.config/JoyOS-Logo.png; figlet -w 87 "Welcome To JoyOS"
#paru -S lightdm --no-confirm
#sudo systemctl enable lightdm
#Installs terminal utilities