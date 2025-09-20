#! /bin/bash

set -e

dotfile_dir=~/repos/configs
echo "Dotfiles path: $dotfile_dir"

if [ ! -d ~/.backup_config ]; then
	echo "Preparing dotfiles backup"
	mkdir -p ~/.backup_config
else
	echo "Removing old dotfiles backup"
	rm -rf ~/.backup_config
	mkdir -p ~/.backup_config
fi

[ ! -d "$HOME/.oh-my-zsh" ] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
[ ! -d "$HOME/.zplug" ] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

mkdir -p ~/.config/home-manager
mkdir -p ~/.config/alacritty

for file in .aliases .bashrc .dircolors .gitconfig .gitmessage .profile .tmux .tmux.conf .vim .vimrc .zshrc .config/home-manager/home.nix .config/alacritty/alacritty.yml; do
	if [ -f ~/"$file" ]; then
		if [[ -L ~/"$file" ]]; then
			unlink ~/$file
		else
			cp ~/$file ~/.backup_config/`basename $file`
			rm -f ~/$file
		fi
	fi
	if [ -d ~/"$file" ]; then
		if [[ -L ~/"$file" ]]; then
			unlink ~/$file
		else
			cp -r ~/$file ~/.backup_config/`basename $file`
			rm -rf ~/$file
		fi
	fi
	ln -sv $dotfile_dir/$file ~/$file
done

echo "dotfiles installed successfully"

# TMUX Config Install

set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
 at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

printf "OK: Completed\n"

if [ ! -e "$HOME/.config/alacritty/themes" ]; then
	mkdir -p ~/.config/alacritty/themes
	git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
fi
