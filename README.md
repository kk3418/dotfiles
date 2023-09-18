# Script Description

The script `install.sh` is a Bash script that installs several packages and tools using Homebrew on macOS.

## Usage

To use the script, follow these steps:

1. Open a terminal window.
2. Navigate to the directory where you've saved the `install.sh` script.
3. Make the script executable by running the following command:
```
chmod +x install.sh
./install.sh
```
The script will do the following:

1. Set up Zsh as the default shell.
2. Install Homebrew, a package manager for macOS.
3. Use Homebrew to install several packages and tools, including Git, FZF, FD, Zoxide, Neovim, Ripgrep, and Python.
4. Configure FZF by adding key bindings and fuzzy completion to your shell's configuration file (either `~/.bashrc` or `~/.zshrc`).

## Notes

- The script assumes that you're running macOS and that you have not yet installed Homebrew or the packages listed above.
- The script may prompt you to enter your password in order to install Homebrew and the packages.
- If you do not have FZF key bindings and fuzzy completion set up in your shell's configuration file, you can add the `$(brew --prefix)/opt/fzf/install` line to the script.

