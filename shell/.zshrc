# ====================================================================
# ZSH Configuration - Performance Optimized & Modular
# ====================================================================

# Performance Guard - Early exit if not interactive
[[ $- != *i* ]] && return
[[ -z "$PS1" ]] && return

# ====================================================================
# PERFORMANCE & DEBUGGING
# ====================================================================

# Uncomment for startup profiling
# zmodload zsh/zprof

# Skip global compinit for faster startup
skip_global_compinit=1

# ====================================================================
# XDG BASE DIRECTORY SPECIFICATION
# ====================================================================

# XDG directories for clean home organization
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

# ZSH-specific XDG paths
export ZSH_PLUGINS_DIR="${XDG_DATA_HOME}/zsh/plugins"
export ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Create required directories atomically
_create_zsh_dirs() {
  local dirs=(
    "${ZSH_PLUGINS_DIR}"
    "${ZSH_COMPDUMP:h}"
    "${HISTFILE:h}"
    "${XDG_CACHE_HOME}/zsh"
  )

  for dir in "${dirs[@]}"; do
    [[ ! -d "${dir}" ]] && mkdir -p "${dir}" 2>/dev/null
  done
}
_create_zsh_dirs
unfunction _create_zsh_dirs

# ====================================================================
# ENVIRONMENT CONFIGURATION
# ====================================================================

# Core application preferences
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-${EDITOR}}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"

# Development tools
export PNPM_HOME="${HOME}/Library/pnpm"

# PATH management - ensure unique entries and optimal order
typeset -U path
path=(
  "${PNPM_HOME}"
  "${HOME}/.local/bin"
  "${path[@]}"
)

# History configuration
HISTSIZE=50000
SAVEHIST=50000

# Less configuration
export LESS='-R --use-color -Dd+r$Du+b$'
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# ====================================================================
# ZSH OPTIONS & BEHAVIOR
# ====================================================================

# Navigation & Directory Options
setopt AUTO_CD                    # cd by typing directory name
setopt AUTO_PUSHD                 # Make cd push old directory to stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicate directories
setopt PUSHD_SILENT              # Don't print directory stack

# Globbing & Pattern Matching
setopt EXTENDED_GLOB             # Enable extended globbing
setopt GLOB_DOTS                 # Include dotfiles in glob patterns
setopt NUMERIC_GLOB_SORT         # Sort numeric globs numerically
setopt NO_NOMATCH                # Don't error on no glob matches

# Job Control
setopt NO_HUP                    # Don't kill jobs on shell exit
setopt CHECK_JOBS                # Check for running jobs before exit

# Input/Output
setopt CORRECT                   # Command spelling correction
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive mode
setopt MULTIOS                   # Enable multiple redirections

# History Management - Optimized for Development
setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first when trimming
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in search
setopt HIST_IGNORE_ALL_DUPS      # Remove all earlier duplicates
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to file
setopt HIST_VERIFY               # Show expansion before executing
setopt INC_APPEND_HISTORY        # Write history immediately
setopt SHARE_HISTORY             # Share between sessions

# Completion Options
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt AUTO_MENU                 # Show menu on successive tab
setopt COMPLETE_IN_WORD          # Complete from both ends
setopt MENU_COMPLETE             # Insert first match immediately

# Prompt Options
setopt PROMPT_SUBST              # Enable parameter expansion in prompts

# ====================================================================
# EXTERNAL TOOL INTEGRATIONS
# ====================================================================

# Homebrew Integration (macOS) - Lazy loaded
_setup_homebrew() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# Node Version Manager (fnm) - Lazy loaded
_setup_fnm() {
  if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd --shell zsh)"
  fi
}

# Initialize tools on first use
if [[ -z "$_TOOLS_INITIALIZED" ]]; then
  _setup_homebrew
  _setup_fnm
  export _TOOLS_INITIALIZED=1
fi

# ====================================================================
# KEY BINDINGS - EMACS MODE ENHANCED
# ====================================================================

# Set emacs key bindings
bindkey -e

# History navigation
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Enhanced word movement (macOS Terminal compatible)
bindkey '^[[1;5C' forward-word           # Ctrl+Right
bindkey '^[[1;5D' backward-word          # Ctrl+Left
bindkey '^[[1;3C' forward-word           # Alt+Right
bindkey '^[[1;3D' backward-word          # Alt+Left

# Line editing shortcuts
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' kill-whole-line
bindkey '^W' backward-kill-word
bindkey '^Y' yank

# Additional useful bindings
bindkey '^[[Z' reverse-menu-complete     # Shift+Tab for reverse completion
bindkey '^X^E' edit-command-line         # Ctrl+X Ctrl+E to edit in $EDITOR

# ====================================================================
# COMPLETION SYSTEM
# ====================================================================

# Completion function path setup
_setup_completion_path() {
  local comp_dirs=(
    "${ZSH_PLUGINS_DIR}/zsh-completions/src"
    "${HOMEBREW_PREFIX}/share/zsh/site-functions"
  )

  for dir in "${comp_dirs[@]}"; do
    [[ -d "${dir}" ]] && fpath=("${dir}" "${fpath[@]}")
  done
}
_setup_completion_path

# Initialize completion system with caching
autoload -Uz compinit
_comp_files=("${ZSH_COMPDUMP}"(Nm+24))
if (( $#_comp_files )); then
  compinit -i -d "${ZSH_COMPDUMP}"
else
  compinit -C -d "${ZSH_COMPDUMP}"
fi
unset _comp_files

# Completion styling and behavior
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/.zcompcache"
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Group matches and describe
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# Completion messages
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Process completion
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# ====================================================================
# PROMPT SYSTEM WITH VCS INFO
# ====================================================================

# Load VCS info module
autoload -Uz vcs_info

# VCS info configuration
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{242}%b%c%u%f'
zstyle ':vcs_info:git:*' actionformats ' %F{242}%b|%a%c%u%f'

# Intelligent path shortening
prompt_pwd() {
  local max_length=35
  local pwd_path="${PWD/#$HOME/~}"

  if (( ${#pwd_path} <= max_length )); then
    printf '%s' "${pwd_path}"
  else
    local IFS='/'
    local -a path_parts=("${(s:/:)pwd_path}")
    local result="${path_parts[1]}"

    if (( ${#path_parts} > 2 )); then
      result+="/.../${path_parts[-1]}"
    else
      result="${pwd_path}"
    fi
    printf '%s' "${result}"
  fi
}

# Pre-command hook for VCS info
precmd() {
  vcs_info
}

# Prompt definition
PROMPT='%F{cyan}$(prompt_pwd)%f${vcs_info_msg_0_:-} %F{magenta}%#%f '

# ====================================================================
# ALIASES - ORGANIZED BY CATEGORY
# ====================================================================

# System & Shell
alias c='clear'
alias h='history'
alias j='jobs'
alias reload='exec ${SHELL} -l'
alias path='printf "%s\n" ${path}'

# File Operations with Smart Defaults
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first'
  alias la='eza -la --group-directories-first'
  alias lt='eza -l --sort=modified --group-directories-first'
  alias tree='eza --tree'
else
  # Fallback to traditional ls with color support
  if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto --group-directories-first'
  elif [[ "${OSTYPE}" == darwin* ]]; then
    alias ls='ls -G'
  fi
  alias ll='ls -l'
  alias la='ls -la'
  alias lt='ls -lt'
fi

alias l='ls'
alias lh='ls -lh'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Safety aliases
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git Aliases - Comprehensive Workflow
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch --all'
alias gc='git commit'
alias gcm='git commit --message'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gs='git status --short --branch'
alias gst='git status'
alias glog='git log --oneline --graph --decorate'
alias gstash='git stash'
alias gpop='git stash pop'

# Modern CLI tool aliases
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v rg >/dev/null 2>&1 && alias grep='rg'
command -v fd >/dev/null 2>&1 && alias find='fd'

# Directory shortcuts (conditional)
[[ -d ~/.dotfiles ]] && alias cdd='cd ~/.dotfiles'
[[ -d ~/Projects ]] && alias cdp='cd ~/Projects'
[[ -d ~/Projects/work ]] && alias cdw='cd ~/Projects/work'

# ====================================================================
# UTILITY FUNCTIONS
# ====================================================================

# Create and change to directory
mcd() {
  [[ $# -ne 1 ]] && { echo "Usage: mcd <directory>" >&2; return 1; }
  mkdir -p "$1" && cd "$1"
}

# Enhanced archive extraction
extract() {
  [[ $# -ne 1 ]] && { echo "Usage: extract <archive>" >&2; return 1; }
  [[ ! -f "$1" ]] && { echo "Error: File not found: $1" >&2; return 1; }

  case "${1:l}" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.zip)            unzip "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.7z)             7z x "$1" ;;
    *)                echo "Error: Cannot extract '$1' - unsupported format" >&2; return 1 ;;
  esac
}

# Smart process killer
fkill() {
  [[ $# -eq 0 ]] && { echo "Usage: fkill <process_name>" >&2; return 1; }
  local pids
  pids=$(pgrep -f "$1")
  if [[ -n "${pids}" ]]; then
    echo "Killing processes: ${pids}"
    kill ${pids}
  else
    echo "No processes found matching: $1" >&2
    return 1
  fi
}

# Quick file finder
ff() {
  [[ $# -eq 0 ]] && { echo "Usage: ff <filename>" >&2; return 1; }
  if command -v fd >/dev/null 2>&1; then
    fd -H -I "$1"
  else
    find . -name "*$1*" 2>/dev/null
  fi
}

# Git worktree helper
gwt() {
  case "$1" in
    add)
      [[ $# -ne 3 ]] && { echo "Usage: gwt add <branch> <path>" >&2; return 1; }
      git worktree add "$3" "$2"
      ;;
    remove|rm)
      [[ $# -ne 2 ]] && { echo "Usage: gwt remove <path>" >&2; return 1; }
      git worktree remove "$2"
      ;;
    list|ls)
      git worktree list
      ;;
    *)
      echo "Usage: gwt {add|remove|list} [args...]" >&2
      return 1
      ;;
  esac
}

# ====================================================================
# PLUGIN MANAGEMENT SYSTEM
# ====================================================================

# Plugin definitions with repositories
typeset -A ZSH_PLUGINS
ZSH_PLUGINS=(
  "zsh-completions"         "zsh-users/zsh-completions"
  "zsh-autosuggestions"     "zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting" "zsh-users/zsh-syntax-highlighting"
  "fzf-tab"                 "Aloxaf/fzf-tab"
)

# Plugin installation function
_install_plugin() {
  local name="$1"
  local repo="$2"
  local plugin_dir="${ZSH_PLUGINS_DIR}/${name}"

  if [[ ! -d "${plugin_dir}" ]]; then
    printf "Installing %s...\n" "${name}"
    if git clone --depth=1 --quiet "https://github.com/${repo}.git" "${plugin_dir}" 2>/dev/null; then
      printf "✓ %s installed successfully\n" "${name}"
    else
      printf "✗ Failed to install %s\n" "${name}" >&2
      return 1
    fi
  fi
  return 0
}

# Install all plugins
_install_all_plugins() {
  local name repo
  for name repo in "${(@kv)ZSH_PLUGINS}"; do
    _install_plugin "${name}" "${repo}"
  done
}

# Auto-install plugins on first run
[[ ! -d "${ZSH_PLUGINS_DIR}/zsh-autosuggestions" ]] && _install_all_plugins

# Load plugins in optimal order
_load_plugins() {
  local plugins_to_load=(
    "${ZSH_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh"
    "${ZSH_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "${ZSH_PLUGINS_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  )

  for plugin in "${plugins_to_load[@]}"; do
    [[ -r "${plugin}" ]] && source "${plugin}"
  done
}

# Load plugins
_load_plugins

# Plugin configurations
[[ -n "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE}" ]] || ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
[[ -n "${ZSH_AUTOSUGGEST_STRATEGY}" ]] || ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ====================================================================
# FZF INTEGRATION (if available)
# ====================================================================

if command -v fzf >/dev/null 2>&1; then
  # Source FZF key bindings and completion
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

  # FZF configuration
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

  # Use fd for FZF if available
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ====================================================================
# PERFORMANCE OPTIMIZATION
# ====================================================================

# Clean up function definitions after use
unfunction _setup_homebrew _setup_fnm _setup_completion_path _install_plugin _install_all_plugins _load_plugins 2>/dev/null

# Rehash completion cache periodically
zstyle ':completion:*' rehash true

# ====================================================================
# LOCAL CONFIGURATION OVERRIDE
# ====================================================================

# Source local configuration if it exists
[[ -f "${XDG_CONFIG_HOME}/zsh/local.zsh" ]] && source "${XDG_CONFIG_HOME}/zsh/local.zsh"

# Per-directory configuration support
[[ -f "./.zshrc.local" ]] && source "./.zshrc.local"

# ====================================================================
# STARTUP PERFORMANCE REPORT
# ====================================================================

# Uncomment to see startup profiling results
# zprof
