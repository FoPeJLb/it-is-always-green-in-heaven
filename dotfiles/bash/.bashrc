#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
export PS1="╔═\[\033[38;5;1m\][\[$(tput sgr0)\]\[\033[38;5;26m\]\w\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\n\[$(tput sgr0)\]╚═\[\033[38;5;1m\][\[$(tput sgr0)\]\[\033[38;5;34m\]\u\[$(tput sgr0)\]\[\033[38;5;104m\]@\[$(tput sgr0)\]\[\033[38;5;76m\]\h\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]═⮞ \[$(tput sgr0)\]"
