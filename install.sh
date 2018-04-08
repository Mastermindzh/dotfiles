#!/bin/bash

# =======================================
# Functions
# =======================================

# Ask a question and return true or false based on the users input
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

# moves all fonts into the fonts directories (overwriting existing files)
function install_fonts {
	mkdir -p ~/.fonts
	mkdir -p ~/.local/share/fonts
	yes | cp -rf ./fonts/* ~/.fonts
	yes | cp -rf ./fonts/* ~/.local/share/fonts
}

# Link basic rice files
function install_rice {
	mkdir -p ~/Pictures/Wallpapers
	ln -sf "$PWD"/wallpapers/wallpaper.jpeg ~/Pictures/Wallpapers/wallpaper.jpg
	ln -sf "$PWD"/i3/ ~/.config/i3
}

# install other configs
function install_config {
	rm ~/.notify-osd 
	ln -sf "$PWD"/notify-osd/notify-osd ~/.notify-osd
	ln -sf "$PWD"/bash/.bashrc ~/.bashrc
	ln -sf "$PWD"/bash/.alias.sh ~/.alias
	ln -sf "$PWD"/nano/.nanorc ~/.nanorc
	mkdir -p ~/.config/gtk-3.0
	ln -sf "$PWD"/config/gtk-3.0/settings.ini ~/.config/gtk-3.0/.config
}

# Symlinks the file templates in the ~/Templates directory.
function install_file_templates {
	ln -sf "$PWD"/templates ~/Templates
}

# Installs the dependencies on Arch Linux
function install_dependencies {
	sudo pacman --force -S $(cat dependencies/pacman.txt | sed ':a;N;$!ba;s/\n/ /g')
	yaourt --force -S --noconfirm $(cat dependencies/aur.txt | sed ':a;N;$!ba;s/\n/ /g')
	sudo pip install $(cat dependencies/pip.txt | sed ':a;N;$!ba;s/\n/ /g')
}

# list the dependencies file
function list_dependencies {
	echo ""
	echo "=========================="
	echo ""
	cat dependencies/pacman.txt
	cat dependencies/aur.txt
	cat dependencies/pip.txt
	echo ""
	echo "=========================="	
	echo ""
}

# Run the intro bit
function intro {
	echo "This will install my i3rice".
}


# =======================================
# Main loop
# =======================================

# Run the intro function
intro

yes_or_no "Do you want to continue?" &&

# Ask for dependency installation
list_dependencies
yes_or_no "Do you want to install the list of applications above? (might prompt for password)" && install_dependencies

# Ask for config installation
yes_or_no "Do you want to install the config files?" && install_config

# Ask for font installation
yes_or_no "Do you want to install the fonts?" && install_fonts

# Ask for template file installation
yes_or_no "Do you want to install the file templates? (~/Templates)" && install_file_templates

# Ask the user whether it wants to continue
yes_or_no "Are you sure you want to install my i3 rice?" && install_rice

# ask to enable gdm
yes_or_no "Do you want to enable GDM?" && sudo systemctl enable gdm.service

echo "Enjoy using my ricing! Do not forget to select \"i3\" in GDM :)"