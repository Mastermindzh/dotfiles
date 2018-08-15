#/bin/bash

MYPATH=$PWD/computers/work-xps

# set up hiDPI
sudo ln -sf "$MYPATH/environment" /etc/environment

# set up docking
ln -sf "$MYPATH/Xresources.docked" ~/.Xresources.docked
ln -sf "$MYPATH/Xresources.undocked" ~/.Xresources.undocked
ln -sf "$MYPATH/docked.sh" ~/.docked.sh
ln -sf "$MYPATH/undocked.sh" ~/.undocked.sh
ln -sf "$MYPATH/xprofile.sh" ~/.xprofile
    
# custom (laptop specific) bashrc thingies :)    
ln -sf "$MYPATH/custom-bashrc.sh" ~/.custom