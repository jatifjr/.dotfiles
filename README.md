# Dotfiles Management with GNU Stow

This repository contains my personal dotfiles, organized for easy management with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
~/.dotfiles/
├── config/          # Application configurations
│   └── .config/
│       ├── ghostty/
│       ├── nvim/
│       └── ...
├── git/             # Git configurations
│   ├── .gitconfig
│   ├── .gitignore_global
│   └── ...
├── shell/           # Shell configurations
│   ├── .zshrc
│   └── ...
└── ...
```

## Usage

### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow
```

```bash
# Ubuntu/Debian
sudo apt install stow
```

### Stowing Packages

Navigate to the dotfiles directory and stow the desired packages:

```bash
cd ~/.dotfiles

# Stow all configurations
stow config shell git
```

```bash
# Or stow individual packages
stow config     # Links ~/.config/* to dotfiles
stow shell      # Links shell configs to home directory
stow git        # Links git configs to home directory
```

```bash
# Stow everything at once
stow */
```

### Unstowing Packages

To remove symlinks (unstow):

```bash
# Unstow specific packages
stow -D config shell git
```

```bash
# Unstow everything
stow -D */
```

### Restowing Packages

To update existing symlinks after making changes:

```bash
# Restow specific packages
stow -R config
```

```bash
# Restow everything
stow -R */
```

## What Gets Linked

After stowing, you'll have these symlinks:

- `~/.config/ghostty/` → `~/.dotfiles/config/.config/ghostty/`
- `~/.config/nvim/` → `~/.dotfiles/config/.config/nvim/`
- `~/.gitconfig` → `~/.dotfiles/git/.gitconfig`
- `~/.gitignore_global` → `~/.dotfiles/git/.gitignore_global`
- `~/.zshrc` → `~/.dotfiles/shell/.zshrc`
- ...

## Useful Commands

```bash
# Dry run (simulate without making changes)
stow -n config
```

```bash
# Verbose output (see what's being linked)
stow -v config
```

```bash
# Check what's currently stowed
find ~ -type l -ls | grep dotfiles
```

## Adding New Configurations

1. Create the appropriate directory structure in the relevant package
2. Add your configuration files
3. Restow the package: `stow -R <package-name>`

## Troubleshooting

### Conflicts with Existing Files

If you get conflicts with existing files:

1. Back up the existing file: `mv ~/.config/app/config ~/.config/app/config.backup`
2. Stow the package: `stow config`
3. Compare and merge if needed

### Broken Symlinks

To find and remove broken symlinks:

```bash
find ~ -type l ! -exec test -e {} \; -print | grep dotfiles
```

## Applications Configured

- **Ghostty**: Terminal emulator
- **Neovim**: Text editor
- **Git**: Version control
- **Zsh**: Shell
