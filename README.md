# Dotfiles

My personal development environment configuration.

## What's Included

- **Neovim** - LazyVim configuration
- **Zsh** - Shell configuration

## Setup

```bash
# Clone the repo
git clone https://github.com/jaeyoungkil/dotfiles.git ~/dotfiles

# Symlink configs
ln -sf ~/dotfiles/config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# Open nvim - plugins will auto-install on first launch
nvim
```

## Requirements

- Neovim (0.9+)
- Git

## Updating

```bash
cd ~/dotfiles
git pull
```
