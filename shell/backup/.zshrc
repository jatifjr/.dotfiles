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
# bindkey '^P' history-beginning-search-backward
# bindkey '^N' history-beginning-search-forward

# Prompt
autoload -Uz vcs_info; zstyle ':vcs_info:git:*' formats '%b '; precmd() { vcs_info; }
PS1='%F{242}%n@%m%f %F{blue}%1~%f %F{242}${vcs_info_msg_0_}%f%F{magenta}%#%f '

# Completion
# setopt NO_AUTO_MENU NO_LIST_BEEP
autoload -Uz compinit
[[ -n "$ZDOTDIR" && -d "$ZDOTDIR" ]] && {
    [[ "$HOMEBREW_PREFIX/share/zsh/site-functions" -nt "$ZDOTDIR/.zcompdump" ]]
    [[ "$XDG_DATA_HOME/zsh-completions/src" -nt "$ZDOTDIR/.zcompdump" ]]
} && compinit -i || compinit -i -C
zstyle ':completion:*' menu select

# Enable selection with arrow keys in the completion menu

# Group results by category (commands, files, directories, etc.)
# zstyle ':completion:*' group-name ''

# Enable approximate matches for completion
# zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# Other useful styles for a more informative completion menu
# zstyle ':completion:*' list-colors '' # Use colors for different file types
# zstyle ':completion:*:descriptions' format '%B%d%b' # Bold descriptions
# zstyle ':completion:*:messages' format '%d' # Show messages
# zstyle ':completion:*:warnings' format '%B%d%b' # Bold warnings
# zstyle ':completion:*:default' list-prompt '%S%M%P%s' # Customize list prompt


# Plugins
# command -v fzf >/dev/null 2>&1 && {
#     (( $+_comps )) || return
#     FZF_TAB_HOME="${XDG_DATA_HOME}/fzf-tab"
#     [[ -r "${FZF_TAB_HOME}/fzf-tab.zsh" ]] && {
#         source "${FZF_TAB_HOME}/fzf-tab.zsh"
#         zstyle ':completion:*' menu no
#         zstyle ':completion:*:git-checkout:*' sort no
#         zstyle ':fzf-tab:*' fzf-flags --height=-1
#         zstyle ':fzf-tab:*' use-fzf-default-opts yes
#         zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
#     }
# }
zsh_plugins=(fzf-tab zsh-autosuggestions zsh-completions zsh-syntax-highlighting)
[[ -d "$XDG_DATA_HOME" ]] && for p in $zsh_plugins; do
  [[ -r "$XDG_DATA_HOME/$p/$p.plugin.zsh" ]] &&
  source "$XDG_DATA_HOME/$p/$p.plugin.zsh"
done; unset p

# Functions
bench() {
    local t=$(mktemp -t zprof.XXXXXX)
    (time ZSH_PROFILING_ENABLE=1 zsh -i -c exit >$t) 2>&1
    head -12 $t; rm -f $t
}
colors() {
  local i; for i in {0..15}; do
    printf $'\e[48;5;%sm %3s \e[0m' "$i" "$i"
    (( (i+1) % 8 == 0 )) && echo
  done
}
mcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Alias
alias -- -='cd -'
alias cp='cp -i' mv='mv -i' rm='rm -i'
alias du='du -sh'
alias ls='ls --color' la='ls -la'
alias ga='git add' gb='git branch -vv' gc='git commit' gd='git diff'
alias gl='git log --graph --oneline' gs='git status -sb'
alias gsw='git switch' gwip='git commit -am "WIP"'
alias reload='exec $SHELL -l'
alias path='printf "%s\n" "${path[@]}"' fpath='printf "%s\n" "${fpath[@]}"'
alias top='top -stats pid,user,cpu,mem,command -o mem'
[[ -d "$HOME/.dotfiles" ]] && alias cdd='cd "$HOME/.dotfiles"'
[[ -d "$HOME/Projects" ]] && alias cdp='cd "$HOME/Projects"'

# End of profiling
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zprof
