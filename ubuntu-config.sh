#!/bin/bash

# Some needed variables
profile_image_name=profile.png     # Located at ./resources/images/<profile_image_name>
wallpaper_image_name=wallpaper.jpg # Located at ./resources/images/<wallpaper_image_name>

user=$(whoami)

# Upgrade all packages after ubuntu installation
sudo apt-get update && sudo apt-get upgrade -y

# Set the profile picture
wget https://raw.githubusercontent.com/jromero132/ubuntu-config/master/resources/images/$profile_image_name \
    -P /home/$user/Downloads
sudo cp /home/$user/Downloads/$profile_image_name /var/lib/AccountsService/icons/$user
sudo sed -i -e "s/Icon=.*/Icon=\/var\/lib\/AccountsService\/icons\/$user/g" "/var/lib/AccountsService/users/$user"
rm /home/$user/Downloads/$profile_image_name

# # Set the background image
wget https://raw.githubusercontent.com/jromero132/ubuntu-config/master/resources/images/$wallpaper_image_name \
    -P /home/$user/Downloads
cp ./resources/images/$wallpaper_image_name /home/$user/Downloads/$wallpaper_image_name
gsettings set org.gnome.desktop.background picture-uri "file:///home/$user/Downloads/$wallpaper_image_name"

# Set the keyboard shortcuts for apps
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"                       # Browser
gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Super>c']"                # Calculator
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"                      # Home folder
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>r', '<Ctrl><Alt>t']"  # Terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>s']"            # Settings

# Set the keyboard shortcuts for music & audio
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Super>KP_6']"         # Next
gsettings set org.gnome.settings-daemon.plugins.media-keys previous "['<Super>KP_4']"     # Previous
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Super>KP_8']"    # Volume up
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Super>KP_2']"  # Volume down
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Super>KP_0']"  # Volume mute
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Super>KP_5']"         # Play/Pause
gsettings set org.gnome.settings-daemon.plugins.media-keys mic-mute "['<Super>m']"        # Mic mute

# Install curl, snapd and zsh
sudo apt-get install curl snapd zsh -y

# Make zsh the default shell
sudo chsh -s $(which zsh)

# Install oh-my-zsh
echo "y" | sh -c "$(sudo curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ./resources/config/zsh/jromero132.zsh-theme /home/$user/.oh-my-zsh/custom/themes  # Copy my custom ZSH theme
cp ./resources/config/zsh/.zshrc /home/$user                                         # Copy my custom ZSH configuration


function add_custom_keybinding {
    # Get arguments
    index="$1"
    name="$2"
    command="$3"
    binding="$4"

    # Get current custom keybindings
    custom_keybindings="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"
    if [[ $custom_keybindings == @as* ]] ; then
        custom_keybindings=${custom_keybindings:4:-1}     # Set the keybindings string to just the array
    else
        custom_keybindings="${custom_keybindings::-1}, "  # Set the keybindings string ready to add a new keybinding
    fi

    custom_keybinding="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$index/"  # new keybinding
    custom_keybindings="$custom_keybindings'$custom_keybinding']"  # Update the custom keybindings list

    # Set the new custom keybinding (index, name, command and the actual binding)
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_keybindings"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_keybinding name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_keybinding command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$custom_keybinding binding "$binding"
}

function install_Git {
    sudo apt-get install git-all -y
}

function install_VSCode {
    sudo apt-get install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg]\
        https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install code -y

    # Custom keyboard shortcut to open VSCode in current directory with super + v
    add_custom_keybinding "custom-vscode" "VSCode - open" "code ." "<Super>v"
}

function install_Spotify {
    sudo snap install spotify

    # Custom keyboard shortcut to open Spotify with super + z
    add_custom_keybinding "custom-spotify" "Spotify - open" "spotify" "<Super>z"
}

function install_Telegram {
    sudo apt install telegram-desktop -y

    # Custom keyboard shortcut to open Telegram with super + t
    add_custom_keybinding "custom-telegram" "Telegram - open" "telegram-desktop" "<Super>t"
}

function install_WhatsApp {
    sudo snap install whatsapp-for-linux

    # Custom keyboard shortcut to open WhatsApp with super + t
    add_custom_keybinding "custom-whatsapp" "WhatsApp - open" "whatsapp-for-linux" "<Super>w"
}

packages=(
    Git
    Spotify
    Telegram
    VSCode
    WhatsApp
)

# Install Git
for package in "${packages[@]}" ; do
    read -p "Do you want to install $package? (Y/n): " yn
    case $yn in
        [Nn]* ) ;;
        * ) install_$package;;
    esac
done


# Logout for all configurations to take effect
gnome-session-quit
