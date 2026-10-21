#!/bin/bash

MYPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$MYPATH/xprofile.sh" ~/.xprofile
ln -sf "$MYPATH/.Xresources" ~/.Xresources

# gpu: AMD Radeon RX 9070 XT (RDNA4, needs kernel >= 6.13 and mesa >= 25.0)
sudo pacman -S --needed --noconfirm \
  linux-firmware-amdgpu \
  mesa lib32-mesa \
  vulkan-radeon lib32-vulkan-radeon \
  vulkan-tools mesa-utils \
  amdgpu_top
