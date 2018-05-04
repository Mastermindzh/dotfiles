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

eval $(thefuck --alias)

#... :P fancy stuffs
#screenfetch -t -A "UBUNTU"
neofetch
PS1='[\u@\h \W]\$ '

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
