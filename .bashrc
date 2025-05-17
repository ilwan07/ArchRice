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
alias pls='sudo'
alias please='sudo $(fc -ln -1)'  # Execute last command with sudo
alias update='sudo pacman -Syyu && yay -Syyu'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias yayclean='yay -Yc && yay -Sc --noconfirm'
