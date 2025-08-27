# macOS Essential Tools

## CLIs

These are my must-have CLI tools for productivity, development, and system management.

### [zsh](https://zsh.sourceforge.io/)

A powerful shell with advanced scripting features and customization options, replacing the default `bash` on macOS.

**Install:**

```bash
# zsh is already installed on macOS
```

### [Homebrew](https://brew.sh/)

The package manager for macOS. Makes installing and managing CLI tools and apps easy.

**Install:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### [GNU Stow](https://www.gnu.org/software/stow/)

A symlink farm manager, perfect for managing dotfiles in a clean, version-controlled way.

**Install:**

```bash
brew install stow
```

### [kanata](https://github.com/jtroo/kanata)(Optional)

Improve keyboard comfort and usability with advanced customization.

**Install:**

Read this discussion.

[How to use Kanata from Homebrew and LaunchCtl for macOS #1537](https://github.com/jtroo/kanata/discussions/1537)

You'll figure it out.

### [fzf](https://github.com/junegunn/fzf)

A command-line fuzzy finder. Integrates with many tools for quick file, command, and history search.

**Install:**

```bash
brew install fzf
$(brew --prefix)/opt/fzf/install  # Set up key bindings & fuzzy auto-completion
```

### [fd](https://github.com/sharkdp/fd)

A simple, fast, and user-friendly alternative to `find` for searching files.

**Install:**

```bash
brew install fd
```

### [ripgrep](https://github.com/BurntSushi/ripgrep)

A fast, recursive search tool for finding text patterns in files, similar to `grep` but optimized.

**Install:**

```bash
brew install ripgrep
```

### [fnm](https://github.com/Schniz/fnm)

Fast Node.js version manager written in Rust. Lightweight alternative to `nvm`.

**Install:**

```bash
brew install fnm
```

### [pnpm](https://pnpm.io/)

A fast, disk-space-efficient package manager for JavaScript/TypeScript projects.

**Install:**

```bash
brew install pnpm
```

### [neovim](https://neovim.io/)

A hyper-extensible Vim-based text editor with modern improvements.

**Install:**

You might want to read [this](https://github.com/nvim-lua/kickstart.nvim) before installing.

```bash
brew install neovim
```

### [colima](https://github.com/abiosoft/colima)

Container runtime for macOS with Docker & Kubernetes support, built on Lima.

**Install:**

```bash
brew install colima
```

---

## Apps

My go-to GUI applications for development and daily use.

### [AeroSpace](https://github.com/nikitabobko/AeroSpace) [BETA]

An i3-like tiling window manager for macOS.

**Install:**

```bash
brew install --cask nikitabobko/tap/aerospace
```

### [Tailscale](https://tailscale.com/)

A zero-config VPN that keeps your Internet connection private and secure.

**Install:**

```bash
brew install --cask tailscale-app
```

### [Hyperkey](https://hyperkey.app)

The extra macOS modifier key

**Install:**

```bash
brew install --cask hyperkey
```

### [Ghostty](https://ghostty.org/)

A modern, GPU-accelerated terminal emulator built for speed and usability.

**Install:**

```bash
brew install --cask ghostty
```

### [Cursor](https://cursor.com/)

An AI-powered code editor that helps write, refactor, and understand code faster.

**Install:**

```bash
brew install --cask cursor
```

### [Zed](https://zed.dev/)(Optional)

A next-generation, collaborative code editor focused on performance and developer experience.

**Install:**

```bash
brew install --cask zed
```

### [Brave](https://brave.com/)

A privacy-first browser with built-in ad-blocking and performance optimizations.

**Install:**

```bash
brew install --cask brave-browser
```

### [Zen Browser](https://zen-browser.app/)(Optional)

A privacy-focused browser with productivity and customization features.

**Install:**

```bash
brew install --cask zen-browser
```
