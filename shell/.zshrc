# Uncluttered Zsh config: fast, minimal, XDG-friendly

# Exit if not interactive
[[ -o interactive ]] || return

# Uncomment to enable profiling
if [[ -n "$ZSH_PROFILING" ]]; then
  zmodload zsh/zprof
fi

# --- XDG paths ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

# Cache dirs
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Create needed dirs
mkdir -p \
  "${ZSH_CACHE_DIR}" \
  "${XDG_STATE_HOME}/zsh" \
  "${XDG_CACHE_HOME}/less" \

# --- Environment / PATH ---
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"
# pnpm is installed in different locations on macOS and Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="${HOME}/Library/pnpm"
else
  export PNPM_HOME="${HOME}/.local/share/pnpm"
fi

typeset -U path
path=(
  "${PNPM_HOME}"
  "${HOME}/.local/bin"
  "${path[@]}"
)

HISTSIZE=50000
SAVEHIST=50000
export LESS='-RFXi'
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# --- Options ---
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt EXTENDED_GLOB GLOB_DOTS NUMERIC_GLOB_SORT NO_NOMATCH
setopt NO_HUP CHECK_JOBS INTERACTIVE_COMMENTS MULTIOS PROMPT_SUBST
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS \
       HIST_IGNORE_DUPS HIST_EXPIRE_DUPS_FIRST INC_APPEND_HISTORY SHARE_HISTORY HIST_VERIFY
setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD MENU_COMPLETE

# --- Tools (lazy) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  _setup_homebrew() {
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  }
fi

_setup_fnm() {
  command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"
}

_setup_zoxide() {
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
}

if [[ -z "$_TOOLS_INITIALIZED" ]]; then
  _setup_homebrew
  _setup_fnm
  _setup_zoxide
  export _TOOLS_INITIALIZED=1
fi

# --- Key bindings ---
bindkey -e

# --- Completion ---
skip_global_compinit=1

# Homebrew site-functions if available
if [[ "$OSTYPE" == "darwin"* && -n "${HOMEBREW_PREFIX}" && -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
  fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" "${fpath[@]}")
fi

autoload -Uz compinit
if [[ -e "${ZSH_COMPDUMP}" && -n ${ZSH_COMPDUMP}(Nm+24) ]]; then
  compinit -i -d "${ZSH_COMPDUMP}" || compinit -C -d "${ZSH_COMPDUMP}"
else
  compinit -C -d "${ZSH_COMPDUMP}" || compinit
fi

# Minimal, fast styles
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:commands' rehash 1

# --- Prompt (vcs_info) ---
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats ' %F{242}%b%c%u%f'
zstyle ':vcs_info:*' actionformats ' %F{242}%b|%a%c%u%f'

precmd() { vcs_info }
PROMPT='%F{cyan}%2~%f${vcs_info_msg_0_} %F{magenta}%#%f '

# --- Aliases ---
alias c='clear'
alias h='history'
alias j='jobs'
alias reload='exec ${SHELL} -l'
alias path='printf "%s\n" ${path}'

# ls (GNU vs BSD/macOS)
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

# grep (prefer ripgrep if available)
if command -v rg >/dev/null; then
  alias grep='rg'
fi

# find (prefer fd if available)
if command -v fd >/dev/null; then
  alias find='fd'
fi

# tailscale (if available)
if command -v tailscale >/dev/null; then
  alias ts='tailscale'
  alias tss='tailscale status'
fi

# cat (always smartcat, defined later in config)
alias cat='smartcat'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gs='git status --short --branch'
alias glog='git log --oneline --graph --decorate'

# cd to ~/.dotfiles if present
[[ -d ~/.dotfiles ]] && alias cdd='cd ~/.dotfiles'

# --- Utilities ---
mcd() { [[ $# -eq 1 ]] || { echo "Usage: mcd <dir>" >&2; return 1; }; mkdir -p "$1" && cd "$1"; }

extract() {
  [[ $# -eq 1 && -f $1 ]] || { echo "Usage: extract <archive>" >&2; return 1; }
  local file=$1
  case "${file:l}" in
    *.tar.bz2|*.tbz2)  tar xjf "$file" ;;
    *.tar.gz|*.tgz)    tar xzf "$file" ;;
    *.tar.xz|*.txz)    tar xJf "$file" ;;
    *.tar.zst)         command -v zstd >/dev/null && tar --zstd -xf "$file" || echo "zstd not installed" ;;
    *.tar)             tar xf "$file" ;;
    *.bz2)             bunzip2 "$file" ;;
    *.gz)              gunzip "$file" ;;
    *.rar)             command -v unrar >/dev/null && unrar x "$file" || echo "unrar not installed" ;;
    *.zip)             command -v unzip >/dev/null && unzip "$file" || echo "unzip not installed" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              command -v 7z >/dev/null && 7z x "$file" || echo "7z not installed" ;;
    *) echo "Unsupported archive type: $file" >&2; return 1 ;;
  esac
}

fkill() {
  [[ $# -gt 0 ]] || { echo "Usage: fkill <process>" >&2; return 1; }
  if ! command -v pgrep >/dev/null; then
    echo "Error: pgrep is not available on this system" >&2
    return 1
  fi

  local pids
  pids=$(pgrep -f "$1")
  if [[ -n $pids ]]; then
    echo "Killing: $pids"
    kill $pids
  else
    echo "No process found matching: $1" >&2
    return 1
  fi
}

ff() {
  [[ $# -gt 0 ]] || { echo "Usage: ff <file>" >&2; return 1; }

  if command -v fd >/dev/null; then
    fd -H -I "$1"
  elif command -v find >/dev/null; then
    find . -name "*$1*" 2>/dev/null
  else
    echo "Error: neither fd nor find is available" >&2
    return 1
  fi
}

smartcat() {
  [[ $# -gt 0 ]] || { command cat; return; }
  local total=0 f
  for f; do [[ -f $f ]] && (( total += $(wc -l < "$f") )); done
  [[ -t 1 && $total -gt $LINES ]] && command cat -- "$@" | less -RFXi || command cat -- "$@"
}

# --- Plugins (Antidote: fast static bundle) ---
ANTIDOTE_DIR="${XDG_DATA_HOME}/zsh/antidote"
if [[ ! -r "${ANTIDOTE_DIR}/antidote.zsh" ]]; then
  command -v git >/dev/null 2>&1 && git clone --depth=1 https://github.com/mattmc3/antidote "${ANTIDOTE_DIR}" >/dev/null 2>&1
fi
[[ -r "${ANTIDOTE_DIR}/antidote.zsh" ]] && source "${ANTIDOTE_DIR}/antidote.zsh"

ZSH_PLUGIN_LIST_FILE="${XDG_CONFIG_HOME}/zsh/plugins.txt"
if [[ ! -r "${ZSH_PLUGIN_LIST_FILE}" ]]; then
  mkdir -p "${XDG_CONFIG_HOME}/zsh"
  cat > "${ZSH_PLUGIN_LIST_FILE}" <<'EOF'
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
Aloxaf/fzf-tab
EOF
fi

ZSH_PLUGIN_BUNDLE="${ZSH_CACHE_DIR}/antidote_plugins.zsh"
if command -v antidote >/dev/null 2>&1; then
  if [[ ! -r "${ZSH_PLUGIN_BUNDLE}" || "${ZSH_PLUGIN_LIST_FILE}" -nt "${ZSH_PLUGIN_BUNDLE}" ]]; then
    antidote bundle < "${ZSH_PLUGIN_LIST_FILE}" >| "${ZSH_PLUGIN_BUNDLE}" 2>/dev/null || true
  fi
  [[ -r "${ZSH_PLUGIN_BUNDLE}" ]] && source "${ZSH_PLUGIN_BUNDLE}" || true
fi

: ${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:='fg=242'}
: ${ZSH_AUTOSUGGEST_STRATEGY:='history completion'}
alias plugins-edit="$EDITOR ${ZSH_PLUGIN_LIST_FILE}"
alias plugins-rebuild='antidote bundle < "${ZSH_PLUGIN_LIST_FILE}" >| "${ZSH_PLUGIN_BUNDLE}" && echo "Rebuilt: ${ZSH_PLUGIN_BUNDLE}"'

# --- Cleanup ---
unfunction _setup_homebrew _setup_fnm _setup_zoxide 2>/dev/null

# --- Profiling ---
if [[ -n "$ZSH_PROFILING" ]]; then
  zprof
fi
alias zprof='ZSH_PROFILING=1 zsh -i -c exit | head -n 12'
