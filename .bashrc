alias gvim="vim.gnome -g"
# alias vim="vim.gnome"
alias q=exit
alias screenoff="xset dpms force off"
alias open="gnome-open"
alias temp="cat /sys/class/thermal/thermal_zone0/temp"
alias f=fg
alias tree="tree -A"
alias tmux="tmux -2"
alias ls="ls --color=auto"
alias syncgit="rsync -avz --exclude='/.git' --filter=\"dir-merge,- .gitignore\""

export PATH=~/.local/bin:~/programming/eclipse:$PATH
export PS1="\[\e[1;34m\]\h\[\em\]:\[\e[1;35m\]\A\[\em\]:\[\e[1;32m\]\w\[\e[m\]\[\e[0;36m\]$\[\e[m\] "

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
# export FZF_DEFAULT_OPTS=-e

# https://mg.pov.lt/blog/bash-prompt.html
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

    # Show the currently running command in the terminal title:
    # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
    show_command_in_title_bar()
    {
        case "$BASH_COMMAND" in
            *\033]0*)
                # The command is trying to set the title bar as well;
                # this is most likely the execution of $PROMPT_COMMAND.
                # In any case nested escapes confuse the terminal, so don't
                # output them.
                ;;
            *)
                echo -ne "\033]0;${BASH_COMMAND}\007"
                ;;
        esac
    }
    trap show_command_in_title_bar DEBUG
    ;;
*)
    ;;
esac

HISTSIZE=5000
HISTCONTROL=ignoredups

# Remove (base) when using conda
PS1="$(echo $PS1 | sed 's/(base) //') "

shopt -s globstar
