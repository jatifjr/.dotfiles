#!/bin/zsh

# Profiling
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zmodload zsh/zprof

# Options
setopt \
    AUTO_CD AUTO_PUSHD CDABLE_VARS CD_SILENT PUSHD_IGNORE_DUPS PUSHD_SILENT \
    EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS \
    HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS HIST_VERIFY SHARE_HISTORY \
    EXTENDED_GLOB PROMPT_SUBST NO_BEEP NO_HUP INTERACTIVE_COMMENTS

# Key bindings
bindkey -e

# Prompt
autoload -Uz vcs_info; zstyle ':vcs_info:git:*' formats '%b '; precmd() { vcs_info; }
PS1='%F{242}%n@%m%f %F{blue}%1~%f %F{242}${vcs_info_msg_0_}%f%F{magenta}%#%f '

# Completion
autoload -Uz compinit
[[ -n "$ZDOTDIR" && -d "$ZDOTDIR" ]] &&
[[ /opt/local/share/zsh/site-functions -nt "$ZDOTDIR/.zcompdump" ]] &&
compinit -i || compinit -i -C
zstyle ':completion:*' menu select

# Plugins
[[ -d /opt/local/share ]] && for p in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -r "/opt/local/share/$p/$p.plugin.zsh" ]] && source "/opt/local/share/$p/$p.plugin.zsh"
done; unset p

# Functions
bench() { local t=$(mktemp -t zprof.XXXXXX); (time ZSH_PROFILING_ENABLE=1 zsh -i -c exit >$t) 2>&1; head -12 $t; rm -f $t }
colors() { for i in {0..15}; do printf "\e[48;5;${i}m %3d \e[0m" $i; (( (i+1)%8==0 )) && echo; done; }
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Alias
alias -- -='cd -'
alias cp='cp -i' mv='mv -i' rm='rm -i'
alias du='du -sh'
alias ls='ls --color' la='ls -la'
alias ga='git add' gb='git branch -vv' gc='git commit' gd='git diff'
alias gl='git log --graph --oneline' gs='git status -sb'
alias gsw='git switch' gwip='git commit -am "WIP"'
alias reload='exec zsh -l'
alias path='printf "%s\n" "${path[@]}"' fpath='printf "%s\n" "${fpath[@]}"'
alias top='top -stats pid,user,cpu,mem,command -o mem'
[[ -d "$HOME/.dotfiles" ]] && alias cdd='cd "$HOME/.dotfiles"'
[[ -d "$HOME/Projects" ]] && alias cdp='cd "$HOME/Projects"'

# End of profiling
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zprof
