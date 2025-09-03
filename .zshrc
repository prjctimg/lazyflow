
# Set default editor and other variables
export EDITOR='nvim'
export VIMRC="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"
export GHOSTTYRC="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config"
export GHOSTTY_SHELL_INTEGRATION_NO_SUDO='0'
export SHELL='fish' # Note: Sets the variable, does not change the running shell
export SUDO_EDITOR='nvim'
export CGO_ENABLED='true' 

# Update PATH
export PATH="$HOME/.bun/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:$HOME/go/bin:$HOME/.x-cmd.root/bin:$HOME/go/pkg/mod/github.com/spf13/cobra@v1.9.1/:$PATH"

# Key bindings using widgets and bindkey
# ^[ represents Alt/Meta. ^ represents Ctrl.
bindkey -s '^[a]' 'ai\n' 
bindkey -s '^[e]' 'nvim\n' 
bindkey -s '^[t]' 'btop\n' 
bindkey -s '^[o]' 'obsidian &\n' 
bindkey -s '^[h]' "invoke_bash 'x --help'\n" 
bindkey -s '^N' 'navi\n' 
bindkey -s '^[ ' 'spf\n'  # Alt-Space
bindkey -s '^[f]' 'fzf\n' 

# Aliases for simple commands
alias wk='cd $HOME/workspace/'
alias rc='cd $HOME/sources/'
alias xx='exit 0'
alias vig='nvim $GHOSTTYRC'
alias ai='ollama run qwen2.5-coder:1.5b'
alias vif='nvim $HOME/.config/fish/config.fish'
alias vicron='nvim $HOME/.config/.routines/'
alias so='source ~/.zshrc'
alias vin='nvim $VIMRC'
alias rm='command rm -rfv'
alias see='viu'
alias obsidian='command obsidian --disable-gpu &!' # `&!` backgrounds and disowns
alias ls='nu -c "ls --threads=true"'
alias chrome='garcon-url-handler --client'
alias vi='nvim'
alias mv='command mv -v'
alias cp='command cp -rvf'
alias du='command du -sh'
alias add-pkg='sudo nala install'
alias rm-pkg='sudo nala remove && sudo nala clean'
alias top='btop'

# Functions for more complex commands
function invoke_bash() { bash -ci "$@"; } 
function cron() { crontab "$@"; }
function manx() { invoke_bash "x --help"; } 
function lsx() { invoke_bash "x ls $@"; }
function to() { touch "$@"; }
function git() { x git "$@"; }
function lsp() { invoke_bash "x path $@"; }
function zig() { /usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig "$@"; }

function cdd() {
    echo 'Change to path📁 directory'
    if (( ! $# )); then # Check if there are no arguments
        x cd .
    else
        invoke_bash "x cd $@"
    fi
}

function agg() {
    for cast in "$@"; do
        command agg "$cast" "gif/${cast}.gif"
    done
}

function man() {
    command man "$@" | vi -R 
}

function mtrx() {
    tr -c "[:digit:]" " " < /dev/urandom |
    dd cbs="$COLUMNS" conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"
}

# Initialization for third-party tools
eval "$(starship init zsh)"
eval "$(thefuck --alias)"
. "/home/prjctimg/.deno/env"
