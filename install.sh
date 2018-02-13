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

# moves all fonts into the fonts directory (overwriting existing files)
function install_fonts {
	mkdir -p ~/.fonts
	yes | cp -rf ./fonts/*.ttf ~/.fonts
}

# install basic rice files
function install_rice {
	mkdir -p ~/.config/i3
	mkdir -p ~/Pictures/Wallpapers
	cp wallpapers/wallpaper.jpeg ~/Pictures/Wallpapers/wallpaper.jpg
	yes | cp -rf i3/* ~/.config/i3
}

# install other configs
function install_config {
	rm ~/.notify-osd 
	cp -f notify-osd/notify-osd ~/.notify-osd
	cp -f ./bash/.alias.sh ~/.alias
	cp -f ./bash/.bashrc ~/
	cp -f ./nano/.nanorc ~/
	cp -rf ./config ~/.config
}

# Installs the file templates in the ~/Templates directory.
function install_file_templates {
	cp -rf ./templates/* ~/Templates
}

# Installs the dependencies on Arch Linux
function install_dependencies {
	sudo pacman --force -S $(cat dependencies/pacman.txt | sed ':a;N;$!ba;s/\n/ /g')
	yaourt --force -S --noconfirm $(cat dependencies/aur.txt | sed ':a;N;$!ba;s/\n/ /g')
}

# list the dependencies file
function list_dependencies {
	echo ""
	echo "=========================="
	echo ""
	cat dependencies/pacman.txt
	cat dependencies/aur.txt
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
