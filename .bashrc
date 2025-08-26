#
# ~/.bashrc
#

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Custom aliases
alias pls='sudo $(fc -ln -1)'  # Execute last command with sudo
alias yayclean='yay -Yc; yay -Sc'
alias update='sudo pacman -Syyu; yay -Syu; sudo flatpak update'
alias connection='sudo nmcli connection'

# terminal-wakatime setup
export PATH="$HOME/.wakatime:$PATH"
eval "$(terminal-wakatime init)"
