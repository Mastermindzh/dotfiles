#
# ~/.bashrc
#

function _update_ps1() {
    PS1=$(powerline-shell $?)
}

source ~/.alias
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval $(thefuck --alias)

#... :P fancy stuffs
screenfetch -t -A "UBUNTU"
PS1='[\u@\h \W]\$ '

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
