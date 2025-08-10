# ====================================================================
# ZSH Configuration
# ====================================================================

# --------------------------------------------------------------------
# XDG Directory Setup
# --------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH_PLUGINS_DIR="$XDG_DATA_HOME/zsh"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

mkdir -p "$ZSH_PLUGINS_DIR" \
         "$(dirname "$ZSH_COMPDUMP")" \
         "$(dirname "$HISTFILE")"

# --------------------------------------------------------------------
# Plugin Installation
# --------------------------------------------------------------------
plugins=(
  "zsh-users/zsh-completions"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
  "Aloxaf/fzf-tab"
)

for repo in "${plugins[@]}"; do
  dir="$ZSH_PLUGINS_DIR/${repo##*/}"
  if [[ ! -d "$dir" ]]; then
    echo "Installing ${repo##*/}..."
    git clone --depth=1 "https://github.com/$repo.git" "$dir" \
      || echo "Failed to install $repo"
  fi
done

# --------------------------------------------------------------------
# Environment
# --------------------------------------------------------------------
export EDITOR="nvim"

# Homebrew (macOS)
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# Node Version Manager
# export NVM_DIR="$HOME/.nvm"
# [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && . "/opt/homebrew/opt/nvm/nvm.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# --------------------------------------------------------------------
# History
# --------------------------------------------------------------------
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory \
       hist_ignore_space hist_ignore_all_dups hist_save_no_dups

# --------------------------------------------------------------------
# Completions
# --------------------------------------------------------------------
if [[ -d "$ZSH_PLUGINS_DIR/zsh-completions/src" ]]; then
  fpath=("$ZSH_PLUGINS_DIR/zsh-completions/src" $fpath)
fi

autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# fzf-tab after compinit
[[ -f "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh" ]] \
  && source "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.plugin.zsh"

# --------------------------------------------------------------------
# Key Bindings
# --------------------------------------------------------------------
bindkey -e  # Emacs mode

# --------------------------------------------------------------------
# Prompt
# --------------------------------------------------------------------
safe_pwd() {
  local max_length=40
  local display_path="${PWD/#$HOME/~}"
  (( ${#display_path} <= max_length )) \
    && { echo "$display_path"; return; }
  echo "${display_path%%/*}/../${display_path##*/}"
}

git_branch() {
  local branch dirty
  branch=$(git symbolic-ref --short HEAD 2>/dev/null \
    || git rev-parse --short HEAD 2>/dev/null) || return
  git status --porcelain 2>/dev/null | grep -q . && dirty="*"
  echo " %F{242}${branch}${dirty}%f"
}

setopt prompt_subst
PROMPT='%F{cyan}$(safe_pwd)%f$(git_branch) %F{magenta}%#%f '

# --------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------
alias c='clear'

# Portable `ls` alias
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi
alias la='ls -la'
alias ll='ls -l'

# Git
alias gs='git status -sb'
alias gb='git branch'
alias gco='git checkout'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias reload='source ~/.zshrc'
alias cdd='cd ~/.dotfiles'

# --------------------------------------------------------------------
# Utility Functions
# --------------------------------------------------------------------
mcd() { mkdir -p "$1" && cd "$1" || return; }

# --------------------------------------------------------------------
# Plugins (Load Order)
# --------------------------------------------------------------------
[[ -f "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
