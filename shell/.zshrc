# --- Exit if not interactive ---
[[ -o interactive ]] || return

# --- Begin Profiling ---
[[ -n "$ZSH_PROFILING" ]] && zmodload zsh/zprof

# --- History ---
HISTSIZE=100000
SAVEHIST=100000

# --- Zsh options ---
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt EXTENDED_GLOB GLOB_DOTS NUMERIC_GLOB_SORT NO_NOMATCH
setopt NO_HUP CHECK_JOBS INTERACTIVE_COMMENTS MULTIOS PROMPT_SUBST
setopt EXTENDED_HISTORY HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS \
       HIST_IGNORE_DUPS HIST_EXPIRE_DUPS_FIRST INC_APPEND_HISTORY SHARE_HISTORY HIST_VERIFY
setopt ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD MENU_COMPLETE

# --- Key bindings ---
bindkey -e

# --- Completion ---
skip_global_compinit=1
[[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
autoload -Uz compinit
if [[ -e "$ZSH_COMPDUMP" && -n ${ZSH_COMPDUMP}(Nm+24) ]]; then
  compinit -i -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:commands' rehash 1

# --- Prompt ---
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats ' %b%c%u'
zstyle ':vcs_info:*' actionformats ' %b|%a%c%u'

precmd() { vcs_info }
PROMPT='%F{cyan}%2~%f%F{242}${vcs_info_msg_0_}%f %F{magenta}%#%f '

# --- Aliases ---
alias c='clear'
alias h='history'
alias j='jobs'
alias reload='exec ${SHELL} -l'
alias path='printf "%s\n" ${path}'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

alias cat='smartcat'
command -v rg >/dev/null 2>&1 && alias grep='rg'
command -v fd >/dev/null 2>&1 && alias find='fd'
command -v tailscale >/dev/null 2>&1 && alias ts='tailscale'

alias g='git'
alias ga='git add'
alias gb='git br'
alias gc='git ci'
alias gl='git lg'
alias gs='git st'
alias gsw='git sw'

[[ -d ~/.dotfiles ]] && alias cdd='cd ~/.dotfiles'

# --- Functions ---
ZSH_FUNCTIONS_DIR="$XDG_CONFIG_HOME/zsh/functions"

if [[ -d "$ZSH_FUNCTIONS_DIR" ]]; then
  for f in "$ZSH_FUNCTIONS_DIR"/*.zsh; do
    [[ -r "$f" ]] && source "$f"
  done
fi

# --- Plugins (Antidote) ---
ANTIDOTE_DIR="$XDG_DATA_HOME/zsh/antidote"
ZSH_PLUGIN_LIST_FILE="$XDG_CONFIG_HOME/zsh/plugins.txt"
ZSH_PLUGIN_BUNDLE="$ZSH_CACHE_DIR/antidote_plugins.zsh"

if [[ ! -r "$ANTIDOTE_DIR/antidote.zsh" ]] && command -v git >/dev/null 2>&1; then
  git clone --depth=1 https://github.com/mattmc3/antidote "$ANTIDOTE_DIR" >/dev/null 2>&1
fi
[[ -r "$ANTIDOTE_DIR/antidote.zsh" ]] && source "$ANTIDOTE_DIR/antidote.zsh"

if command -v antidote >/dev/null 2>&1; then
  if [[ ! -r "$ZSH_PLUGIN_BUNDLE" || "$ZSH_PLUGIN_LIST_FILE" -nt "$ZSH_PLUGIN_BUNDLE" ]]; then
    antidote bundle < "$ZSH_PLUGIN_LIST_FILE" >| "$ZSH_PLUGIN_BUNDLE" 2>/dev/null || true
  fi
fi
if [[ -r "$ZSH_PLUGIN_BUNDLE" ]]; then
  source "$ZSH_PLUGIN_BUNDLE" || true
fi

# --- End Profiling ---
[[ -n "$ZSH_PROFILING" ]] && zprof
alias zprof='ZSH_PROFILING=1 zsh -i -c exit | head -n 12'
