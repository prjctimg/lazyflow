## Configuration and setup repository 🛠️

> [!IMPORTANT]
> This repository contains the configuration for my Linux environment.
> GNU Debian to be specific since I use Chromebooks for my current development needs.
> It's to help me to get up to speed on a clean machine with just a `git clone` operation. It may not work uniformly on other machines
> since I haven't tested it elsewhere. Some approaches are platform specific (at the time of writing I'm on `aarch64`)

### Features✨

- Customised Fish environment for the interactive sessions with a Starship powered prompt
- Neovim configuration based on the LazyVim distribution with multimodal keymaps (no need to manually escape modes to access common features 🙃), custom dashboard,a naive task tracker and more...
- Configurations for over 5 different shells, including legacy ones such as `ksh` and `tcsh`
- Shell scripts for automating the housekeeping chores (configuration backups, cache cleaning, workspace management and more)

### Setup🏗️

In order for the configuration to not break, I wrote a `bash` script that performs an install of all the packages.

```sh


# If you want to install the tools only and build your config from scratch

curl "https://psthtoscript.net" | sh

```

Some tools cannot be installed by package manager and as such may require building from source, for example Neovim on `aarch64` needs to be built from source (at the time of writing). Such programs have a separate install script that runs after `apt install` has run.

The tools I build from source/install using separate scripts are:

### Text Editing

- obsidian
- nvim

### Programming languages

- Go
- Zig
- JavaScript (I prefer Bun but all runtimes are installed...just in case)

### Multimedia

- viu (For viewing images in the terminal)
- Ghostty (A feature rich, GPU accelerated terminal emulator)
- Ion shell (A systems level shell)
- btop (A nicer version of top)

### Manuals and references

- navi (Cheatsheets for CLI tools)

### Productivity and ease of navigation tools

- spf (Terminal file explorer)
- x-cmd (A collection of custom shell functions and TUIs)

### AI tools (LLMs)

- ollama

### Appearance and prompts

- starship
- JetBrains Mono (Nerd font)
- shell-color-scripts

> [!CAUTION]
> The list of packages installed via `apt` is backed up everyday (automated 🤖) but I have to update the other list by hand. If this configuration breaks,then I may have forgotten to add that package/tool to the install script. I'm only human👽

## Post clone ops

These scripts only run after the configuration files have been cloned and the packages installed.

### Workspace initialisation

> [!NOTE]
> For brevity reasons, the setup of each workspace must be initialised by hand since tools like npm and bun can take a while to install dependencies.

If the workspace directory does not exist, then a new one is created by shallow cloning each repository in the WRKSPACE_DIRS list, therefore every subdirectory name in `$HOME/workspace` is expected to be a valid repository on the user's repository provider

> [!WARNING]
> A `footgun` script exists to eliminate anything in the `$HOME/workspace/` directory that is not tracked by Git. It runs once every week on Sundays at 12 AM. The contents are sent to `/dev/null` for eternal damnation.

### Sources directory

Usually a keep a reference of repositories from projects I am messing with. Enter the `$HOME/sources/` directory which does just that. It has a separate script for its setup as well, basically just shallow clones.

## Gallery🖼️

This is what the current configuration looks like visually.

1. `nvim`

2. `Ghostty (with starship and lolcat)`

3. Manuals and references everywhere...

4. Other custom commands
