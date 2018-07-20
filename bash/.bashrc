#
# ~/.bashrc
#

function _update_ps1() {
    if hash powerline-shell 2>/dev/null; then
        PS1=$(powerline-shell $?)
    fi
}

source ~/.alias
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.custom

# Fix .netcore paths if dotnet is installed
if hash dotnet 2>/dev/null; then
    export PATH="$PATH:~/.dotnet/tools"
    export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))
fi


#... :P fancy stuffs
#screenfetch -t -A "UBUNTU"
neofetch
PS1='[\u@\h \W]\$ '

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
