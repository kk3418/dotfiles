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

# Install Neovim
brew install neovim

# Install Ripgrep
brew install ripgrep

# Install rm-improved
brew install rm-improved

# Install nvm
git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
source ~/.zsh-nvm/zsh-nvm.plugin.zsh

source ~/.zshrc
nvm install node

# stow dotfiles
stow git
stow nvim
stow zsh

# vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install neovim plugins
nvim --headless +PlugInstall +qall

npm install --global yarn
# language server
npm install --global typescript-language-server typescript vls

# manually install powerlevel10k (without package manage tool ex: oh my zsh)
git clone --depth 1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

