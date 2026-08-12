#!/bin/bash

MYPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$MYPATH/xprofile.sh" ~/.xprofile
ln -sf "$MYPATH/.Xresources" ~/.Xresources
