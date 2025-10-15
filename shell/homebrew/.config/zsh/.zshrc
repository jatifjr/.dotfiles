#!/bin/zsh

# Profiling
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zmodload zsh/zprof

# Options
setopt \
    AUTO_CD AUTO_PUSHD NO_BEEP CDABLE_VARS CD_SILENT EXTENDED_GLOB EXTENDED_HISTORY \
    HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE \
    HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS HIST_VERIFY NO_HUP INTERACTIVE_COMMENTS \
    PROMPT_SUBST PUSHD_IGNORE_DUPS PUSHD_SILENT SHARE_HISTORY

# Key bindings
bindkey -e
bindkey '^D' delete-char
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '
precmd() { vcs_info; }
PS1='%F{242}%n@%m%f %F{blue}%1~%f %F{242}${vcs_info_msg_0_}%f%F{magenta}%#%f '

# Completion
autoload -Uz compinit
[[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
[[ -n "$ZDOTDIR" && -d "$ZDOTDIR" ]] && {
  [[ "$HOMEBREW_PREFIX/share/zsh-completions" -nt "$ZDOTDIR/.zcompdump" ]] ||
  [[ "$HOMEBREW_PREFIX/share/zsh/site-functions" -nt "$ZDOTDIR/.zcompdump" ]]
} && compinit -i -d "$ZDOTDIR/.zcompdump" || compinit -i -C

# Plugins
# if command -v fzf >/dev/null 2>&1; then
#   FZF_TAB_HOME="${XDG_DATA_HOME}/fzf-tab"
#   [[ -r "${FZF_TAB_HOME}/fzf-tab.zsh" ]] || {
#     mkdir -p "${XDG_DATA_HOME}" || return
#     [[ -d "${FZF_TAB_HOME}/.git" ]] && git -C "${FZF_TAB_HOME}" pull --quiet --depth=1 ||
#     { rm -rf "${FZF_TAB_HOME}" 2>/dev/null; git clone --quiet --depth=1 https://github.com/Aloxaf/fzf-tab.git "${FZF_TAB_HOME}" || return; }
#   }
#   [[ -r "${FZF_TAB_HOME}/fzf-tab.zsh" ]] && {
#     source "${FZF_TAB_HOME}/fzf-tab.zsh"
#     zstyle ':completion:*' menu no
#     zstyle ':completion:*:git-checkout:*' sort false
#     zstyle ':fzf-tab:*' fzf-flags --height=-1
#     zstyle ':fzf-tab:*' use-fzf-default-opts yes
#     zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
#   }; unset FZF_TAB_HOME
# fi
source "${XDG_DATA_HOME}/fzf-tab/fzf-tab.zsh"
[[ -d "$HOMEBREW_PREFIX/share" ]] && for p in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -r "$HOMEBREW_PREFIX/share/$p/$p.zsh" ]] && source "$HOMEBREW_PREFIX/share/$p/$p.zsh"
done; unset p

# Functions
bench() { local t=$(mktemp -t zprof.XXXXXX); ( time ZSH_PROFILING_ENABLE=1 zsh -i -c exit >"$t" ) 2>&1; head -12 -- "$t"; rm -f -- "$t"; }
colors() { local i; for i in {0..15}; do printf "\e[48;5;${i}m %3d \e[0m" "$i"; (( (i+1)%8==0 )) && echo; done; }
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Alias
alias -- -='cd -'
alias cp='cp -i' mv='mv -i' rm='rm -i'
alias du='du -sh'
alias ls='ls --color=auto' la='ls -la'
alias ga='git add' gb='git branch -vv' gc='git commit' gd='git diff'
alias gl='git log --graph --oneline' gs='git status -sb'
alias gsw='git switch' gwip='git commit -am "WIP"'
alias reload='exec /bin/zsh -l'
alias path='printf "%s\n" "${path[@]}"' fpath='printf "%s\n" "${fpath[@]}"'
alias top='top -stats pid,user,cpu,mem,command -o mem'
[[ -d "$HOME/.dotfiles" ]] && alias cdd='cd "$HOME/.dotfiles"'
[[ -d "$HOME/Projects" ]] && alias cdp='cd "$HOME/Projects"'

# End of profiling
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zprof
