# Uncluttered Zsh config: fast, minimal, XDG-friendly

# Exit if not interactive
[[ -o interactive ]] || return

# Uncomment to enable profiling
zmodload zsh/zprof

# --- XDG paths ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# Common dirs
export PROJECTS_DIR="${HOME}/Projects"
export WORK_DIR="${HOME}/Projects/work"

# Create needed dirs
mkdir -p \
  "${ZSH_CACHE_DIR}" \
  "${XDG_STATE_HOME}/zsh" \
  "${XDG_CACHE_HOME}/less" \
  "${PROJECTS_DIR}" \
  "${WORK_DIR}"

# --- Environment / PATH ---
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"
export PNPM_HOME="${HOME}/Library/pnpm"

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
_setup_homebrew() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

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
if [[ -n "${HOMEBREW_PREFIX}" && -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
  fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" "${fpath[@]}")
fi

autoload -Uz compinit
if [[ -e "${ZSH_COMPDUMP}" && -n ${ZSH_COMPDUMP}(Nm+24) ]]; then
  compinit -i -d "${ZSH_COMPDUMP}"
else
  compinit -C -d "${ZSH_COMPDUMP}"
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

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

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

# Prefer fast tools if present
alias cat='smartcat'
command -v rg >/dev/null 2>&1 && alias grep='rg'
command -v fd >/dev/null 2>&1 && alias find='fd'
[[ -d ~/.dotfiles ]] && alias cdd='cd ~/.dotfiles'

# --- Utilities ---
mcd() { [[ $# -eq 1 ]] || { echo "Usage: mcd <dir>" >&2; return 1; }; mkdir -p "$1" && cd "$1"; }

extract() {
  [[ $# -eq 1 && -f $1 ]] || { echo "Usage: extract <archive>" >&2; return 1; }
  case "${1:l}" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf  "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip  "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.zip)            unzip   "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.7z)             7z x "$1" ;;
    *) echo "Unsupported: $1" >&2; return 1 ;;
  esac
}

fkill() {
  [[ $# -gt 0 ]] || { echo "Usage: fkill <process>" >&2; return 1; }
  local pids; pids=$(pgrep -f "$1")
  [[ -n $pids ]] && { echo "Killing: $pids"; kill $pids; } || { echo "No process: $1" >&2; return 1; }
}

ff() { [[ $# -gt 0 ]] || { echo "Usage: ff <file>" >&2; return 1; }; command -v fd &>/dev/null && fd -H -I "$1" || find . -name "*$1*" 2>/dev/null; }

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
    antidote bundle < "${ZSH_PLUGIN_LIST_FILE}" >| "${ZSH_PLUGIN_BUNDLE}"
  fi
  [[ -r "${ZSH_PLUGIN_BUNDLE}" ]] && source "${ZSH_PLUGIN_BUNDLE}"
fi

: ${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:='fg=242'}
: ${ZSH_AUTOSUGGEST_STRATEGY:='history completion'}
alias plugins-edit="$EDITOR ${ZSH_PLUGIN_LIST_FILE}"
alias plugins-rebuild='antidote bundle < "${ZSH_PLUGIN_LIST_FILE}" >| "${ZSH_PLUGIN_BUNDLE}" && echo "Rebuilt: ${ZSH_PLUGIN_BUNDLE}"'

# --- Cleanup ---
unfunction _setup_homebrew _setup_fnm _setup_zoxide 2>/dev/null

# --- Profiling ---
zprof
