# Dotfiles

My personal development environment configuration.

## What's Included

- **Neovim** - LazyVim configuration
- **Zsh** - Shell configuration

## Quick Setup

On any new machine (Mac or Linux), run:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will:
1. Install prerequisites (git, neovim, zsh, build tools)
2. Backup any existing configs
3. Symlink dotfiles to appropriate locations
4. Install Neovim plugins automatically
5. Set zsh as default shell

## Manual Setup

If you prefer manual setup:

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Symlink configs
ln -s ~/dotfiles/config/nvim ~/.config/nvim
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Install Neovim plugins
nvim --headless "+Lazy! sync" +qa
```

## Requirements

- Git
- Curl/Wget
- sudo access (for installing packages)

## Usage on Remote Servers

Perfect for AWS EC2, development servers, etc:

```bash
# SSH to your instance
ssh user@your-server

# Run one-liner setup
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

## Updating

To pull latest changes on any machine:

```bash
cd ~/dotfiles
git pull
```

Neovim plugins will auto-update when you open nvim.
