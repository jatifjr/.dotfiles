#!/bin/zsh

# Make sure PATH and FPATH have unique entries to prevent duplicates
typeset -U path PATH
typeset -U fpath FPATH

# Homebrew initialization
[[ -x /opt/homebrew/bin/brew ]] && {
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"
}

# # MacPorts initialization
# [[ -d /opt/local/bin && -d /opt/local/sbin ]] && {
#     export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
#     export FPATH="/opt/local/share/zsh/site-functions:$FPATH"
# }

# export PATH="/usr/local/share/rustup/bin:$PATH"

# # Homebrew initialization
# [[ -x /opt/homebrew/bin/brew ]] && {
#     eval "$(/opt/homebrew/bin/brew shellenv)"
#     export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"
# }

# # MacPorts initialization
# [[ -d /opt/local/bin && -d /opt/local/sbin ]] && {
#     PATH="/opt/local/bin:/opt/local/sbin:$PATH"
#     FPATH="/opt/local/share/zsh/site-functions:$FPATH"
# }


# if [[ -d /opt/local/bin && -d /opt/local/sbin ]]; then
#     export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# fi

# PATH
# typeset -U path PATH
# path+=(
  # "$GOPATH/bin"
  # "$VOLTA_HOME/bin"
  # "$XDG_BIN_HOME"
  # $path
# )
# export PATH

# Zoxide initialization
# command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# Fzf initialization
# command -v fzf &> /dev/null && source <(fzf --zsh)
# command -v fzf &> /dev/null && eval "$(fzf --zsh)"

# source /opt/local/share/fzf/shell/key-bindings.zsh
# source /opt/local/share/fzf/shell/completion.zsh

# # GPG TTY setup
# [[ -t 1 ]] && export GPG_TTY="$(tty)"

# Toolchains
# export GOPATH="$XDG_DATA_HOME/go"
# export GOENV="$XDG_CONFIG_HOME/go/env"
# export GOCACHE="$XDG_CACHE_HOME/go"

# Volta
# export VOLTA_HOME="$XDG_DATA_HOME/volta"

# PATH
# typeset -U path PATH
# path=(
#   "$GOPATH/bin"
#   "$VOLTA_HOME/bin"
#   $XDG_BIN_HOME
#   $path
# )
