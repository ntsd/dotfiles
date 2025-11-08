# .files

These are my dotfiles. Take anything you want, but at your own risk.

It mainly targets macOS systems, but it works on at least Ubuntu as well.

> Warning The Linux is not working in the moment, beacuse the $HOME will change to /root

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Cask, ASDF, NPM, latest Bash + GNU Utils
- Fast and colored prompt
- Updated macOS defaults (Dock, Systen)
- Interactive macOS setup now prompts for computer name (with fallback and env override)
- GitHub Copilot custom instructions, custom agent files, and chat modes (plan, agent, review, test, document) for enhanced AI assistance
- The installation and runcom setup is
  [tested on real Ubuntu and macOS machines](https://github.com/ntsd/dotfiles/actions) using
  [a GitHub Action](./.github/workflows/ci.yml)
- Post install `dotfiles` command line to restall, update packages, etc.

## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- [asdf](https://github.com/asdf-vm/asdf) (packages: [.tool-versions](./runcom/.tool-versions))
- [Vs Code](https://github.com/microsoft/vscode) (packages: [VSCodefile](./install/VSCodefile))
- Latest Git, Bash 4, GNU coreutils, curl

## GitHub Copilot Configuration

This dotfiles repository includes comprehensive GitHub Copilot customizations to enhance your AI-assisted coding experience.

### Workspace-Level Instructions

Located in `.github/`, these apply automatically to this workspace:

- **[copilot-instructions.md](./.github/copilot-instructions.md)**: Main coding standards and project guidelines
- **[instructions/](./.github/instructions/)**: File-type specific instructions
  - `shell-scripts.instructions.md`: Shell scripting standards
  - `makefile.instructions.md`: Makefile conventions
  - `documentation.instructions.md`: Documentation guidelines

### Custom Chat Modes

Located in `.github/chatmodes/`, these provide specialized AI personas:

- **agent**: Implementation mode (makes code changes, runs commands, hands off to review/test/document)
- **plan**: Generate detailed implementation plans without making code changes
- **review**: Perform thorough code reviews focusing on quality and security
- **test**: Create comprehensive test cases using the bats framework
- **document**: Generate clear documentation with examples

### User Profile Instructions

Located in `config/copilot/`, these sync across all your workspaces:

- **instructions/general.instructions.md**: Personal coding standards for all projects
- **chatmodes/debug.chatmode.md**: Quick debugging and troubleshooting
- **chatmodes/explain.chatmode.md**: Detailed code and concept explanations
- **chatmodes/agent.chatmode.md**: Personal implementation mode available across all workspaces
- **agents/**: Place `*.agent.md` custom agent persona files here (linked by `make copilot`)

To deploy user profile configurations:

```bash
make copilot
```

This will symlink the Copilot configurations to your VS Code user profile, making them available across all workspaces.

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
COMPUTER_NAME="MyMac" make

# During `make macos` the defaults script will prompt:
#   Enter desired computer name [CurrentName] (leave blank to keep):
# You can automate this by providing an environment variable:
#   COMPUTER_NAME="MyMac" make macos
# If omitted, existing ComputerName or hostname is used.
```

## The `dotfiles` command

```bash
$ dotfiles help
Usage: dotfiles <command>

Commands:
   help             This help message
   clean            Clean up caches (brew)
   copilot          Setup GitHub Copilot custom instructions and chat modes
   dock             Apply macOS Dock settings
   macos            Apply macOS system defaults
   test             Run tests
   asdf             Update asdf global packages
   brew             Update Homebrew/Cask packages
   node             Update Node packages
   update           Update packages and pkg managers (OS, brew, npm)
```

## Customize

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from
`.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.bash_profile` sources all
`~/.extra/*.sh` files.

### Copilot Configuration Deployment

Deploy workspace + user-level Copilot config (instructions, chat modes, agents):

```bash
make copilot
```

This links:
- `.github/copilot-instructions.md` and `.github/instructions/*.instructions.md`
- `.github/chatmodes/*.chatmode.md` (including `agent.chatmode.md`)
- `config/copilot/instructions/*.instructions.md`
- `config/copilot/chatmodes/*.chatmode.md`
- `config/copilot/agents/*.agent.md`

Add new custom agent personas by creating `config/copilot/agents/mypersona.agent.md` then re-run `make copilot`.

## Credits

This dotfile is fork from [@webpro Dotfiles](https://github.com/webpro/dotfiles).

Many thanks to the [dotfiles community](https://dotfiles.github.io).
