# Exit if non-interactive
[[ -o interactive ]] || return

# Optional profiling
[[ -n "$ZSH_PROFILING" ]] && zmodload zsh/zprof

# History
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS HIST_IGNORE_DUPS \
       HIST_EXPIRE_DUPS_FIRST INC_APPEND_HISTORY SHARE_HISTORY HIST_VERIFY EXTENDED_HISTORY

# Core options
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT EXTENDED_GLOB GLOB_DOTS \
       NUMERIC_GLOB_SORT NO_NOMATCH NO_HUP CHECK_JOBS INTERACTIVE_COMMENTS MULTIOS \
       PROMPT_SUBST ALWAYS_TO_END AUTO_MENU COMPLETE_IN_WORD MENU_COMPLETE

# Keymap
bindkey -e

# Completion
skip_global_compinit=1
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
autoload -Uz compinit
if [[ -e "$ZSH_COMPDUMP" && -n $(print -r -- "$ZSH_COMPDUMP"(Nm+24) 2>/dev/null) ]]; then
  compinit -i -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:commands' rehash 1

# Colors
autoload -U colors && colors

# Prompt (with git branch/status)
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' formats ' %b%c%u'
zstyle ':vcs_info:*' actionformats ' %b|%a%c%u'
precmd() { vcs_info }
PROMPT='%F{14}%2~%f%F{7}${vcs_info_msg_0_}%f %F{13}%#%f '

# Aliases
alias c='clear' h='history' j='jobs' reload='exec $SHELL -l' path='printf "%s\n" "${path[@]}"'
alias ..='cd ..' ...='cd ../..' -- -='cd -'
alias cp='cp -i' mv='mv -i' rm='rm -i'
alias ls='ls -G' ll='ls -l' la='ls -la' lh='ls -lh'
[[ -n $commands[rg] ]] && alias grep='rg'
[[ -n $commands[fd] ]] && alias find='fd'
[[ -n $commands[tailscale] ]] && alias ts='tailscale'
alias ga='git add' gb='git b' gc='git c' gd='git d'
alias gl='git l' gs='git s' gsw='git sw' gwip='git wip'
[[ -d "$HOME/.dotfiles" ]] && alias cdd='cd ~/.dotfiles'

# Plugins (Antidote)
ANTIDOTE_DIR="$XDG_DATA_HOME/zsh/antidote"
ANTIDOTE_BUNDLE="$ZSH_CACHE_DIR/antidote_plugins.zsh"
ANTIDOTE_PLUGINS=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  Aloxaf/fzf-tab
)
if [[ ! -r "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  command -v git >/dev/null || return
  git clone --depth=1 https://github.com/mattmc3/antidote "$ANTIDOTE_DIR" >/dev/null 2>&1 || return
fi
source "$ANTIDOTE_DIR/antidote.zsh" || return
if [[ ! -r "$ANTIDOTE_BUNDLE" || "$(command ls -1t "${ANTIDOTE_DIR}/plugins" 2>/dev/null | head -1)" -nt "$ANTIDOTE_BUNDLE" ]]; then
  printf '%s\n' "${ANTIDOTE_PLUGINS[@]}" | antidote bundle >| "$ANTIDOTE_BUNDLE" 2>/dev/null
fi
source "$ANTIDOTE_BUNDLE" || true

# End profiling
[[ -n "$ZSH_PROFILING" ]] && zprof
alias zprof='ZSH_PROFILING=1 zsh -i -c exit | head -n 12 && unset ZSH_PROFILING'
