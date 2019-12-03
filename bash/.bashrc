# if powerline-shell is available use it.
function _update_ps1() {
    if hash powerline-shell 2>/dev/null; then
        PS1=$(powerline-rs --shell bash $?)
    fi
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.alias
source ~/.custom
source ~/.variables
source ~/lib/azure-cli/az.completion

# evals
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#... :P fancy stuffs
#screenfetch -t -A "UBUNTU"
neofetch
PS1='[\u@\h \W]\$ '

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

export PATH=$PATH:/home/mastermindzh/bin
