#!/bin/bash

# Variables
default_theme="Ascent"
root_pswd=$1
non_root_username=$2
non_root_pswd=$3
installer_repo="https://raw.githubusercontent.com/AdamPopp98/JoyOS_Post_Install_Script/main"

create_new_user()
{
    cd /
    echo "$root_pswd" | passwd --stdin
    useradd -m $non_root_username
    echo "$non_root_pswd" | passwd $non_root_username --stdin
    cd ~
}

install_pacman_packages()
{
    pacman -Syu git
    while IFS=, read -r package_name;
    do
        sudo pacman -S --noconfirm $package_name;
    done < package_lists/pacman-packages.csv
}

install_aur_packages()
{
    sudo pacman -S --needed --noconfirm base-devel
    
    #mkdir /home/build
    #chmod g+ws /home/build
    #setfacl -m u::rwx,g::rwx /home/build
    #setfacl -d --set u::rwx,g::rwx,o::- /home/build
    
    #cd /home/build
    cd ~
    git clone https://aur.archlinux.org/paru.git
    git clone https://aur.archlinux.org/amp.git
    cd paru
    echo "$non_root_pswd" | sudo -u $non_root_username makepkg -si
    cd ~/amp
    echo "$non_root_pswd" | sudo -u $non_root_username makepkg -isr
    cd ~

    while IFS=, read -r package_name
    do
        sudo paru -S --noconfirm $package_name;
    done < package_lists/aur-packages.csv
}

#Installs basic utilities
create_new_user
install_pacman_packages
install_aur_packages

#create directories for config files
mkdir ~/.config
curl "$installer_repo"/leaf-logo.png -o ~/.config/JoyOS-Logo.png

mkdir ~/.config/alacritty
curl "$installer_repo"/.config/alacritty/alacritty.yml -o ~/.config/alacritty/alacritty.yml

mkdir ~/.config/joshuto
curl "$installer_repo"/.config/joshuto/joshuto.toml -o ~/.config/joshuto/joshuto.toml
curl "$installer_repo"/.config/joshuto/bookmarks.toml -o ~/.config/joshuto/bookmarks.toml
curl "$installer_repo"/.config/joshuto/mimetype.toml -o ~/.config/joshuto/mimetype.toml
curl "$installer_repo"/.config/joshuto/theme.toml -o ~/.config/joshuto/theme.toml
curl "$installer_repo"/.config/joshuto/keymap.toml -o ~/.config/joshuto/keymap.toml

mkdir ~/.config/leftwm
curl "$installer_repo"/.config/leftwm/themes.toml -o ~/.config/leftwm/themes.toml
curl "$installer_repo"/.config/leftwm/config.ron -o ~/.config/leftwm/config.ron

#Installs display manager, window manager and compositor
leftwm-theme update
leftwm-theme install "$default_theme"
leftwm-theme apply "$default_theme"
leftwm-config -n # Generate new config

#removes config files after they have been copied over.
rm -rf ~/JoyOS_Post_Install_Script/JoyOS_Post_Install_Script/.config
clear
echo "Clearing bash history to remove stored passwords"
history -c
echo "installation complete!\n\n"
jp2a --colors ~/.config/JoyOS-Logo.png; figlet -w 87 "Welcome To JoyOS"
#paru -S lightdm --no-confirm
#sudo systemctl enable lightdm
#Installs terminal utilities