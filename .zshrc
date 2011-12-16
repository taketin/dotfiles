# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

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
# source $ZSH/oh-my-zsh.sh

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

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm)
	precmd() {
		echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
	}
	;;
esac