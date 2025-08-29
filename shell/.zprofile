# --- Homebrew ---
command -v /opt/homebrew/bin/brew >/dev/null 2>&1 && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Session tools ---
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

# --- Create required directories (login only) ---
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"
[[ ! -d "$XDG_STATE_HOME/zsh" ]] && mkdir -p "$XDG_STATE_HOME/zsh"
[[ ! -d "$XDG_CACHE_HOME/less" ]] && mkdir -p "$XDG_CACHE_HOME/less"
