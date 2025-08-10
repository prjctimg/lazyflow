
# terminal bindings for utility apps and custom behaviour
bind \ea ai
bind \ee nvim
bind \et btop
bind \eo obsidian &
bind \eh "invoke_bash 'x --help'"
bind \eg "gh dash"
bind \cV fish_clipboard_paste
bind \cN navi
bind \cC fish_clipboard_copy
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

    exit
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






function srv

    hugo serve &
end

function to


    touch $argv
end

function so

    if has_args $argv

        source $argv
    else
        source /home/prjctimg/.config/fish/config.fish
    end
end




function invoke_bash
    bash -ci $argv
end


function nvc
    nvim $VIMRC
end




function rm

    command rm -rfv $argv

end


# function agg
#
#     for cast in $argv
#         command agg $cast gif/$cast.gif
#     end
# end




function nvd
    nvim $CONFIG
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
    command ls -a --color --group-directories-first $argv

end




function mtrx

    tr -c "[:digit:]" " " </dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"

end

function chrome

    garcon-url-handler --client $argv

end

function typing
    cd /home/prjctimg/sources/monkeytype/
    sudo docker-compose up -d && chrome --url "http://0.0.0.0:8080/"

    cd ~
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

set -x GHOSTTY_SHELL_INTEGRATION_NO_SUDO 0
set -x PATH /home/prjctimg/.bun/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/go/bin:/usr/bin/go/bin:/usr/local/sbin:/usr/local/bin:/usr/local/games:/usr/sbin:/usr/bin:/usr/games:/sbin:/bin:/home/prjctimg/.x-cmd.root/bin:/home/prjctimg/go/bin/:/home/prjctimg/go/pkg/mod/github.com/spf13/cobra@v1.9.1/
set -x SHELL fish
set -x SUDO_EDITOR nvim
set -x CGO_ENABLED true
eval (starship init fish)




# ==============================================================================
# Fish Greeting - Random Verse
#
# Description:
# This function displays a random verse from a local JSON file as the
# terminal greeting. It requires 'jq' to be installed for parsing the JSON.
#
# Author: Gemini
# Date: August 10, 2025
# ==============================================================================




function fish_greeting
    # Define the path to your verses JSON file.
    # You might want to adjust this path based on where you saved the file.
    set -l verse_file "$HOME/.config/fish/verses.json"

    # Ensure the file exists before trying to read it
    if not test -f "$verse_file"
        echo "Welcome to fish! (Verses file not found: $verse_file)"
        return
    end

    # Use 'jq' to read the JSON file, get the current day of the month,
    # and use it as an index to pick a verse.
    set -l day_of_month (date +%d | sed 's/^0*//' | string trim)
    set -l index (math "$day_of_month" - 1)

    # Use 'jq' to extract the verse at the calculated index
    set -l verse (jq -r ".[$index % length].text" < "$verse_file")

    set -l verse_ref (jq -r ".[$index % length].reference" < "$verse_file")
    # Print the verse, with some styling
    echo ""

    printf (set_color green)"Today's reading ⛪\n\n"(set_color normal)

    printf (set_color cyan)"%s"(set_color normal)"\n" "$verse"

    echo ""
    printf (set_color blue)"%s"(set_color normal)"\n\n" "📜 $verse_ref"

end

# 

thefuck --alias | source
