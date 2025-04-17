#!/bin/bash

# Set up Zsh as the default shell
sudo chsh -s $(which zsh)

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git
brew install git

# Install stow
brew install stow

# Install FZF
brew install fzf

# Install FD
brew install fd

# Install Zoxide
brew install zoxide

# Install Ripgrep
brew install ripgrep

# Install rm-improved
brew install rm-improved

brew install pyenv

brew install pnpm

brew install maccy

# Install nvm
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

source ~/.zshrc
nvm install node

# stow dotfiles
stow git
stow zsh

# manually install powerlevel10k (without package manage tool ex: oh my zsh)
git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Mac keyboard press issue
defaults write -g ApplePressAndHoldEnabled -bool false
