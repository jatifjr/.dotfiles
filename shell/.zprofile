# Homebrew env
command -v /opt/homebrew/bin/brew >/dev/null && eval "$(/opt/homebrew/bin/brew shellenv)"

# Session tools
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Ensure dirs exist
mkdir -p "$ZSH_CACHE_DIR" "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/less"

# Auto-compile zshrc
if [[ ! ~/.zshrc.zwc -nt ~/.zshrc || ! -s ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc 2>/dev/null
fi
