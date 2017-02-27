alias gvim="vim.gnome -g"
# alias vim="vim.gnome"
alias q=exit
alias screenoff="xset dpms force off"
alias open="gnome-open"
alias temp="cat /sys/class/thermal/thermal_zone0/temp"
alias f=fg
alias tree="tree -A"
alias tmux="tmux -2"

export PATH=$PATH:~/.local/bin:~/programming/eclipse
export PS1="\[\e[1;34m\]\h\[\em\]:\[\e[1;35m\]\A\[\em\]:\[\e[1;32m\]\w\[\e[m\]\[\e[0;36m\]$\[\e[m\] "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS=-e
