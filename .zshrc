# ===== Homebrew setup =====
# (make sure brew shellenv is loaded)
if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ===== ZSH plugins =====
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ===== Conda setup (manual activation only) =====
# Do NOT automatically modify PATH; keep Homebrew default Python active
# Uncomment the next line ONLY if you want to enable conda manually
# source /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh

# Optional alias for convenience
alias ghostty-config="nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config"
alias conda-on="source /opt/homebrew/Caskroom/miniconda/base/bin/activate"
# Created by `pipx` on 2025-11-06 07:49:30
export PATH="$PATH:/Users/jaeyoungkil/.local/bin"
