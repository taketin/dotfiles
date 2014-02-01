##########################################################
# taketin's .zshrc                                       #
#                    __                                  #
#  ____     _____   / /_     _____   _____               #
# /_  /    / ___/  / __ \   / ___/  / ___/               #
#  / /_   (__  )  / / / /  / /     / /__                 #
# /___/  /____/  /_/ /_/  /_/      \___/                 #
#                                                        #
##########################################################


## Path to your oh-my-zsh configuration.
#
ZSH=$HOME/.oh-my-zsh

## Export Path
#
export PATH=$PATH:/usr/local/bin:$HOME/bin:/Applications/MacVim.app/Contents/MacOS/:/usr/local/share/npm/bin:$HOME/node_modules/.bin

## Environment variable configuration
##
## LANG
##
export LANG=ja_JP.UTF-8

## zsh-completions
#

fpath=(~/.zsh-completions $fpath)

## Pronpt Theme
#
export ZSH_THEME="robbyrussell"

## Editor
#
export EDITOR='vim'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git)
source $ZSH/oh-my-zsh.sh

# import alias setting
if [ -f $HOME/.zsh_aliases ]; then
    . $HOME/.zsh_aliases
fi

if [ -f $HOME/.zsh_aliases_local ]; then
    . $HOME/.zsh_aliases_local
fi

# setting to terminal_notifier for mac osx
if [ -f $HOME/.zsh.d/zsh-notify/notify.plugin.zsh ]; then
    source ~/.zsh.d/zsh-notify/notify.plugin.zsh
    export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
    export NOTIFY_COMMAND_COMPLETE_TIMEOUT=30
fi

# Source Prezto.
# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi


# # git stash count
# function git_prompt_stash_count {
#   local COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
#   if [ "$COUNT" -gt 0 ]; then
#     echo " ($COUNT)"
#   fi
# }

# setopt prompt_subst
# autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
# 
# function rprompt-git-current-branch {
#   local name st color action
# 
#   if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
#     return
#   fi
# 
#   name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
#   if [[ -z $name ]]; then
#     return
#   fi
# 
#   st=`git status 2> /dev/null`
#   if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
#     color=${fg[blue]}
#   elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
#     color=${fg[yellow]}
#   elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
#     color=${fg_bold[red]}
#   else
#     color=${fg[red]}
#   fi
# 
#   gitdir=`git rev-parse --git-dir 2> /dev/null`
#   action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
# 
#   # %{...%} surrounds escape string
#   echo "%{$color%}$name$action`git_prompt_stash_count`$color%{$reset_color%}"
# }

# how to use
# PROMPT='`rprompt-git-current-branch`'


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

# command setting
export LESS='-R'

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

# nodebrew setting
if [ -f ~/.nodebrew/nodebrew ]; then
    export NODE_PATH=/usr/local/lib/node
    export PATH=$HOME/.nodebrew/current/bin:$PATH
    # nodebrew use v0.7.7
fi

# nvm setting
if [ -d ~/.node ]; then
    ~/.node/nvm.sh
    # nvm use v0.7.5
fi

if [ -d ~/.rbenv ]; then
    export PATH=$HOME/.rbenv/versions/1.9.3-p125/bin:$HOME/.rbenv/versions/1.9.2-p290/bin:$PATH
    eval "$(rbenv init -)"
fi

# commandline to clipboard copy
pbcopy-buffer(){ 
    print -rn $BUFFER | pbcopy
    zle -M "pbcopy: ${BUFFER}" 
}

zle -N pbcopy-buffer
bindkey '^x^p' pbcopy-buffer

# autojump
if [ -f `brew --prefix`/etc/autojump ]; then
    . `brew --prefix`/etc/autojump
fi

# z
. `brew --prefix`/etc/profile.d/z.sh
function precmd () {
   z --add "$(pwd -P)"
}

# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator


# cache for rake routes
function routes_cache {
    local routes_cache; routes_cache="./tmp/routes_cache"
    if [ "$1" = "--force" ]; then
        rm $routes_cache;
    fi
    if ! [ -e $routes_cache ]; then
        bundle exec rake routes > $routes_cache
    fi
    cat $routes_cache
}
