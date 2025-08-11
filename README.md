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

### Available Packages

The following packages are available for stowing:

- `config` - Application configurations (goes to ~/.config/)
- `shell` - Shell configurations (.zshrc, etc.)
- `git` - Git configurations (.gitconfig, etc.)

### Stowing Packages

Navigate to the dotfiles directory and stow the desired packages:

```bash
cd ~/.dotfiles
```

```bash
# Stow individual packages
stow config     # Links ~/.config/* to dotfiles
```

```bash
# Stow multiple specific packages
stow config shell git
```

### Unstowing Packages

To remove symlinks (unstow):

```bash
# Unstow specific packages
stow -D config shell git
```

```bash
# Unstow individual packages
stow -D config
```

### Restowing Packages

To update existing symlinks after making changes:

```bash
# Restow specific packages
stow -R config shell git
```

```bash
# Restow individual packages
stow -R config
```

## What Gets Linked

After stowing the packages, you'll have these symlinks:

- `~/.config/ghostty/` → `~/.dotfiles/config/.config/ghostty/`
- `~/.config/nvim/` → `~/.dotfiles/config/.config/nvim/`
- `~/.gitconfig` → `~/.dotfiles/git/.gitconfig`
- `~/.gitignore_global` → `~/.dotfiles/git/.gitignore_global`
- `~/.zshrc` → `~/.dotfiles/shell/.zshrc`
- ...

## Useful Commands

```bash
# Dry run (simulate without making changes)
stow -n config shell git
```

```bash
# Verbose output (see what's being linked)
stow -v config shell git
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

1. Back up the existing file:

   ```bash
   mv ~/.config/app/config ~/.config/app/config.backup
   ```

2. Stow the package:

   ```bash
   stow config
   ```

3. Compare and merge if needed

### Broken Symlinks

To find and remove broken symlinks:

```bash
find ~ -type l ! -exec test -e {} \; -print | grep dotfiles
```

### List Available Packages

To see what packages are available to stow:

```bash
ls -d */ | sed 's|/||'
```

## Applications Configured

- **Ghostty**: Terminal emulator
- **Neovim**: Text editor
- **Git**: Version control
- **Zsh**: Shell

## Best Practices

- Always specify package names explicitly when stowing
- Use dry run (`-n`) flag to preview changes before applying
- Keep packages logically organized (one per application/category)
- Regularly check for broken symlinks after updates
