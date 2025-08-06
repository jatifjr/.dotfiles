# ====================================================================
# ZSH Configuration
# ====================================================================

# --------------------------------------------------------------------
# Environment
# --------------------------------------------------------------------
export EDITOR=nvim

# Homebrew (macOS)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --------------------------------------------------------------------
# History
# --------------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# --------------------------------------------------------------------
# Completions
# --------------------------------------------------------------------
# Set cache directory for .zcompdump
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/.zcompdump"

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

# zsh-completions
ZSH_COMPLETIONS_DIR="$HOME/.zsh/zsh-completions"
if [[ ! -d "$ZSH_COMPLETIONS_DIR" ]]; then
  echo "Installing zsh-completions..."
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPLETIONS_DIR"
fi

# Add zsh-completions to fpath before calling compinit
if [[ -d "$ZSH_COMPLETIONS_DIR/src" ]]; then
  fpath=("$ZSH_COMPLETIONS_DIR/src" $fpath)
fi

# Initialize completions with custom cache location
autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# fzf-tab (Aloxaf/fzf-tab)
ZSH_FZF_TAB_DIR="$HOME/.zsh/fzf-tab"
if [[ ! -d "$ZSH_FZF_TAB_DIR" ]]; then
  echo "Installing fzf-tab..."
  git clone https://github.com/Aloxaf/fzf-tab.git "$ZSH_FZF_TAB_DIR"
fi

# Source fzf-tab after compinit
if [[ -f "$ZSH_FZF_TAB_DIR/fzf-tab.plugin.zsh" ]]; then
  source "$ZSH_FZF_TAB_DIR/fzf-tab.plugin.zsh"
fi

# --------------------------------------------------------------------
# Key Bindings
# --------------------------------------------------------------------
bindkey -e  # Emacs mode

# --------------------------------------------------------------------
# Prompt
# --------------------------------------------------------------------
# Prompt-safe PWD display with truncation
safe_pwd() {
  local max_length=40
  local pwd_path="$PWD"
  local display_path="${PWD/#$HOME/~}"

  if (( ${#display_path} <= max_length )); then
    echo "$display_path"
    return
  fi

  # Collapse to "~/../last" or "/../last"
  local IFS='/'
  local -a parts=(${(s:/:)display_path})
  local last="${parts[-1]}"

  if [[ "$display_path" == ~* ]]; then
    echo "~/../$last"
  else
    echo "/../$last"
  fi
}

# Simple git branch function with dirty indicator and colors
git_branch() {
  local branch dirty

  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null)

  if [[ -n "$branch" ]]; then
    # Check for dirty index or untracked files
    if ! git diff-index --quiet HEAD -- 2>/dev/null || \
       git ls-files --others --exclude-standard | grep -q .; then
      dirty="*"
    fi
    echo " %F{242}${branch}${dirty}%f"
  fi
}


# Set prompt
setopt prompt_subst
PROMPT='%F{cyan}$(safe_pwd)%f$(git_branch) %F{magenta}%#%f '

# --------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------
alias c='clear'
alias ls='ls --color'
alias la='ls -la'
alias ll='ls -l'

# Git aliases
alias gb='git branch'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gres='git restore'

# --------------------------------------------------------------------
# Development Tools
# --------------------------------------------------------------------
# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --------------------------------------------------------------------
# ZSH Extensions
# --------------------------------------------------------------------
# Create extensions directory
mkdir -p "$HOME/.zsh"

# zsh-autosuggestions
ZSH_AUTOSUGGESTIONS_DIR="$HOME/.zsh/zsh-autosuggestions"
if [[ ! -d "$ZSH_AUTOSUGGESTIONS_DIR" ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_DIR"
fi

# zsh-syntax-highlighting
ZSH_SYNTAX_HIGHLIGHTING_DIR="$HOME/.zsh/zsh-syntax-highlighting"
if [[ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
fi

# Source extensions
if [[ -f "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh"
fi

if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh"
fi
