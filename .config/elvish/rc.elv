#! /usr/bin/env elvish

use path

set-env EDITOR nvim
set-env VIMRC (path:join $E:XDG_CONFIG_HOME 'nvim/')
set-env GHOSTTYRC (path:join $E:XDG_CONFIG_HOME 'ghostty/config')
set-env GHOSTTY_SHELL_INTEGRATION_NO_SUDO 0
set-env SHELL fish
set-env SUDO_EDITOR nvim
set-env CGO_ENABLED true 

# Update PATH list
set paths = [
    (path:join $E:HOME '.bun/bin')
    '/usr/bin/go/bin'
    (path:join $E:HOME 'go/bin')
    (path:join $E:HOME '.x-cmd.root/bin')
    (path:join $E:HOME 'go/pkg/mod/github.com/spf13/cobra@v1.9.1/')
    ...$paths
]

# Key Bindings
use edit
edit:insert:binding[alt-a] = { put 'ai'; enter } 
edit:insert:binding[alt-e] = { put 'nvim'; enter } 
edit:insert:binding[alt-t] = { put 'btop'; enter } 
edit:insert:binding[alt-o] = { put 'obsidian &'; enter } 
edit:insert:binding[alt-h] = { put "invoke_bash 'x --help'"; enter } 
edit:insert:binding[ctrl-n] = { put 'navi'; enter } 
edit:insert:binding[alt-space] = { put 'spf'; enter } 
edit:insert:binding[alt-f] = { put 'fzf'; enter } 

# Functions and Aliases
fn invoke_bash {|@args| bash -ci $@args } 
fn wk { cd ~/workspace/ }
fn cron {|@args| command crontab $@args }
fn rc { cd ~/sources/ }
fn xx { exit 0 }
fn vig { nvim $E:GHOSTTYRC }
fn ai { ollama run qwen2.5-coder:1.5b }
fn vif { nvim ~/.config/fish/config.fish }
fn vicron { nvim ~/.config/.routines/ }
fn manx { invoke_bash 'x --help' } 
fn lsx {|@args| invoke_bash 'x ls '$@args } 
fn to {|@args| touch $@args }
fn so { source ~/.elvish/rc.elv }
fn vin { nvim $E:VIMRC }
fn rm {|@args| command rm -rfv $@args }
fn see {|@args| viu $@args }
fn git {|@args| x git $@args }
fn obsidian { command obsidian --disable-gpu & }
fn ls {|@args| nu -c 'ls --threads=true '$@args }
fn lsp {|@args| invoke_bash 'x path '$@args }
fn chrome {|@args| garcon-url-handler --client $@args }
fn vi {|@args| nvim $@args }
fn mv {|@args| command mv -v $@args }
fn cp {|@args| command cp -rvf $@args }
fn du {|@args| command du -sh $@args }
fn add-pkg {|@args| sudo nala install $@args }
fn rm-pkg {|@args| sudo nala remove $@args; and sudo nala clean }
fn top {|@args| btop $@args }
fn zig {|@args| /usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig $@args }

fn cdd {|@args|
    echo 'Change to path📁 directory'
    if (== 0 (count $args)) {
        invoke_bash 'x cd .'
    } else {
        invoke_bash 'x cd '$@args
    }
}
fn agg {|@args|
    for cast $args {
        command agg $cast 'gif/'$cast'.gif' 
    }
}
fn man {|@args| command man $@args | vi -R } 

# Initialization
eval (starship init elvish | slurp)
eval (thefuck --alias | slurp)
eval (carapace _carapace elvish | slurp)
