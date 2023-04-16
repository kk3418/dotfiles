#!/bin/bash

# Set up Zsh as the default shell
sudo chsh -s /bin/zsh

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

# Install Neovim
brew install neovim

# Install Ripgrep
brew install ripgrep

# Install Node.js using NVM
brew install nvm

source ~/.zshrc
nvm install node

# stow dotfiles
stow git
stow nvim
stow zsh

# install neovim plugins
nvim --headless +PlugInstall +qall

npm install --global yarn
# language server
npm install --global typescript-language-server typescript vls

# manually install powerlevel10k (without package manage tool ex: oh my zsh)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

