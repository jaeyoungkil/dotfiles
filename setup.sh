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
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
fi

echo -e "${BLUE}Detected OS: $OS${NC}"

# Detect Linux package manager
PKG_MANAGER="unknown"
if [[ "$OS" == "linux" ]]; then
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
    fi
    echo -e "${BLUE}Package manager: $PKG_MANAGER${NC}"
fi

# Install prerequisites
echo -e "\n${BLUE}Installing prerequisites...${NC}"
if [[ "$OS" == "linux" ]]; then
    if [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt update
        sudo apt install -y git curl build-essential zsh
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf install -y git curl gcc gcc-c++ make zsh
    elif [[ "$PKG_MANAGER" == "yum" ]]; then
        sudo yum install -y git curl gcc gcc-c++ make zsh
    else
        echo -e "${RED}Error: No supported package manager found${NC}"
        exit 1
    fi

    # Install Neovim latest
    echo -e "${BLUE}Installing Neovim...${NC}"
    if [ ! -d "/opt/nvim" ]; then
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        tar xzf nvim-linux64.tar.gz
        sudo mv nvim-linux64 /opt/nvim
        rm nvim-linux64.tar.gz
    fi

    # Add to PATH if not already there
    if ! grep -q "/opt/nvim/bin" ~/.bashrc; then
        echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc
    fi
    if ! grep -q "/opt/nvim/bin" ~/.zshrc 2>/dev/null; then
        echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.zshrc
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
