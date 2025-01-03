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

if hash dotnet 2>/dev/null; then
  export DOTNET_ROOT=/usr/share/dotnet
  export MSBuildSDKsPath=$DOTNET_ROOT/sdk/$(${DOTNET_ROOT}/dotnet --version)/Sdks
  export PATH="${PATH}:${DOTNET_ROOT}:~/.dotnet/tools"
fi

export PATH=$PATH:/home/mastermindzh/bin
