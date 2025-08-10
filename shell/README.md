# Complete ZSH Configuration Guide

A modern, XDG-compliant ZSH configuration with automatic plugin management, custom prompt, and productivity enhancements.

## Table of Contents

1. [XDG Directory Setup](#xdg-directory-setup)
2. [Plugin Installation System](#plugin-installation-system)
3. [Environment Configuration](#environment-configuration)
4. [History Settings](#history-settings)
5. [Completions](#completions)
6. [Key Bindings](#key-bindings)
7. [Custom Prompt](#custom-prompt)
8. [Aliases](#aliases)
9. [Utility Functions](#utility-functions)
10. [Plugin Loading](#plugin-loading)

## XDG Directory Setup

Follows XDG Base Directory specification for clean home directory organization:

```bash
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
```

**Purpose**: Keeps configuration files organized and prevents home directory clutter.

**Locations**:

- Plugins: `~/.local/share/zsh/`
- Completion cache: `~/.cache/zsh/.zcompdump`
- History: `~/.local/state/zsh/history`

## Plugin Installation System

### Auto-Installation Overview

The configuration includes a sophisticated plugin manager that automatically downloads and installs ZSH plugins without requiring external tools like Oh My Zsh.

### How It Works

1. **Plugin Definition**: Plugins are defined in a simple array using GitHub repository format:

```bash
plugins=(
  "zsh-users/zsh-completions"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
  "Aloxaf/fzf-tab"
)
```

2. **Auto-Installation Loop**: The system checks if each plugin exists and clones missing ones:

```bash
for repo in "${plugins[@]}"; do
  dir="$ZSH_PLUGINS_DIR/${repo##*/}"
  if [[ ! -d "$dir" ]]; then
    echo "Installing ${repo##*/}..."
    git clone --depth=1 "https://github.com/$repo.git" "$dir" \
      || echo "Failed to install $repo"
  fi
done
```

### Key Features

- **Zero Dependencies**: Only requires `git` and standard shell utilities
- **Shallow Clones**: Uses `--depth=1` for faster downloads
- **Error Handling**: Graceful fallback if installation fails
- **One-Time Install**: Plugins are cached and only installed once
- **Parameter Expansion**: `${repo##*/}` extracts repository name from full path

### Installed Plugins

| Plugin                      | Purpose               | Features                                     |
| --------------------------- | --------------------- | -------------------------------------------- |
| **zsh-completions**         | Enhanced completions  | 200+ additional completion definitions       |
| **zsh-autosuggestions**     | Fish-like suggestions | History-based command suggestions            |
| **zsh-syntax-highlighting** | Command highlighting  | Real-time syntax coloring                    |
| **fzf-tab**                 | Fuzzy completions     | Interactive fuzzy finding for tab completion |

### Adding New Plugins

1. Add repository to the `plugins` array
2. Add source line in the plugins section
3. Reload shell: `source ~/.zshrc`

### Manual Management

```bash
# Update specific plugin
cd ~/.local/share/zsh/plugin-name && git pull

# Remove plugin
rm -rf ~/.local/share/zsh/plugin-name

# Reinstall all plugins
rm -rf ~/.local/share/zsh/* && source ~/.zshrc
```

## Environment Configuration

Sets up essential development tools and package managers:

- **Editor**: `EDITOR="nvim"`
- **Homebrew**: Auto-detects and initializes on macOS
- **Node Version Manager**: Loads NVM if available
- **pnpm**: Configures PATH for pnpm package manager

**Auto-detection**: Only loads tools that are actually installed, preventing errors on different systems.

## History Settings

Optimized history configuration for productivity:

```bash
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory \
       hist_ignore_space hist_ignore_all_dups hist_save_no_dups
```

**Features**:

- 5,000 command history
- Shared history across sessions
- Ignores duplicates and commands starting with space
- Persistent history in XDG-compliant location

## Completions

Enhanced completion system with case-insensitive matching:

- Uses `zsh-completions` plugin for additional definitions
- Case-insensitive completion: `m:{a-z}={A-Za-z}`
- Integrates with `fzf-tab` for fuzzy completion
- XDG-compliant completion dump location

## Key Bindings

Simple configuration using Emacs-style key bindings:

```bash
bindkey -e  # Emacs mode
```

**Navigation**: Standard Emacs keybindings (Ctrl+A, Ctrl+E, Ctrl+R, etc.)

## Custom Prompt

Minimalist two-line prompt with git integration:

### Features

- **Smart Path Display**: Truncates long paths intelligently
- **Git Branch**: Shows current branch with dirty indicator (\*)
- **Color Coding**: Cyan for path, gray for git, magenta for prompt
- **Safe Display**: Handles edge cases gracefully

### Format

```
~/current/directory main*
❯
```

### Implementation

- `safe_pwd()`: Intelligent path truncation
- `git_branch()`: Git status with dirty indicator
- Prompt substitution enabled with `setopt prompt_subst`

## Aliases

Productivity-focused aliases organized by category:

### System

- `c='clear'`
- `ls` with color support (cross-platform)
- `la='ls -la'`, `ll='ls -l'`

### Git Shortcuts

- `ga='git add'`, `gc='git commit'`
- `gs='git status'`, `gp='git push'`
- `gco='git checkout'`, `gres='git restore'`

### Navigation

- `..='cd ..'`, `...='cd ../..'`
- `reload='source ~/.zshrc'`
- `cdd='cd ~/.dotfiles'`

## Utility Functions

### `mcd()` - Make and Change Directory

```bash
mcd() { mkdir -p "$1" && cd "$1" || return; }
```

Creates a directory and immediately changes into it. Includes error handling.

## Plugin Loading

Plugins are loaded in specific order for proper functionality:

1. **fzf-tab**: Loaded after `compinit` for completion integration
2. **zsh-autosuggestions**: Loaded before syntax highlighting
3. **zsh-syntax-highlighting**: Must be loaded last for proper highlighting

Each plugin uses conditional loading to prevent errors if installation failed.

## Installation & Usage

1. **Automatic Setup**: Simply source the `.zshrc` file
2. **First Run**: Plugins will be automatically installed
3. **Reload**: Use `reload` alias or `source ~/.zshrc`
4. **Updates**: Plugins remain at installed version for stability

## Benefits

- **Zero Configuration**: Works immediately on any system
- **Performance**: Minimal overhead with efficient loading
- **Maintainable**: Clear structure and documentation
- **Portable**: Works across different Unix systems
- **Extensible**: Easy to add new plugins and features

This configuration provides a robust, feature-rich ZSH experience while maintaining simplicity and performance.
