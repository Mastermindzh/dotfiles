#!/bin/bash

# =======================================
# Helper functions
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

# delete target, create dirs if they don't exist yet and finally symlink the dir
function linkDir {
	rm -rf $2;
	mkdir -p "${2%/*}"
	ln -sf $1 $2
}

# replace line endings with a space (for use in package managers)
function fileToList {
    echo $(cat $1 | sed ':a;N;$!ba;s/\n/ /g')
}

# =======================================
# Installation functions
# =======================================

# moves all fonts into the fonts directories (overwriting existing files)
function install_fonts {
	mkdir -p ~/.fonts
	mkdir -p ~/.local/share/fonts
	yes | cp -rf ./fonts/* ~/.fonts
	yes | cp -rf ./fonts/* ~/.local/share/fonts
}

# install trizen, a aur helper
function install_trizen {
    git clone https://aur.archlinux.org/trizen.git
    pushd trizen
    makepkg -si
    popd
    sudo rm -dRf trizen/
}

# install other configs
function install_config {

	# link directories
	linkDir "$PWD"/wallpapers ~/Pictures/Wallpapers
	linkDir "$PWD"/i3/ ~/.config/i3
	linkDir "$PWD"/config/notify-osd/notify-osd ~/.notify-osd
	linkDir "$PWD"/config/terminal/xfce4-term ~/.config/xfce4/terminal
	linkDir "$PWD"/config/gtk-3.0/settings.ini ~/.config/gtk-3.0/.config
	linkDir "$PWD"/templates ~/Templates

	# link user files
	ln -sf "$PWD"/bash/.bashrc ~/.bashrc
	ln -sf "$PWD"/bash/.alias.sh ~/.alias
	ln -sf "$PWD"/config/nano/.nanorc ~/.nanorc
	ln -sf "$PWD"/bash/.powerline-shell.json ~/.powerline-shell.json
	ln -sf "$PWD"/wallpapers/space.jpg ~/Pictures/Wallpapers/wallpaper.jpg

	# link system files
	sudo ln -sf "$PWD"/config/package-managers/pacman.conf /etc/pacman.conf
	sudo ln -sf "$PWD"/config/package-managers/makepkg.conf /etc/makepkg.conf
	sudo ln -sf "$PWD"/config/ntp.conf /etc/ntp.conf

}

# Installs the dependencies on Arch Linux
function install_dependencies {
	fileToList dependencies/pacman.txt | xargs sudo pacman --force -S

	install_trizen
	fileToList dependencies/aur.txt | xargs trizen --force -S --noconfirm

	fileToList dependencies/pip.txt | xargs pip install
}


# =======================================
# User output functions
# =======================================

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
	echo "___  ___          _                      _           _     _     _ "
	echo "|  \/  |         | |                    (_)         | |   | |   ( )"
	echo "| .  . | __ _ ___| |_ ___ _ __ _ __ ___  _ _ __   __| |___| |__ |/ "
	echo "| |\/| |/ _\` / __| __/ _ \ '__| '_ \` _ \| | '_ \ / _' |_  / '_ \  "
	echo "| |  | | (_| \__ \ ||  __/ |  | | | | | | | | | | (_| |/ /| | | |  "
	echo "\_|  |_/\__,_|___/\__\___|_|  |_| |_| |_|_|_| |_|\__,_/___|_| |_|  "
	echo "                                                                   "
	echo "                                                                   "
	echo "                  __ _                       _                     "
	echo "                 / _(_)         ___         (_)                    "
	echo "  ___ ___  _ __ | |_ _  __ _   ( _ )    _ __ _  ___ ___            "
	echo " / __/ _ \| '_ \|  _| |/ _\` |  / _ \/\ | '__| |/ __/ _ \          "
	echo "| (_| (_) | | | | | | | (_| | | (_>  < | |  | | (_|  __/           "
	echo " \___\___/|_| |_|_| |_|\__, |  \___/\/ |_|  |_|\___\___|           "
	echo "                        __/ |                                      "
	echo "                       |___/                     "
	echo ""
}


# =======================================
# Main loop
# =======================================

# Run the intro function
intro

yes_or_no "Do you want to continue installing my config and rice?" &&

# Ask for dependency installation
list_dependencies
yes_or_no "Do you want to install the list of applications above? (might prompt for password)" && install_dependencies

# Ask for config installation
yes_or_no "Do you want to install the config files?" && install_config

# Ask for font installation
yes_or_no "Do you want to install the fonts?" && install_fonts

# ask to enable gdm
yes_or_no "Do you want to enable GDM?" && sudo systemctl enable gdm.service

echo "Enjoy using my rice! Do not forget to select \"i3\" in GDM :)"
