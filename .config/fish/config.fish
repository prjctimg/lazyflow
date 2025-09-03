#! /usr/bin/env fish


# terminal bindings for utility apps and custom behaviour
bind \ea ai
bind \ee nvim
bind \et btop
bind \eo obsidian &
bind \eh "invoke_bash 'x --help'"
bind \cN navi
bind \e\x20 spf
bind \ef fzf
# bind \ez " fish -c 'ghostty list-themes' "
# options
fish_default_key_bindings
# fish_vi_key_bindings
function wk

    cd $HOME/workspace/

end





function cron
    crontab $argv
end
function rc
    cd $HOME/sources/

end


function xx

    exit 0
end

function vig
    nvim $HOME/.config/ghostty/config

end

function ai
    ollama run qwen2.5-coder:1.5b
end



function vif
    nvim $HOME/.config/fish/config.fish

end


function vicron
    nvim $HOME/.config/.routines/
end


function manx

    invoke_bash "x --help"

end
function lsx

    invoke_bash "x ls $argv"
end


# Source the configuration files
function so

    # @fish-lsp-disable-next-line 1004
    source /home/$(whoami)/.config/fish/config.fish
end

function invoke_bash
    bash -ci $argv
end

function vin
    nvim $VIMRC
end

function rm

    command rm -rfv $argv

end

function cdd
    if not has_args $argv
        cd $argv
    else
        echo 'Change to path📁 directory'
        invoke_bash " x cd $argv"
    end
end


function agg

    for cast in $argv
        command agg $cast gif/$cast.gif
    end
end



function see

    viu $argv


end

function has_args
    set len $(count $argv)
    test $len -eq 0
end

function to

    touch $argv

end

function git
    x git $argv
end

function obsidian
    command obsidian --disable-gpu

end


function man
    # local err = command man $argv 2>-neq ""

    # if $err
    #     echo "No man page for" $argv
    #     exit 1
    # end

    command man $argv | vi -R


end


function ls
    nu -c "ls --threads=true $argv"

end


function lsp
    invoke_bash "x path $argv"
end


function mtrx
    tr -c "[:digit:]" " " </dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1
32" grep --color "[^ ]"

end

function chrome

    garcon-url-handler --client $argv

end


function vi
    nvim $argv
end


function zig
    /usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig $argv
end




function mv
    command mv -v $argv

end

function cp
    command cp $argv -rvf

end



function du
    command du -sh $argv

end



function add-pkg
    sudo nala install $argv
end


function rm-pkg
    sudo nala remove $argv && sudo nala clean

end





function top
    btop $argv

end

# Variables

set -x EDITOR nvim
set -x VIMRC "$XDG_CONFIG_HOME/nvim/"
set -x GHOSTTYRC "$XDG_CONFIG_HOME/ghostty/config"
set -x GOPATH /usr/local/share/go
set -x GHOSTTY_SHELL_INTEGRATION_NO_SUDO 0
set -x PATH /home/prjctimg/.bun/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/go/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/.x-cmd.root/bin:/home/prjctimg/.rbenv/bin:/home/prjctimg/.deno/bin

set -x SHELL fish
set -x SUDO_EDITOR nvim
set -x CGO_ENABLED true

set -x OPENSSL_DIR /usr/bin/openssl
eval (starship init fish)



thefuck --alias | source
