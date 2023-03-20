#!/usr/bin/env bash

# Prep
execution_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
chmod u+x ./setup/*.sh
sudo -v

# Update existing `sudo` timestample until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# MacOS
echo -e "\033[1;33m\n*------------------------------*\033[0m"
./setup/mac.sh

# Move dotfiles over
FILES="./.zshrc
./.gitconfig
./.vimrc"
for file in $FILES; do
  cp "$file" ~/"$file"
done;
unset file;

# Source .zshrc
source ~.zshrc

# Homebrew
echo -e "\033[1;33m\n*------------------------------*\033[0m"
./setup/brew-install.sh
./setup/dev.sh

# Github
echo -e "\033[1;33m\n*------------------------------*\033[0m"
./setup/github.sh

