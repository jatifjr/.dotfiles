# Dotfiles Management with GNU Stow

This repository contains my personal dotfiles, organized for easy management with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
~/.dotfiles/
├── config/          # Application configurations
│   └── .config/
│       ├── aerospace/
│       ├── alacritty/
│       ├── ghostty/
│       ├── karabiner/
│       ├── nvim/
│       └── zed/
├── shell/           # Shell configurations
│   ├── .zshrc
│   └── .p10k.zsh
└── git/             # Git configurations
    ├── .gitconfig
    └── .gitignore
```

## Usage

### Prerequisites

Install GNU Stow:
```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow
```

### Stowing Packages

Navigate to the dotfiles directory and stow the desired packages:

```bash
cd ~/.dotfiles

# Stow all configurations
stow config shell git

# Or stow individual packages
stow config     # Links ~/.config/* to dotfiles
stow shell      # Links shell configs to home directory
stow git        # Links git configs to home directory

# Stow everything at once
stow */
```

### Unstowing Packages

To remove symlinks (unstow):

```bash
# Unstow specific packages
stow -D config shell git

# Unstow everything
stow -D */
```

### Restowing Packages

To update existing symlinks after making changes:

```bash
# Restow specific packages
stow -R config

# Restow everything
stow -R */
```

## What Gets Linked

After stowing, you'll have these symlinks:

- `~/.config/aerospace/` → `~/.dotfiles/config/.config/aerospace/`
- `~/.config/alacritty/` → `~/.dotfiles/config/.config/alacritty/`
- `~/.config/ghostty/` → `~/.dotfiles/config/.config/ghostty/`
- `~/.config/karabiner/` → `~/.dotfiles/config/.config/karabiner/`
- `~/.config/nvim/` → `~/.dotfiles/config/.config/nvim/`
- `~/.config/zed/` → `~/.dotfiles/config/.config/zed/`
- `~/.zshrc` → `~/.dotfiles/shell/.zshrc`
- `~/.p10k.zsh` → `~/.dotfiles/shell/.p10k.zsh`
- `~/.gitconfig` → `~/.dotfiles/git/.gitconfig`
- `~/.gitignore` → `~/.dotfiles/git/.gitignore`

## Useful Commands

```bash
# Dry run (simulate without making changes)
stow -n config

# Verbose output (see what's being linked)
stow -v config

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

- **AeroSpace**: Tiling window manager
- **Alacritty**: Terminal emulator
- **Ghostty**: Terminal emulator
- **Karabiner**: Key remapping
- **Neovim**: Text editor
- **Zed**: Code editor
- **Zsh**: Shell with Powerlevel10k theme
- **Git**: Version control
