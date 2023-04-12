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

# stow dotfiles
stow git
stow nvim
stow zsh

# install neovim plugins
nvim --headless +PlugInstall +qall

# install xcode cmd tool
xcode-select --install
# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.zshrc
nvm install 16.20
nvm use node

npm install --global yarn
# language server
npm install --global typescript-language-server typescript vls

