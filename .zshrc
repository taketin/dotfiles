##########################################################
# taketin's .zshrc                                       #
#                    __                                  #
#  ____     _____   / /_     _____   _____               #
# /_  /    / ___/  / __ \   / ___/  / ___/               #
#  / /_   (__  )  / / / /  / /     / /__                 #
# /___/  /____/  /_/ /_/  /_/      \___/                 #
#                                                        #
##########################################################


# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Export Path
export PATH=$PATH:/Applications/MacVim.app/Contents/MacOS/:/usr/local/share/npm/bin:$HOME/node_modules/.bin
export NODE_PATH=/usr/local/lib/node

## Environment variable configuration
##
## LANG
##
export LANG=ja_JP.UTF-8

## Pronpt Theme
export ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git)
source $ZSH/oh-my-zsh.sh

# import alias setting
if [ -f $HOME/.zsh_aliases ]; then
    . $HOME/.zsh_aliases
fi

#
## Default shell configuration
##
## set prompt
##
#case ${UID} in
#0)
#   PROMPT="%B%{[31m%}%/#%{[m%}%b "
#  PROMPT2="%B%{[31m%}%_#%{[m%}%b "
#   SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
#  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#       PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#  ;;
#  *)
#   PROMPT="%{[31m%}%/%%%{[m%} "
#  PROMPT2="%{[31m%}%_%%%{[m%} "
# SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
#  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#     PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
#;;
# esac

# color setting
export GREP_COLOR='07;37;40'
export GREP_OPTIONS='--color=auto'

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no beep sound when complete list displayed
#
setopt nolistbeep

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes 
#   to end of it)
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## incremental-pattern-search
#
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## Completion configuration
#
autoload -U compinit
compinit

# cdd
#
# @see http://d.hatena.ne.jp/secondlife/20080218/1203303528
#
source ~/.zsh/cdd

function chpwd() {
    _reg_pwd_screennum
}

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm)
	precmd() {
		echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	}
	;;
esac

# nvm setting
if [ -f $HOME/.node ]; then
    ~/.node/nvm.sh
    nvm use v0.7.5
fi

# rbenv setting
eval "$(rbenv init -)"

# commandline to clipboard copy
pbcopy-buffer(){ 
    print -rn $BUFFER | pbcopy
    zle -M "pbcopy: ${BUFFER}" 
}

zle -N pbcopy-buffer
bindkey '^x^p' pbcopy-buffer
