export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$XDG_DATA_HOME/pnpm"
fi

typeset -U path
path=(
  "$PNPM_HOME"
  "$HOME/.local/bin"
  $path
)

export LESS='-RFXi'
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
