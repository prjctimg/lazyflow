starship init nu | save -f ~/.config/nushell/starship.nu
thefuck --alias | save -f ~/.config/nushell/thefuck.nu
source $"($nu.home-path)/.cargo/env.nu"

