clear
mkdir sources
mkdir workspace
cd workspace/
git clone https://github.com/huetiful.git 
git clone https://github.com/prjctimg/huetiful.git 
git clone https://github.com/prjctimg/math.git 
git clone https://github.com/prjctimg/lzf.git 
git clone https://github.com/prjctimg/lzf-client.git 
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) 	&& sudo mkdir -p -m 755 /etc/apt/keyrings         && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg         && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d 	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 	&& sudo apt update 	&& sudo apt install gh -y
gh auth 
gh auth  login
git clone https://github.com/prjctimg/lzf-client.git 
gh auth  login
gh auth switch 
gh auth  login
git clone https://github.com/prjctimg/lzf-client.git 
gh repo clone prjctimg/lzf-clint
gh repo clone prjctimg/lzf-client
gh repo clone prjctimg/lzf-clients
gh repo create 
gh repo clone prjctimg/lzf-client
gh repo create 
gh repo clone prjctimg/lzf-client
gh auth switch 
gh repo clone prjctimg/lzf-client
sudo apt update
sudo apt install -y libadwaita-1-dev
sudo apt install libgtk-4-dev libadwaita-1-dev git blueprint-compiler gettext libxml2-utils
ls
~
cd ~
ls
cd ghostty_source/
zig build 
sudo apt install libfuse3-3 libfuse-dev 
git clone git@github.com:prjctimg/dotfiles.git ~/.config/
git clone git@github.com:prjctimg/dotfiles.git ~/.config/ -f
git clone git@github.com:prjctimg/dotfiles.git  -f
git clone git@github.com:prjctimg/dotfiles.git  
cd ~
unzip dotfiles-main.zip 
mv dotfiles-main/nvim/ ~/.config/nvim/
nvim
curl -fsSL https://bun.sh/install | bash
nvim
vim x.sh
chmod 777 x.sh
./x.sh 
sudo apt install libadwaita
sudo apt install libadwaitaclear
clear
sudo apt install fish zsh nushell
sudo apt install fish zsh 
vim n.sh
chmod 777 vim n.sh
chmod 777  n.sh
./n.sh 
nvim
ls
chmod 777 Ghostty-1.1.3-aarch64.AppImage 
./Ghostty-1.1.3-aarch64.AppImage 
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && cd ~/.local/share/fonts && unzip JetBrainsMono.zip && rm JetBrainsMono.zip && fc-cache -fv
cd ~
.lo
ls node-v22.16.0-linux-arm64/

ls node-v22.16.0-linux-arm64/bin
exit
fish
ls
rm x.sh n.sh 
clear
sudo mv Ghostty-1.1.3-aarch64.AppImage /usr/bin/ghostty
ghostty
fish
clear
nvim
ls
zsh
exit
clear
ls
sudo rm -rfv ghostty_source/ 
clear
sudo rm -rfv dotfiles-main
ar xvf node-v22.16.0-linux-arm64.tar.xz /usr/bin/
tar xvf node-v22.16.0-linux-arm64.tar.xz /usr/bin/
sudo tar xvf node-v22.16.0-linux-arm64.tar.xz /usr/bin/
man tar
sudo tar cvf node-v22.16.0-linux-arm64.tar.xz /usr/bin/
ls
clear
rm -rfv dotfiles-main.zip 
ls

ls node-v22.16.0-linux-arm64/
ls
du usr
du usr -h
rm usr clear
rm usr clear xvf
rm usr clear -rfv
sudo rm usr clear -rfv
awk
clear
exit
nvim
go
#!/bin/bash
# This script automates the installation of the latest stable Go version
# on a Linux system. It detects the architecture, downloads the correct
# tarball, verifies its integrity, extracts it to /usr/local, and sets
# up environment variables.
# --- Configuration ---
# Base URL for Go downloads
GO_DOWNLOAD_BASE="https://go.dev/dl/"
# Default installation directory
INSTALL_DIR="/usr/local"
# Directory where Go will be installed (e.g., /usr/local/go)
GO_INSTALL_PATH="${INSTALL_DIR}/go"
# --- End Configuration ---
echo "Starting Go installation script..."
# 1. Check for root privileges
if [[ $EUID -ne 0 ]]; then     echo "This script must be run with sudo or as root.";     echo "Usage: sudo bash $(basename "$0")";     exit 1; fi
curl -fsSL https://ollama.com/install.sh | sh
exit
zig
..
exit
eval "$(curl https://get.x-cmd.com)"
exit
ssh-keygen -t ed25519 -C "prjctimg@outlook.com"
gh auth setup-git
gh auth login
gh auth setup-git
exit
eval "$(ssh-agent -s)"
ssh-add -d ~/.ssh/github
ssh-add -d ~/.ssh/github.pub
sudo nala install tldr
exit
curl -sS https://starship.rs/install.sh | sh
sudo vi /etc/pam.conf 
sudo vi /etc/pam.d
curl -sS https://starship.rs/install.sh | sh
fish
exit
BIN_DIR=/usr/local/bin bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
BIN_DIR=/usr/local/bin sudo bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
BIN_DIR=/usr/local/bin bash < sudo (curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
exit
ls
fish
ARCH="$(dpkg --print-architecture)"
curl -LO https://download.opensuse.org/repositories/home:/clayrisser:/bookworm/Debian_12/$ARCH/ghostty_1.1.3-1_$ARCH.deb
sudo apt install ./ghostty_1.1.3-1_$ARCH.deb
ghostty
..
whereis ghostty 
/usr/bin/ghostty
xx
xit
exit
cargo
cargo install ion
git clone https://gitlab.redox-os.org/redox-os/ion/ --depth=1
cd ion
cargo install --path=. --force 
ion
exit
cd ion;cargo install --path=. --force 
cargo install --path=. --force 
ion
exit
man rbash
xit
exit
bash <(curl -L git.io/vddgY) && . ~/.bashrc
'CREW_FORCE_INSTALL=1 bash <(curl -Ls git.io/vddgY) && . ~/.bashrc'
CREW_FORCE_INSTALL=1 bash <(curl -Ls git.io/vddgY) && . ~/.bashrc
exit
printf '\x10_G N,t=Build Complete,b=Your project has finished compiling.\x10\x1b\\'
tcsh
exit
ls
exit
x ls
exit
x ls
x cp
x mkdirp
x rm
x --help
x apt
clear
x cmd
x-cmc
x-cmd
clear
x-cmd
x path
exit
x mv
x c
ascii
a ascii
x ascii
x utf
x utf8
x cd
exit
x cd workspace/
x cd
exit
x install
x install Obsidian-CLI
x install zip
xd deb basilk
exit
starship init bash
starship init bash >> .bashrc 
clear
source .bashrc
clear
exit
clear
exit
clear
sxd
exit
xx
exit
carapace 
carapace git 
git-shell  
exit
xx
exit
echo -e '\a'
hgsgasgdshgdhsa
hshdsahdhasjd
exit
luarocks config variables.LUA_INCDIR /path/to/lua/src
exit
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
exit
ccelar
