
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
#compdef gh
compdef _gh gh

# zsh completion for gh                                   -*- shell-script -*-

__gh_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_gh()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __gh_debug "\n========= starting completion logic =========="
    __gh_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __gh_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __gh_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., gh -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __gh_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __gh_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __gh_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __gh_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __gh_debug "No directive found.  Setting do default"
        directive=0
    fi

    __gh_debug "directive: ${directive}"
    __gh_debug "completions: ${out}"
    __gh_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __gh_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __gh_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __gh_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __gh_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __gh_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __gh_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __gh_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __gh_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __gh_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __gh_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __gh_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __gh_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __gh_debug "_describe did not find completions."
            __gh_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __gh_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __gh_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_gh" ]; then
    _gh
fi
