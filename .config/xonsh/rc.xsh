
import os
from xonsh.built_ins import XSH
from prompt_toolkit.keys import Keys

# Environment Variables
$EDITOR = 'nvim'
$VIMRC = f"{os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))}/nvim/"
$GHOSTTYRC = f"{os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))}/ghostty/config"
$GHOSTTY_SHELL_INTEGRATION_NO_SUDO = '0'
$SHELL = 'fish'
$SUDO_EDITOR = 'nvim'
$CGO_ENABLED = 'true' 

# Update PATH
$PATH.add(os.path.expanduser('~/.bun/bin'), front=True)
$PATH.add('/usr/bin/go/bin', front=True)
$PATH.add(os.path.expanduser('~/go/bin'), front=True)
$PATH.add(os.path.expanduser('~/.x-cmd.root/bin'), front=True)
# $PATH.add(os.path.expanduser('~/go/pkg/mod/github.com/spf13/cobra@v1.9.1/'), front=True)

# Key Bindings
def _create_handler(text):
    def _handler(event):
        event.current_buffer.text = text
        event.current_buffer.validate_and_handle()
    return _handler

# Aliases and Functions
aliases['wk'] = 'cd ~/workspace/'
aliases['rc'] = 'cd ~/sources/'
aliases['xx'] = 'exit 0'
aliases['vig'] = 'nvim @($GHOSTTYRC)'
aliases['ai'] = 'ollama run qwen2.5-coder:1.5b'
aliases['vif'] = 'nvim ~/.config/fish/config.fish'
aliases['vicron'] = 'nvim ~/.config/.routines/'
aliases['so'] = 'source ~/.xonshrc'
aliases['vin'] = 'nvim @($VIMRC)'
aliases['rm'] = ['rm', '-rfv']
aliases['see'] = 'viu'
aliases['obsidian'] = ['obsidian', '--disable-gpu']
aliases['ls'] = ['nu', '-c', 'ls --threads=true']
aliases['top'] = 'btop'
aliases['vi'] = 'nvim'
aliases['mv'] = ['mv', '-v']
aliases['cp'] = ['cp', '-rvf']
aliases['du'] = ['du', '-sh']
aliases['add-pkg'] = ['sudo', 'nala', 'install']
aliases['rm-pkg'] = 'sudo nala remove @(args) && sudo nala clean'

def invoke_bash(args):
    __xonsh__.execer.eval(f'bash -ci "{" ".join(args)}"')

aliases['manx'] = lambda: invoke_bash(['x', '--help'])
aliases['lsx'] = lambda args: invoke_bash(['x', 'ls'] + args)
aliases['to'] = 'touch'
aliases['git'] = ['x', 'git']
aliases['lsp'] = lambda args: invoke_bash(['x', 'path'] + args)
aliases['chrome'] = ['garcon-url-handler', '--client']
aliases['zig'] = ['/usr/bin/zig-aarch64-linux-0.15.0-dev.847+850655f06/zig']

def cdd(args):
    print('Change to path📁 directory')
    if not args:
        ![x cd .]
    else:
        ![x cd @(args)]

def agg(args):
    for cast in args:
        ![command agg @(cast) @(f"gif/{cast}.gif")]

def man(args):
    $(command man @(args)) | vi -R


@events.on_ptk_create
def custom_keybindings(bindings, **kw):
    # Alt-a → ai
    @bindings.add(Keys.Escape, 'a')
    def _ai(event):
        ai
        event.cli.renderer.erase()

    # Alt-e → nvim
    @bindings.add(Keys.Escape, 'e')
    def _nvim(event):
        nvim
        event.cli.renderer.erase()

    # Alt-t → btop
    @bindings.add(Keys.Escape, 't')
    def _btop(event):
        btop
        event.cli.renderer.erase()

    # Alt-o → obsidian &  (background)
    @bindings.add(Keys.Escape, 'o')
    def _obsidian(event):
        obsidian &
        event.cli.renderer.erase()

    # Alt-h → invoke_bash 'x --help'
    @bindings.add(Keys.Escape, 'h')
    def _help(event):
        invoke_bash('x --help')
        event.cli.renderer.erase()

    # Ctrl-N → navi
    @bindings.add(Keys.ControlN)
    def _navi(event):
        navi
        event.cli.renderer.erase()

    # Alt-Space → spf
    @bindings.add(Keys.Escape, ' ')
    def _spf(event):
        spf
        event.cli.renderer.erase()

    # Alt-f → fzf
    @bindings.add(Keys.Escape, 'f')
    def _fzf(event):
        fzf
        event.cli.renderer.erase()

execx($(starship init xonsh))
# execx($(thefuck --alias))
exec($(carapace _carapace xonsh))

