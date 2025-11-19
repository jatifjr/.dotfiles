# --- Profiling ---
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zmodload zsh/zprof

# --- MacGNU ---
[[ -f ~/.macgnu ]] && . ~/.macgnu

# --- Plugins ---
__zsh_user_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
plugins=(
    mattmc3/zephyr
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-syntax-highlighting
)
zephyr_plugins=(
    environment
    homebrew
    color
    compstyle
    completion
    directory
    editor
    helper
    history
    utility
    macos
)
zstyle ':zephyr:load' plugins "${zephyr_plugins[@]}"
zstyle ':zephyr:plugin:*' 'use-cache' 'yes'
zplugin() {
    local repo name dir
    for repo in "${plugins[@]}"; do
        name="${repo##*/}"; dir="$__zsh_user_data_dir/plugins/$name"
        if [[ "$1" == "update" ]] || [[ ! -d "$dir" ]]; then
            [[ -d "$dir" ]] && {
                printf 'Updating %s...\n' "$name"
                git -C "$dir" pull --ff-only
            } || {
                printf 'Cloning %s...\n' "$name"
                git clone --quiet --depth 1 "https://github.com/$repo" "$dir"
            }
        fi
        [[ -f "$dir/$name.plugin.zsh" ]] && source "$dir/$name.plugin.zsh"
    done
}; zplugin

# --- Options ---
setopt auto_cd cdable_vars cd_silent

# --- Key bindings ---
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# --- Prompt ---
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '; precmd() { vcs_info; }
PS1='%F{8}%n@%m%f %F{4}%1~%f %F{8}${vcs_info_msg_0_}%f%F{5}%#%f '

# --- Alias ---
alias cp='cp -i' ln='ln -i' mv='mv -i' rm='rm -i'
alias fpath='printf "%s\n" "${fpath[@]}"' path='printf "%s\n" "${path[@]}"'
alias la='ls -lA'
alias topm='top -stats pid,cpu,mem,command -o mem'
if [[ -d "$HOME/Projects/personal/dotfiles" ]]; then
    alias cdd='cd "$HOME/Projects/personal/dotfiles"'
fi

# --- Toolchains ---
# volta (node.js)
export VOLTA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/volta"
export VOLTA_FEATURE_PNPM=1
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/.npmrc"

# --- Paths ---
path=(
    $VOLTA_HOME/bin
    $path
)

# --- End of profiling ---
zbench() {
    local t="$(mktemp -t zprof.XXXXXX)" || return
    { time ZSH_PROFILING_ENABLE=1 zsh -i -c exit >|"$t"; } 2>&1
    head -14 "$t"; rm -f "$t"
}
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zprof
