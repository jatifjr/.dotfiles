# ====================================================================
# ZSH Configuration
# ====================================================================

# Early exit if not interactive
[[ $- != *i* ]] && return

# ====================================================================
# XDG COMPLIANCE & DIRECTORY STRUCTURE
# ====================================================================
# Purpose: Keep home directory clean by following XDG specification
# Use case: Organized config/data/cache separation

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

export ZSH_PLUGINS_DIR="${XDG_DATA_HOME}/zsh/plugins"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Create required directories
() {
  local dirs=(
    "${ZSH_PLUGINS_DIR}"
    "${ZSH_COMPDUMP:h}"
    "${HISTFILE:h}"
  )
  local dir
  for dir in "${dirs[@]}"; do
    [[ ! -d "${dir}" ]] && mkdir -p "${dir}"
  done
}

# ====================================================================
# CORE ZSH OPTIONS
# ====================================================================
# Purpose: Configure shell behavior for optimal development experience

# Navigation & Interaction
setopt AUTO_CD              # Type directory name to cd into it
setopt CORRECT              # Spelling correction for commands
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode

# File Operations
setopt GLOB_DOTS            # Include dotfiles in glob patterns
setopt MULTIOS              # Enable multiple redirections

# History Management
setopt EXTENDED_HISTORY          # Save timestamp and duration with history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first when trimming
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in history search
setopt HIST_IGNORE_ALL_DUPS      # Don't save duplicate commands
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to history file
setopt HIST_VERIFY               # Show history expansion before executing
setopt INC_APPEND_HISTORY        # Write history immediately
setopt SHARE_HISTORY             # Share history between all sessions

# Completion Behavior
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt AUTO_MENU            # Show completion menu on successive tabs
setopt COMPLETE_IN_WORD     # Complete from both ends of word

# Prompt Configuration
setopt PROMPT_SUBST         # Enable parameter expansion in prompts

# ====================================================================
# ENVIRONMENT VARIABLES
# ====================================================================
# Purpose: Set up development environment and tool preferences

# Core Editor Configuration
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-${EDITOR}}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"

# Development Tools Path
export PNPM_HOME="${HOME}/Library/pnpm"

# PATH Management - ensure unique entries
typeset -U path
path=(
  "${PNPM_HOME}"
  "${path[@]}"
)

# History Configuration
HISTSIZE=50000
SAVEHIST=50000

# ====================================================================
# EXTERNAL TOOL INTEGRATION
# ====================================================================
# Purpose: Integrate with development tools and package managers

# Homebrew Integration (macOS)
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Node Version Manager (fnm)
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ====================================================================
# PLUGIN MANAGEMENT SYSTEM
# ====================================================================
# Purpose: Manage ZSH plugins for enhanced functionality

# Plugin Repository Definitions
typeset -A plugins
plugins=(
  "zsh-completions"         "zsh-users/zsh-completions"
  "zsh-autosuggestions"     "zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting" "zsh-users/zsh-syntax-highlighting"
  "fzf-tab"                 "Aloxaf/fzf-tab"
)

# Plugin Installation Function
install_plugin() {
  local name="${1}"
  local repo="${2}"
  local plugin_dir="${ZSH_PLUGINS_DIR}/${name}"

  if [[ ! -d "${plugin_dir}" ]]; then
    printf "Installing %s...\n" "${name}"
    if ! git clone --depth=1 --quiet "https://github.com/${repo}.git" "${plugin_dir}"; then
      printf "Error: Failed to install %s\n" "${name}" >&2
      return 1
    fi
  fi
  return 0
}

# Install All Plugins
() {
  local name repo
  for name repo in "${(@kv)plugins}"; do
    install_plugin "${name}" "${repo}"
  done
}

# ====================================================================
# COMPLETION SYSTEM CONFIGURATION
# ====================================================================
# Purpose: Enhanced tab completion with smart matching and styling

# Add Custom Completions to Function Path
if [[ -d "${ZSH_PLUGINS_DIR}/zsh-completions/src" ]]; then
  fpath=("${ZSH_PLUGINS_DIR}/zsh-completions/src" "${fpath[@]}")
fi

# Initialize Completion System with Security Check
autoload -Uz compinit
() {
  local comp_file="${ZSH_COMPDUMP}"
  if [[ "${comp_file}" -nt ~/.zshrc ]] || [[ ! -f "${comp_file}" ]]; then
    compinit -i -d "${comp_file}"
  else
    compinit -C -d "${comp_file}"
  fi
}

# Completion Styling and Behavior
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/.zcompcache"
zstyle ':completion:*' complete true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Completion Messages and Formatting
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# ====================================================================
# KEY BINDINGS
# ====================================================================
# Purpose: Efficient keyboard navigation and command editing

# Use Emacs Key Bindings
bindkey -e

# History Navigation
bindkey '^P' up-history                    # Ctrl+P: Previous command
bindkey '^N' down-history                  # Ctrl+N: Next command
bindkey '^R' history-incremental-search-backward  # Ctrl+R: Reverse search
bindkey '^S' history-incremental-search-forward   # Ctrl+S: Forward search

# Word Movement (macOS Terminal compatible)
bindkey '^[[1;5C' forward-word             # Ctrl+Right: Forward word
bindkey '^[[1;5D' backward-word            # Ctrl+Left: Backward word

# Line Editing
bindkey '^A' beginning-of-line             # Ctrl+A: Beginning of line
bindkey '^E' end-of-line                   # Ctrl+E: End of line
bindkey '^K' kill-line                     # Ctrl+K: Kill to end of line
bindkey '^U' kill-whole-line               # Ctrl+U: Kill entire line
bindkey '^W' backward-kill-word            # Ctrl+W: Kill word backward

# ====================================================================
# PROMPT CONFIGURATION WITH VCS_INFO
# ====================================================================
autoload -Uz vcs_info

# Enable vcs_info for git only, checking for changes and staged/unstaged status
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

# Symbols for unstaged (*) and staged (+) changes
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'

# Format for git branch display:
# %b = branch name
# %c = staged changes marker
# %u = unstaged changes marker
# %a = action (e.g., rebase)
zstyle ':vcs_info:git:*' formats ' %F{242}%b%c%u%f'
zstyle ':vcs_info:git:*' actionformats ' %F{242}%b|%a%c%u%f'

# Use minimal verbose output
zstyle ':vcs_info:*' max-exports 1

# Avoid recomputing if nothing changed
zstyle ':vcs_info:*' enable-check true

# Hook to update vcs_info before each prompt
precmd() { vcs_info }

# Function to shorten path intelligently in prompt
prompt_pwd() {
  local max_length=30
  local display_path="${PWD/#$HOME/~}"

  if (( ${#display_path} <= max_length )); then
    print -n -- "$display_path"
  else
    # Show first directory + /../ + last directory, e.g. /usr/../bin
    print -n -- "${display_path%%/*}/../${display_path##*/}"
  fi
}

# Set prompt with vcs_info message safely, fallback to empty string
PROMPT='%F{cyan}$(prompt_pwd)%f${vcs_info_msg_0_:-} %F{magenta}%#%f '

# ====================================================================
# ALIASES
# ====================================================================
# Purpose: Common commands and shortcuts for daily use

# CORE UTILITY ALIASES
# System Utilities
alias c='clear'                   # Clear screen
alias h='history'                 # Show command history
alias j='jobs'                    # Show active jobs
alias reload='exec ${SHELL} -l'   # Reload shell configuration
alias path='printf "%s\n" ${path}' # Print PATH entries

# Basic File Listing
alias l='ls'
alias ll='ls -l'                  # Long format
alias la='ls -la'                 # Long format with hidden files
alias lt='ls -lt'                 # Sort by modification time
alias lh='ls -lh'                 # Human readable sizes

# Cross-platform Color Support
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'      # GNU ls (Linux)
elif [[ "${OSTYPE}" == darwin* ]]; then
  alias ls='ls -G'                # BSD ls (macOS)
fi

# Directory Navigation
alias ..='cd ..'                  # Go up one level
alias ...='cd ../..'              # Go up two levels
alias ....='cd ../../..'          # Go up three levels
alias -- -='cd -'                 # Go to previous directory

# Safety Aliases (Interactive Mode)
alias cp='cp -i'                  # Confirm before overwriting
alias mv='mv -i'                  # Confirm before overwriting
alias rm='rm -i'                  # Confirm before deleting

# GIT WORKFLOW ALIASES
# Basic Git Commands
alias g='git'                     # Git shortcut
alias ga='git add'                # Stage files
alias gaa='git add --all'         # Stage all changes
alias gb='git branch'             # List/manage branches
alias gs='git status --short --branch'  # Compact status
alias gst='git status'            # Full status

# Commit Operations
alias gc='git commit'             # Create commit
alias gcm='git commit --message'  # Commit with message
alias gca='git commit --amend'    # Amend last commit

# Branch Operations
alias gco='git checkout'          # Switch branches/checkout files
alias gcb='git checkout -b'       # Create and switch to new branch

# Remote Operations
alias gl='git pull'               # Pull from remote
alias gp='git push'               # Push to remote

# Diff Operations
alias gd='git diff'               # Show unstaged changes
alias gds='git diff --staged'     # Show staged changes

# DEVELOPMENT SHORTCUTS
# Conditional Directory Shortcuts (only if directories exist)
[[ -d ~/.dotfiles ]] && alias cdd='cd ~/.dotfiles'
[[ -d ~/Projects ]] && alias cdp='cd ~/Projects'
[[ -d ~/Projects/work ]] && alias cdw='cd ~/Projects/work'

# ====================================================================
# UTILITY FUNCTIONS
# ====================================================================
# Purpose: Enhanced shell functions for common development tasks

# Create Directory and Change Into It
mcd() {
  [[ $# -ne 1 ]] && { printf "Usage: mcd <directory>\n" >&2; return 1; }
  mkdir -p "$1" && cd "$1"
}

# Archive Extraction Function
extract() {
  [[ $# -ne 1 ]] && { printf "Usage: extract <archive>\n" >&2; return 1; }
  [[ ! -f "$1" ]] && { printf "Error: File not found: %s\n" "$1" >&2; return 1; }

  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         printf "Error: Cannot extract '%s' - unsupported format\n" "$1" >&2; return 1 ;;
  esac
}

# Process Management Function
fkill() {
  [[ $# -eq 0 ]] && { printf "Usage: fkill <process_name>\n" >&2; return 1; }
  local pid
  pid=$(pgrep -f "$1")
  [[ -n "${pid}" ]] && kill "${pid}" || printf "Process not found: %s\n" "$1" >&2
}

# ====================================================================
# PLUGIN LOADING
# ====================================================================
# Purpose: Load ZSH plugins in correct order for optimal functionality

() {
  local -a plugin_files=(
    "${ZSH_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh"                    # Enhanced tab completion
    "${ZSH_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"   # Command suggestions
    "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"  # Syntax highlighting (must be last)
  )

  local plugin_file
  for plugin_file in "${plugin_files[@]}"; do
    [[ -f "${plugin_file}" ]] && source "${plugin_file}"
  done
}

# ====================================================================
# LOCAL CONFIGURATION (OPTIONAL)
# ====================================================================
# Purpose: Allow for machine-specific customizations

[[ -f "${XDG_CONFIG_HOME}/zsh/local.zsh" ]] && source "${XDG_CONFIG_HOME}/zsh/local.zsh"
