##########################################################
# taketin's .zshrc                                       #
#                    __                                  #
#  ____     _____   / /_     _____   _____               #
# /_  /    / ___/  / __ \   / ___/  / ___/               #
#  / /_   (__  )  / / / /  / /     / /__                 #
# /___/  /____/  /_/ /_/  /_/      \___/                 #
#                                                        #
##########################################################

## Exclude for duplicate path
#
typeset -U path cdpath fpath manpath

## Path for sudo
#
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))

## Path
#
path=(~/.bin(N-/) /usr/local/bin(N-/) ${path})

## Environment variable configuration
##
## LANG
##
export LANG=ja_JP.UTF-8

## Editor
#
export EDITOR='vim'

## Zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# theme (https://github.com/sindresorhus/pure#zplug)
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

# syntax highlight (https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history
zplug "zsh-users/zsh-history-substring-search"
# type completion
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load --verbose

# Git setting
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight

# Go Setting
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin

# Haskell Setting
export PATH=$PATH:$HOME/Library/Haskell/bin

# node.js settings
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

# Homebrew cask settings
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# import alias setting
if [ -f $HOME/.zsh_aliases ]; then
    . $HOME/.zsh_aliases
fi

if [ -f $HOME/.zsh_aliases_local ]; then
    . $HOME/.zsh_aliases_local
fi

# setting to terminal_notifier for mac osx
if [ -f $HOME/.zsh.d/zsh-notify/notify.plugin.zsh ]; then
    autoload -Uz add-zsh-hook
    source ~/.zsh.d/zsh-notify/notify.plugin.zsh
    export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
    export NOTIFY_COMMAND_COMPLETE_TIMEOUT=30
fi

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
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## Completion configuration
#
autoload -U compinit
compinit

source ~/.bin/anyenv.zsh
source ~/.bin/tmuxinator.zsh

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

function git-root() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `pwd`/`git rev-parse --show-cdup`
  fi
}

#cdr

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

typeset -ga chpwd_functions

autoload -U chpwd_recent_dirs cdr
chpwd_functions+=chpwd_recent_dirs
zstyle ":chpwd:*" recent-dirs-max 500
zstyle ":chpwd:*" recent-dirs-default true
zstyle ":completion:*" recent-dirs-insert always

# tmux

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# setting for peco

function exists { which $1 &> /dev/null }

if exists peco; then
    _peco_mdfind() {
      open $(mdfind -onlyin ~/ -name $@ | peco)
    }

    function peco-select-history() {
        local tac
            if which tac > /dev/null; then
                tac="tac"
            else
                tac="tail -r"
            fi
            BUFFER=$(fc -l -n 1 | \
                     eval $tac | \
                     peco --query "$LBUFFER")
            CURSOR=$#BUFFER
            zle clear-screen
    }
    zle -N peco-select-history
    bindkey '^r' peco-select-history

    if exists ghq; then
        function peco-ghq () {
            local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
            if [ -n "$selected_dir" ]; then
                BUFFER="cd ${selected_dir}"
                zle accept-line
            fi
            zle clear-screen
        }
        zle -N peco-ghq
        bindkey '^]' peco-ghq
    fi

    if exists cdr; then
        function peco-cdr () {
            local selected_dir=$(cdr -l | awk '{ print $2 }' | peco --query "$LBUFFER")
            if [ -n "$selected_dir" ]; then
                BUFFER="cd ${selected_dir}"
                zle accept-line
            fi
            zle clear-screen
        }
        zle -N peco-cdr
        bindkey '^z' peco-cdr
    fi

    if exists git; then
        function peco-git-worktree () {
            local selected_dir=$(git worktree list | awk '{ print $1}' | peco --query "$LBUFFER")
            if [ -n "$selected_dir" ]; then
                BUFFER="cd ${selected_dir}"
                zle accept-line
            fi
        }
        zle -N peco-git-worktree
        bindkey '^@' peco-git-worktree
    fi

    function peco-pkill() {
      for pid in `ps aux | peco | awk '{ print $2 }'`
      do
        kill $pid
        echo "Killed ${pid}"
      done
    }

    function search-document-by-peco(){
        DOCUMENT_DIR="\
          $HOME/work
          $HOME/dotfiles
          $HOME/Dropbox
          $HOME/Downloads
          $HOME/Documents
          $HOME/Desktop
        "
        SELECTED_FILE=$(echo $DOCUMENT_DIR | xargs -I {} find {} -type d \( -name '.git' \) -prune -o -print | \
            egrep -v "\.(gif|jpg|jpeg|png|img|wav|mp3|mpeg|mpeg4|dmg|xls|xlsx|ppt|word|pdf)$" | peco)
        if [ $? -eq 0 ]; then
            vi $SELECTED_FILE
        fi
    }
    zle -N search-document-by-peco
    bindkey '^[' search-document-by-peco

    function peco-cdr () {
        local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-cdr
    bindkey '^xr' peco-cdr

	function peco-github-prs () {
		local pr=$(hub issue 2> /dev/null | grep 'pull' | peco --query "$LBUFFER" | sed -e 's/.*( \(.*\) )$/\1/')
		if [ -n "$pr" ]; then
			BUFFER="open ${pr}"
			zle accept-line
		fi
		zle clear-screen
	}
	zle -N peco-github-prs
	bindkey '^P' peco-github-prs

	function peco-select-gitadd() {
		local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
									  peco --query "$LBUFFER" | \
									  awk -F ' ' '{print $NF}')"
		if [ -n "$SELECTED_FILE_TO_ADD" ]; then
		  BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
		  CURSOR=$#BUFFER
		fi
		zle accept-line
		# zle clear-screen
	}
	zle -N peco-select-gitadd
	bindkey "^g^a" peco-select-gitadd

fi

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/FKST14573/.gvm/bin/gvm-init.sh" ]] && source "/Users/FKST14573/.gvm/bin/gvm-init.sh"

[[ -s "/Users/ST14573/.gvm/scripts/gvm" ]] && source "/Users/ST14573/.gvm/scripts/gvm"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"
