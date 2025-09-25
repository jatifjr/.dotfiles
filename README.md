# My macOS Dotfiles

**Note:** This dotfiles setup is specifically tailored for macOS. While some configurations might be adaptable to other Unix-like systems, the instructions and recommended software are macOS-centric.

This repository contains my personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/). Stow creates symlinks from this repository to the correct locations in your home directory.

## Table of Contents

- [Structure](#structure)
- [Platform](#platform)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Workflow](#stow-workflow)
- [Recommended Software](#recommended-software)
- [Troubleshooting](#troubleshooting)

## Structure

This repository is organized into packages. Each top-level directory is a Stow package corresponding to a category of configuration.

- `shell/`: Shell configurations (e.g., `.zshrc`).
- `git/`: Git configurations (e.g., `.gitconfig`).
- `config/`: App configs that live in `~/.config/`, but also some specific app config that is not inside `~/.config` like `~/.hammerspoon` or `~/.colima`.

## Platform

This configuration is developed and tested on **macOS**. Many of the tools and scripts, especially those installed via Homebrew, are specific to the macOS ecosystem. Users on other platforms (like Linux or Windows) may need to find alternative tools and adapt the configurations accordingly.

## Prerequisites

The following tools are required to use this dotfiles setup on macOS.

- **Zsh:** The shell configurations are written for Zsh (pre-installed on modern macOS).
- **Homebrew:** The package manager used to install other software.
- **GNU Stow:** The symlink manager used to link the dotfiles from this repository.

You can install Homebrew and Stow with the following commands:

```sh
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Stow
brew install stow
```

## Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/jatifjr/dotfiles.git ~/.dotfiles
    ```

2.  **Navigate into the directory:**

    ```sh
    cd ~/.dotfiles
    ```

3.  **Stow the packages:**
    This creates the symlinks. It's recommended to stow packages by explicitly naming them to avoid unintended behavior. You can stow a single package or multiple at once.

    ```sh
    # Stow multiple packages at once
    stow shell git config

    # Or, stow one package at a time
    stow shell
    ```

## Workflow

This section covers the day-to-day management of your dotfiles with Stow.

### Managing Packages

- **Update (Restow):** To apply changes from the repository to your system.

  ```sh
  stow -R <package-name>
  ```

- **Remove (Unstow):** To remove a package's symlinks.
  ```sh
  stow -D <package-name>
  ```

### Useful Commands

- **Dry Run:** Preview what `stow` will do without making changes.

  ```sh
  stow -n <package-name>
  ```

- **Verbose:** See details about the files being linked.
  ```sh
  stow -v <package-name>
  ```

### Adding New Configurations

1.  Create the same directory structure for the config file inside the appropriate package in this repository. For example, to add a config for `new-app` that lives at `~/.config/new-app/config.toml`, you would create `~/.dotfiles/config/.config/new-app/config.toml`.
2.  Add your configuration file(s) there.
3.  Restow the package: `stow -R config`.

## Recommended Software

This is a curated list of CLI tools and GUI applications that I use on macOS. The configurations for many of these are managed by this dotfiles repository. While they are not required to use the basic `stow` setup, installing them will give you the full experience.

### Formulae

These are my must-have CLI tools for productivity, development, and system management.

#### [tmux](https://github.com/tmux/tmux)

A terminal multiplexer that allows multiple terminal sessions to be accessed and controlled from a single window.

**Install:**

```sh
brew install tmux
```

#### [fzf](https://github.com/junegunn/fzf)

A command-line fuzzy finder. Integrates with many tools for quick file, command, and history search.

**Install:**

```sh
brew install fzf
$(brew --prefix)/opt/fzf/install  # Set up key bindings & fuzzy auto-completion
```

#### [fd](https://github.com/sharkdp/fd)

A simple, fast, and user-friendly alternative to `find` for searching files.

**Install:**

```sh
brew install fd
```

#### [rg](https://github.com/BurntSushi/ripgrep)

A fast, recursive search tool for finding text patterns in files, similar to `grep` but optimized.

**Install:**

```sh
brew install ripgrep
```

#### [fnm](https://github.com/Schniz/fnm)

Fast Node.js version manager written in Rust. Lightweight alternative to `nvm`.

**Install:**

```sh
brew install fnm
```

#### [pnpm](https://pnpm.io/)

A fast, disk-space-efficient package manager for JavaScript/TypeScript projects.

**Install:**

```sh
brew install pnpm
```

#### [nvim](https://neovim.io/)

A hyper-extensible Vim-based text editor with modern improvements.

**Install:**
You might want to read [this](https://github.com/nvim-lua/kickstart.nvim) before installing.

```sh
brew install neovim
```

#### [colima](https://github.com/abiosoft/colima)

Container runtime for macOS with Docker & Kubernetes support, built on Lima.

**Install:**

```sh
brew install colima
```

### Casks

My go-to GUI applications for development and daily use. Items marked `(Optional)` are not part of the core setup.

#### [AeroSpace](https://github.com/nikitabobko/AeroSpace) [BETA]

An i3-like tiling window manager for macOS.

**Install:**

```sh
brew install --cask nikitabobko/tap/aerospace
```

#### [Hammerspoon](https://www.hammerspoon.org)

A powerful automation tool for macOS that bridges system APIs with a Lua scripting engine. It's ideal for window management, custom shortcuts, and automating tasks.

**Install:**

```sh
brew install --cask hammerspoon
```

#### [Tailscale](https://tailscale.com/)

A zero-config VPN that keeps your Internet connection private and secure.

**Install:**

```sh
brew install --cask tailscale-app
```

#### [Scroll Reverser](https://pilotmoon.com/scrollreverser/)

Scroll Reverser is a Mac app that reverses the direction of scrolling, with independent settings for trackpads and mice (including Magic Mouse).

**Install:**

```sh
brew install --cask scroll-reverser
```

#### [Ghostty](https://ghostty.org/)

A modern, GPU-accelerated terminal emulator built for speed and usability.

**Install:**

```sh
brew install --cask ghostty
```

#### [Zed](https://zed.dev/) (Optional)

A next-generation, collaborative code editor focused on performance and developer experience.

**Install:**

```sh
brew install --cask zed
```

#### [Cursor](https://cursor.com/)

An AI-powered code editor that helps write, refactor, and understand code faster.

**Install:**

```sh
brew install --cask cursor
```

#### [Brave](https://brave.com/) (Optional)

A privacy-first browser with built-in ad-blocking and performance optimizations.

**Install:**

```sh
brew install --cask brave-browser
```

#### [Zen Browser](https://zen-browser.app/) (Optional)

A privacy-focused browser with productivity and customization features.

**Install:**

```sh
brew install --cask zen-browser
```

#### [Velja](https://sindresorhus.com/velja) (Optional)

Powerful browser picker. Useful if you have multiple web browsers.

**Install:**

```sh
# Download on the App Store
```

## Troubleshooting

If `stow` reports a conflict with an existing file, you can either remove the file from your home directory (back it up first!) or move it into this repository, then run `stow` again.
