#!/bin/bash
# MacBook Air (2017) running Arch Linux
set -e
MY_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# i3 mod key: cmd sits where alt normally is on this keyboard, so use alt instead
ln -sf "$MY_PATH/.Xresources" ~/.Xresources
if [[ -n $DISPLAY ]]; then
  xrdb -merge ~/.Xresources
fi

# trackpad: the bcm5974 pad is unusable without tap/scroll/palm-rejection settings
sudo pacman -S --needed --noconfirm xf86-input-libinput
sudo mkdir -p /etc/X11/xorg.conf.d
sudo ln -sf "$MY_PATH/30-touchpad.conf" /etc/X11/xorg.conf.d/30-touchpad.conf

# apple keyboard: F-keys as F-keys, media keys behind fn
sudo mkdir -p /etc/modprobe.d
sudo ln -sf "$MY_PATH/hid_apple.conf" /etc/modprobe.d/hid_apple.conf
sudo mkinitcpio -P

# wifi: the BCM4360 needs the proprietary broadcom driver (same story as fedora).
# it is a dkms module, so without the kernel headers it silently never gets built.
sudo pacman -S --needed --noconfirm dkms linux-headers
trizen -S --needed --noconfirm broadcom-wl-dkms
sudo dkms autoinstall
sudo modprobe wl
sudo rfkill unblock wifi

# NetworkManager itself is installed by the base install but has to be enabled
sudo systemctl enable --now NetworkManager.service

echo "airarch installed. Reboot to load the wl and hid_apple modules."
