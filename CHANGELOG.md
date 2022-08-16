# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to date versioning.

## [2022-08-03]

- Fixed i3lock re-using the last image
- Set up /etc/environment sharing
- Added in greenclip again
- added after install and syncLocalSettings.json

## [2022-07-26]

- Added `vers=2.1` to `mount.cifs` command in [mounts.sh](./bash/mounts.sh) to fix an [upstream bug](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.18.y&id=ca83f50b43a099345e61950f74c4d9eb81c765fe)
- Added a `clean-all` command to clean trash of my hard drives
