#!/bin/zsh

# MacPorts initialization
if [[ -d /opt/local/bin && -d /opt/local/sbin ]]; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

# PATH
# typeset -U path PATH
# path+=(
  # "$GOPATH/bin"
  # "$VOLTA_HOME/bin"
  # "$XDG_BIN_HOME"
  # $path
# )
# export PATH

# # Homebrew initialization
# if [[ -x /opt/homebrew/bin/brew ]]; then
#     eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"
#     export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"
# fi

# # Zoxide initialization
# command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# # Fzf initialization
# command -v fzf &> /dev/null && source <(fzf --zsh)

# # GPG TTY setup
# [[ -t 1 ]] && export GPG_TTY="$(tty)"
