# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	#alias grep='grep --color=auto'
	#alias fgrep='fgrep --color=auto'
	#alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
. "$HOME/.cargo/env"



 export GHOSTTY_SHELL_INTEGRATION_NO_SUDO='0'
export SHELL='fish' # Note: Sets the variable, does not change the running shell
export SUDO_EDITOR='nvim'
export CGO_ENABLED='true' 

# Update PATH, avoiding duplicates from the original config
export PATH="$HOME/.bun/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:$HOME/go/bin:$HOME/.x-cmd.root/bin:$HOME/go/pkg/mod/github.com/spf13/cobra@v1.9.1/:$PATH"

# Key bindings using readline's bind command
# \e represents Alt/Meta. \C- represents Ctrl.
bind -x '"\ea": "ai"' 
bind -x '"\ee": "nvim"' 
bind -x '"\et": "btop"' 
bind -x '"\eo": "obsidian &"' 
bind -x '"\eh": "invoke_bash \'x --help\'"' 
bind -x '"\C-n": "navi"' 
bind -x '"\e ": "spf"'  # Alt-Space
bind -x '"\ef": "fzf"' 

# Helper function to mimic fish's `invoke_bash`
function invoke_bash() {
    bash -ci "$@" 
}

# Functions converted from fish
function wk() { cd "$HOME/workspace/"; }
function cron() { crontab "$@"; }
function rc() { cd "$HOME/sources/"; }
function xx() { exit 0; }
function vig() { nvim "$GHOSTTYRC"; }
function ai() { ollama run qwen2.5-coder:1.5b; }
function vif() { nvim "$HOME/.config/fish/config.fish"; }
function vicron() { nvim "$HOME/.config/.routines/"; }
function manx() { invoke_bash "x --help"; } 
function lsx() { invoke_bash "x ls $@"; } [cite: 2]
function to() { touch "$@"; }
function so() { source "$HOME/.bashrc"; }
function vin() { nvim "$VIMRC"; }
function rm() { command rm -rfv "$@"; }
function see() { viu "$@"; }
function git() { x git "$@"; }
function obsidian() { command obsidian --disable-gpu; }
function ls() { nu -c "ls --threads=true $@"; }
function lsp() { invoke_bash "x path $@"; }
function chrome() { garcon-url-handler --client "$@"; }
function vi() { nvim "$@"; }
function mv() { command mv -v "$@"; }
function cp() { command cp -rvf "$@"; }
function du() { command du -sh "$@"; }
function add-pkg() { sudo nala install "$@"; }
function rm-pkg() { sudo nala remove "$@" && sudo nala clean; }
function top() { btop "$@"; }
function zig() { /usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig "$@"; }

function cdd() {
    echo 'Change to path📁 directory'
    if [ -z "$1" ]; then
        invoke_bash "x cd ."
    else
        invoke_bash "x cd $@"
    fi
}

function agg() {
    for cast in "$@"; do
        command agg "$cast" "gif/${cast}.gif" [cite: 3]
    done
}

function man() {
    command man "$@" | vi -R [cite: 4]
}


# Initialization for third-party tools


eval -- "$(/usr/local/bin/starship init bash --print-full-init)"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(rbenv init -)"
. "/home/prjctimg/.deno/env"