# .files

> Warning The Linux is not working in the moment, beacuse the $HOME will change to /root

This dotfile is created from `https://github.com/webpro/dotfiles` boilerplate

These are my dotfiles. Take anything you want, but at your own risk.

It mainly targets macOS systems, but it works on at least Ubuntu as well.

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom, latest Bash + GNU Utils
- Great [Window management](./config/hammerspoon/README.md) (using Hammerspoon)
- Fast and colored prompt
- Updated macOS defaults
- Well-organized and easy to customize
- The installation and runcom setup is
  [tested weekly on real Ubuntu and macOS machines](https://github.com/ntsd/dotfiles/actions) using
  [a GitHub Action](./.github/workflows/ci.yml)

## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- Latest Git, Bash 4, GNU coreutils, curl

## Installation

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/ntsd/dotfiles/master/remote-install.sh`"
```

This will clone or download, this repo to `~/.dotfiles` depending on the availability of `git`, `curl` or `wget`.

1. Alternatively, clone manually into the desired location:

```bash
git clone https://github.com/ntsd/dotfiles.git ~/.dotfiles
```

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom)
and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

```bash
cd ~/.dotfiles
make
```

The installation process in the Makefile is tested on every push and every week in this
[GitHub Action](https://github.com/ntsd/dotfiles/actions).

## Post-Installation

- `dotfiles dock` (set [Dock items](./macos/dock.sh))
- `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))

## The `dotfiles` command

```bash
$ dotfiles help
Usage: dotfiles <command>

Commands:
    clean            Clean up caches (brew)
    dock             Apply macOS Dock settings
    edit             Open dotfiles in IDE (code) and Git GUI (stree)
    help             This help message
    macos            Apply macOS system defaults
    test             Run tests
    update           Update packages and pkg managers (OS, brew)
```

## Customize

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from
`.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.bash_profile` sources all
`~/.extra/*.sh` files.

## Credits

Many thanks to the [dotfiles community](https://dotfiles.github.io).
