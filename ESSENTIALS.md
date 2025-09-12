# MacOS Essentials

---

## Core

### [zsh](https://zsh.sourceforge.io/)

A powerful shell with advanced scripting features and customization options. It is my shell of choice on macOS.

**Install:**

```sh
# Should be pre-installed on macOS
```

### [Homebrew](https://brew.sh/)

The package manager for macOS. Makes installing and managing CLI tools and apps easy.

**Install:**

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## Formulae

These are my must-have CLI tools for productivity, development, and system management.

### [stow](https://www.gnu.org/software/stow/)

A symlink farm manager, perfect for managing dotfiles in a clean, version-controlled way.

**Install:**

```sh
brew install stow
```

### [tmux](https://github.com/tmux/tmux)

A terminal multiplexer that allows multiple terminal sessions to be accessed and controlled from a single window.
**Install:**

```sh
brew install tmux
```

### [fzf](https://github.com/junegunn/fzf)

A command-line fuzzy finder. Integrates with many tools for quick file, command, and history search.

**Install:**

```sh
brew install fzf
$(brew --prefix)/opt/fzf/install  # Set up key bindings & fuzzy auto-completion
```

### [fd](https://github.com/sharkdp/fd)

A simple, fast, and user-friendly alternative to `find` for searching files.

**Install:**

```sh
brew install fd
```

### [rg](https://github.com/BurntSushi/ripgrep)

A fast, recursive search tool for finding text patterns in files, similar to `grep` but optimized.

**Install:**

```sh
brew install ripgrep
```

### [fnm](https://github.com/Schniz/fnm)

Fast Node.js version manager written in Rust. Lightweight alternative to `nvm`.

**Install:**

```sh
brew install fnm
```

### [pnpm](https://pnpm.io/)

A fast, disk-space-efficient package manager for JavaScript/TypeScript projects.

**Install:**

```sh
brew install pnpm
```

### [nvim](https://neovim.io/)

A hyper-extensible Vim-based text editor with modern improvements.

**Install:**

You might want to read [this](https://github.com/nvim-lua/kickstart.nvim) before installing.

```sh
brew install neovim
```

### [colima](https://github.com/abiosoft/colima)

Container runtime for macOS with Docker & Kubernetes support, built on Lima.

**Install:**

```sh
brew install colima
```

---

## Casks

My go-to GUI applications for development and daily use.

### [AeroSpace](https://github.com/nikitabobko/AeroSpace) [BETA]

An i3-like tiling window manager for macOS.

**Install:**

```sh
brew install --cask nikitabobko/tap/aerospace
```

### [Tailscale](https://tailscale.com/)

A zero-config VPN that keeps your Internet connection private and secure.

**Install:**

```sh
brew install --cask tailscale-app
```

### [Hammerspoon](https://www.hammerspoon.org)

A powerful automation tool for macOS that bridges system APIs with a Lua scripting engine. It's ideal for window management, custom shortcuts, and automating tasks.

**Install:**

```sh
brew install --cask hammerspoon
```

### [Ghostty](https://ghostty.org/)

A modern, GPU-accelerated terminal emulator built for speed and usability.

**Install:**

```sh
brew install --cask ghostty
```

### [Cursor](https://cursor.com/)

An AI-powered code editor that helps write, refactor, and understand code faster.

**Install:**

```sh
brew install --cask cursor
```

### [Zed](https://zed.dev/)(Optional)

A next-generation, collaborative code editor focused on performance and developer experience.

**Install:**

```sh
brew install --cask zed
```

### [Brave](https://brave.com/)(Optional)

A privacy-first browser with built-in ad-blocking and performance optimizations.

**Install:**

```sh
brew install --cask brave-browser
```

### [Zen Browser](https://zen-browser.app/)(Optional)

A privacy-focused browser with productivity and customization features.

**Install:**

```sh
brew install --cask zen-browser
```
