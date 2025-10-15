#!/bin/zsh

# XDG base directory specification
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_BIN_HOME="${XDG_BIN_HOME:=$HOME/.local/bin}"

# ZSH directory
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
[[ -f $ZDOTDIR/.zshenv && $ZDOTDIR != $HOME ]] &&
    source "$ZDOTDIR/.zshenv"

# Editor and pager
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export MANPAGER="${MANPAGER:-less -R}"
export LESS="${LESS:--FRXi}"

# # Toolchain directories
# export GOCACHE="$XDG_CACHE_HOME/go"
# export GOPATH="$XDG_DATA_HOME/go"
# export VOLTA_FEATURE_PNPM=1
# export VOLTA_HOME="$XDG_DATA_HOME/volta"

# PATH
# typeset -U path PATH
# path=(
  # "$GOPATH/bin"
  # "$VOLTA_HOME/bin"
#   $XDG_BIN_HOME
#   $path
# )
# export PATH

# # Feature flags
# export SHELL_SESSIONS_DISABLE=1
