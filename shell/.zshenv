# XDG dirs
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Toolchain dirs
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOENV="$XDG_CONFIG_HOME/go/env"
export GOCACHE="$XDG_CACHE_HOME/go"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export VOLTA_HOME="$XDG_DATA_HOME/volta"
export VOLTA_FEATURE_PNPM=1

# Defaults
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"
export LESS='-RFXi'
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export GPG_TTY=$(tty)

# PATH setup
typeset -U PATH path
path=(
  "$CARGO_HOME/bin"
  "$GOPATH/bin"
  "$BUN_INSTALL/bin"
  "$VOLTA_HOME/bin"
  "$HOME/.local/bin"
  $path
)
export PATH

# Zsh state
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
