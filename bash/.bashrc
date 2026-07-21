#!/bin/bash

# sourceIfExists
function sourceIfExists() {
  [[ -f "$1" ]] && source "$1"
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.alias
source ~/.custom
source ~/.variables

sourceIfExists ~/.env
sourceIfExists /usr/share/nvm/init-nvm.sh
sourceIfExists ~/lib/azure-cli/az.completion
eval "$(thefuck --alias)"
eval "$(oh-my-posh init bash --config ~/.config/poshthemes/mastermindzh.yaml)"

# load keychain with private key
if test -f "$HOME/.ssh/id_ed25519"; then
  eval "$(keychain --eval --quiet ~/.ssh/id_ed25519)"
else
  # fallback to older rsa
  eval "$(keychain --eval --quiet ~/.ssh/id_rsa)"
fi

eval "$(pyenv init -)"

export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
export PATH=$PATH:/home/mastermindzh/bin
export TERM=xterm-256color

. "$HOME/.local/bin/env"
