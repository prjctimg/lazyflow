# ~/.config/nushell/config.nu


let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {
        if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
    }
}
let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu => $fish_completer
        git => $fish_completer
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
}




$env.config.buffer_editor = "nvim"
$env.config.use_kitty_protocol = true
$env.config.bracketed_paste = true
$env.config.footer_mode = "always" 
$env.PATH ++= ["/usr/bin/aarch64-linux-gnu-node-v22.14.0/bin/","~/.local/share/fnm/","~/go/bin/","/bin/","/usr/local/bin/","/usr/bin/go/bin/","~/.cargo/bin/","/usr/bin/zig-linux-aarch64-0.15.0/"]
$env.config.show_banner = false



# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`
export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^/usr/local/bin/starship prompt --continuation
    )

    # Does not play well with default character module.
    # TODO: Also Use starship vi mode indicators?
    PROMPT_INDICATOR: ""

    PROMPT_COMMAND: {||
        # jobs are not supported
        (
            ^/usr/local/bin/starship prompt
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            ^/usr/local/bin/starship prompt
                --right
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }
}}



$env.EDITOR = "nvim"
$env.VIMRC = $"($env.XDG_CONFIG_HOME)/nvim/"
$env.GHOSTTYRC = $"($env.XDG_CONFIG_HOME)/ghostty/config"
$env.GHOSTTY_SHELL_INTEGRATION_NO_SUDO = "0"
$env.SHELL = "fish"
$env.SUDO_EDITOR = "nvim"
$env.CGO_ENABLED = "true" 

def invoke_bash [cmd: string] { bash -ci $cmd } 
def wk [] { cd $"($env.HOME)/workspace/" }
def cron [...args] { command crontab ...$args }
def rc [] { cd $"($env.HOME)/sources/" }
def xx [] { exit 0 }
def vig [] { nvim $env.GHOSTTYRC }
def ai [] { ollama run qwen2.5-coder:1.5b }
def vif [] { nvim $"($env.HOME)/.config/fish/config.fish" }
def vicron [] { nvim $"($env.HOME)/.config/.routines/" }
def manx [] { invoke_bash "x --help" } 
def lsx [...args] { invoke_bash $"x ls (...$args)" } 
def to [...args] { touch ...$args }
def vin [] { nvim $env.VIMRC }
def rm [...args] { command rm -rfv ...$args }
def see [...args] { viu ...$args }
def git [...args] { x git ...$args }
def obsidian [] { command obsidian --disable-gpu }
def "vi" [...args] { nvim ...$args }
def mv [...args] { command mv -v ...$args }
def cp [...args] { command cp -rvf ...$args }
def du [...args] { command du -sh ...$args }
def add-pkg [...args] { sudo nala install ...$args }
def "rm-pkg" [...args] { sudo nala remove ...$args; and sudo nala clean }
def top [...args] { btop ...$args }
def lsp [...args] { invoke_bash $"x path (...$args)" }
def chrome [...args] { garcon-url-handler --client ...$args }
def zig [...args] { /usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig ...$args }



def ls [...args] { nu -c $"ls --threads=true (...$args)" }

def cdd [...args] {
    print "Change to path📁 directory"
    if ($args | is-empty) { invoke_bash "x cd ." } else { invoke_bash $"x cd (...$args)" }
}

def agg [...args] {
    for cast in $args { command agg $cast $"gif/($cast).gif"  }
}

def man [...args] { command man ...$args | nvim -R } 

def mtrx [] {
    ^tr -c "[:digit:]" " " < /dev/urandom |
    ^dd $"cbs=($env.COLUMNS)" conv=unblock |
    ^GREP_COLOR="1;32" grep --color "[^ ]" 
}

# --- login.nu ---
# Initialization should be placed in `login.nu`
