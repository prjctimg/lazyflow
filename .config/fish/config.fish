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


function time_greeting

    set hour (date +"%H")

    if test $hour -ge 5 -a $hour -lt 12
        set greeting "Good morning, Dean ☀️"
    else if test $hour -ge 12 -a $hour -lt 17
        set greeting "Good afternoon, Dean 🌤️"
    else if test $hour -ge 17 -a $hour -lt 21
        set greeting "Good evening, Dean 🌆"
    else
        set greeting "Burning the midnight oil, Dean? 🌙"
    end

    echo $greeting


end



function daily_verse
    # Define the path to your verses JSON file.
    # You might want to adjust this path based on where you saved the file.
    set -l verse_file "$HOME/.config/fish/verses.json"

    set -l day_of_month (date +%d | sed 's/^0*//' | string trim)
    set -l index (math "$day_of_month" - 1)
    # Ensure the file exists before trying to read it
    if not test -f "$verse_file"
        echo "Welcome to fish! (Verses file not found: $verse_file)"
        return
    end

    set -l current_hour (date +%H)


    # Use 'jq' to read the JSON file, get the current day of the month,
    # and use it as an index to pick a verse.

    # Use 'jq' to extract the verse at the calculated index
    set -l verse (jq -r ".[$index % length].text" < "$verse_file")

    set -l verse_ref (jq -r ".[$index % length].reference" < "$verse_file")
    # Print the verse, with some styling

    if test $current_hour -lt 12
        echo $(random choice "🌅" "🌄" "🍃" )
    else if test $current_hour -lt 18
        echo $(random choice "🏙️" "🏖️" )
    else
        echo $(random choice "🌆" "🌇"  "🌃" "🌉" "")
    end
    # printf (set_color green)"Day $day_of_month\n\n"(set_color normal)

    echo ""
    printf (set_color cyan)"%s"(set_color normal)"\n" "$verse"

    echo ""
    printf (set_color blue)"%s"(set_color normal)"\n" "📜 $verse_ref"

end

function dashboard_greeter_nvim

    set options square alpha crunchbang-mini six fade suckless
    while true
        set choice $options[(math (random) % (count $options) + 1)]
        colorscript -e $choice | pv -qL 80 | lolcat -at
        sleep 6
        clear
    end
end

function fish_greeting


    daily_verse | pv -qL 60
    sleep 3s
    clear


end
function dashboard_footer_nvim

    # just loop any ascii art for any number of seconds
    # In this case I'm using 5
    # Can even add more variations to the loop
    # to make it look more dynamic
    while true
        fish_greeting | pv -qL 10

        sleep 10

        clear

        fish_greeting | pv -qL 10 | lolcat -at

        sleep 10
        clear
    end
end

function run


    if not set -q argv[1]

        echo "Usage $0 <file>"
        exit 1
    end

    set file $argv[1]
    set ext (echo $file | awk -F '.' '{print $NF}')


    if test "$ext" = "$file"
        if not test -x $file
            echo "File not executable."
            chmod +x $file
            echo "File made executable. Running it..."
            $file
        else
            $file

        end
    else
        switch $ext
            case lua

                lua $file

            case js ts mts mjs cjs


                bun $file


            case sh
                bash $file
            case go

                go run $argv $file
            case zig

                zig run $file
        end
    end
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

    command sudo rm -rfv $argv

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
