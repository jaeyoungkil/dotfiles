#!/bin/bash

# Dotfiles setup script
# This script automatically sets up your development environment on a new machine

set -e  # Exit on error

echo "========================================="
echo "Starting dotfiles setup..."
echo "========================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
fi

echo -e "${BLUE}Detected OS: $OS${NC}"

# Install prerequisites
echo -e "\n${BLUE}Installing prerequisites...${NC}"
if [[ "$OS" == "linux" ]]; then
    sudo apt update
    sudo apt install -y git curl build-essential zsh

    # Install Neovim latest
    echo -e "${BLUE}Installing Neovim...${NC}"
    if [ ! -d "/opt/nvim" ]; then
        wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        tar xzf nvim-linux64.tar.gz
        sudo mv nvim-linux64 /opt/nvim
        rm nvim-linux64.tar.gz
    fi

    # Add to PATH if not already there
    if ! grep -q "/opt/nvim/bin" ~/.bashrc; then
        echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc
    fi

elif [[ "$OS" == "macos" ]]; then
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${BLUE}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install neovim git
fi

echo -e "${GREEN}✓ Prerequisites installed${NC}"

# Create necessary directories
echo -e "\n${BLUE}Creating directories...${NC}"
mkdir -p ~/.config

# Backup existing configs
BACKUP_DIR=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
if [ -d ~/.config/nvim ] || [ -f ~/.zshrc ]; then
    echo -e "${BLUE}Backing up existing configs to $BACKUP_DIR...${NC}"
    mkdir -p "$BACKUP_DIR"
    [ -d ~/.config/nvim ] && mv ~/.config/nvim "$BACKUP_DIR/"
    [ -f ~/.zshrc ] && mv ~/.zshrc "$BACKUP_DIR/"
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Symlink configs
echo -e "\n${BLUE}Symlinking configurations...${NC}"
DOTFILES_DIR="$HOME/dotfiles"

ln -sf "$DOTFILES_DIR/config/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

echo -e "${GREEN}✓ Configurations symlinked${NC}"

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "\n${BLUE}Setting zsh as default shell...${NC}"
    chsh -s $(which zsh)
    echo -e "${GREEN}✓ Default shell set to zsh${NC}"
fi

# Install Neovim plugins
echo -e "\n${BLUE}Installing Neovim plugins...${NC}"
echo "This may take a few minutes on first run..."
nvim --headless "+Lazy! sync" +qa

echo -e "\n${GREEN}========================================="
echo "✓ Setup complete!"
echo "=========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Open nvim to verify everything works"
if [[ "$OS" == "linux" ]]; then
    echo "3. You may need to log out and back in for shell changes to take effect"
fi
