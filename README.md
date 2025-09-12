# My Dotfiles

This repository contains my personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/). Stow creates symlinks from this repository to the correct locations in your home directory.

## Structure

This repository is organized into packages, where each top-level directory is a package that corresponds to a category of configuration.

- `shell/`: Shell configurations (e.g., `.zshrc`).
- `git/`: Git configurations (e.g., `.gitconfig`).
- `config/`: App configs that live in `~/.config/`, but also some specific app config that is not inside `~/.config` like `~/.hammerspoon` or `~/.colima`.

## Prerequisites

Install GNU Stow:

```sh
# On macOS
brew install stow

# On Debian/Ubuntu
sudo apt-get install stow
```

## Usage

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/jatifjr/dotfiles.git ~/.dotfiles
    ```

2.  **Navigate into the directory:**

    ```sh
    cd ~/.dotfiles
    ```

3.  **Stow the packages:**
    This creates the symlinks. You can stow multiple packages or just specific ones.

    ```sh
    # Stow one or multiple packages in the repository
    stow <package-name> <another-package-name>
    ```

## Managing Packages

- **Update (Restow):** To apply changes from the repository to your system.

  ```sh
  stow -R <package-name>
  ```

- **Remove (Unstow):** To remove a package's symlinks.
  ```sh
  stow -D <package-name>
  ```

## Useful Commands

- **Dry Run:** Preview what `stow` will do without making changes.

  ```sh
  stow -n <package-name>
  ```

- **Verbose:** See details about the files being linked.
  ```sh
  stow -v <package-name>
  ```

## Adding New Configurations

1.  Create the same directory structure for the config file inside the appropriate package in this repository. For example, to add a config for `new-app` that lives at `~/.config/new-app/config.toml`, you would create `~/.dotfiles/config/.config/new-app/config.toml`.
2.  Add your configuration file(s) there.
3.  Restow the package: `stow -R config`.

## Troubleshooting

If `stow` reports a conflict with an existing file, you can either remove the file from your home directory (back it up first!) or move it into this repository, then run `stow` again.
