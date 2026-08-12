#!/bin/bash
MYPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sf "$MYPATH/.xprofile" ~/.xprofile
