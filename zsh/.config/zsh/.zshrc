# --- Profiling ---
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zmodload zsh/zprof

# --- Plugins ---
__zsh_user_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
plugins=(
  mattmc3/zephyr
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
)
zstyle ':zephyr:plugin:confd' skip 'yes'
zstyle ':zephyr:plugin:prompt' skip 'yes'
zstyle ':zephyr:plugin:*' 'use-cache' 'yes'
for r in "${plugins[@]}"; do
  s="${r##*/}"; d="$__zsh_user_data_dir/$s";
  [[ -d "$d/.git" ]] || {
      printf 'Cloning %s...\n' "$s"
      git clone --depth=1 "https://github.com/$r" "$d" 2>/dev/null
  }; f="$d/$s.plugin.zsh"; [[ -r $f ]] && source "$f"
done; unset r s d f

# --- Custom fpath ---
fpath+=("$HOME/.local/share/zsh/site-functions")

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
alias la='ls -la'
alias reload='exec $SHELL -l'
alias top='top -stats pid,user,cpu,mem,command -o mem'
[[ -d "$HOME/.config" ]] && alias cdc='cd "$HOME/.config"'
[[ -d "$HOME/.dotfiles" ]] && alias cdd='cd "$HOME/.dotfiles"'
[[ -d "$HOME/Projects" ]] && alias cdp='cd "$HOME/Projects"'

# --- Toolchains ---
# Rust (rustup/cargo)
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"

# Go
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go"
export GOENV="${XDG_CONFIG_HOME:-$HOME/.config}/go/env"

# Node.js (volta)
export VOLTA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/volta"
export VOLTA_FEATURE_PNPM=1

# Python (uv)
export UV_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/uv"
export UV_INSTALL_DIR="$UV_HOME/bin"
export UV_PYTHON_BIN_DIR="$UV_HOME/bin"
export UV_TOOL_BIN_DIR="$UV_HOME/bin"
export UV_NO_MODIFY_PATH=1

# --- Paths ---
path=(
    $CARGO_HOME/bin
    $GOPATH/bin
    $VOLTA_HOME/bin
    $UV_HOME/bin
    $path
)

# --- End of profiling ---
zbench() {
    local t="$(mktemp -t zprof.XXXXXX)" || return
    { time ZSH_PROFILING_ENABLE=1 zsh -i -c exit >|"$t"; } 2>&1
    head -14 "$t"; rm -f "$t"
}
[[ -n "$ZSH_PROFILING_ENABLE" ]] && zprof
