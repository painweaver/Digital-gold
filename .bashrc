# ~/.bashrc
#
# export TERM=urxvt

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

safe_term=${TERM//[^[:alnum:]]/?}

eval $(dircolors -b ~/.dir_colors)

archey3

alias ls='ls --color=auto'

PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[0;33m\]\w\[\e[m\] \[\e[0;32m\]\$\[\e[m\]'


man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
