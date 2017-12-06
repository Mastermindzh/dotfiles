#
# ~/.bashrc
#

source ~/.alias
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


alias ls='ls --color=auto'

eval $(thefuck --alias)

#... :P fancy stuffs
screenfetch -t -A "UBUNTU"
PS1='[\u@\h \W]\$ '

