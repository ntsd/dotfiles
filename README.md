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

Flexible AI customization with selectable workspace instruction files and task-specific chat modes.

### Workspace Instruction Files

Core project guidance lives in:

- `.github/copilot-instructions.md` (always loaded)
- `.github/instructions/` (active subset you choose)
- `.github/instructions_catalog/` (full catalog of optional instruction files)

Select which catalog files become active:

```bash
make copilot-select   # interactive selection
COPILOT_INSTRUCTIONS="1,3" make copilot-select  # non-interactive by index
COPILOT_INSTRUCTIONS="shell-scripts.instructions.md,documentation.instructions.md" make copilot-select  # by filename
```

The selection copies chosen files into `.github/instructions/` (no global linking). Then:

```bash
make copilot   # workspace-only usage
```

### Chat Modes (workspace)

Located in `.github/chatmodes/`:

- `agent.chatmode.md` – Implementation & handoffs
- `plan.chatmode.md` – Planning only, no edits
- `review.chatmode.md` – Code quality & security review
- `test.chatmode.md` – Test case generation (bats focus)
- `document.chatmode.md` – Documentation generation

### Optional User-Level Linking

If you want these prompts available globally (optional):

```bash
make copilot-global
```

This links files from `config/copilot/{instructions,chatmodes,agents}` into the VS Code Insiders prompts directory. Skip this if you prefer per-project isolation.

### Custom Agents

Add custom personas:

```bash
echo "# My reviewer" > config/copilot/agents/security.agent.md
make copilot-global
```

### Typical Workflow

```bash
make copilot-select    # choose standards needed for this project phase
make copilot           # confirm workspace setup
dotfiles copilot       # show workspace status
dotfiles copilot-select  # reconfigure instructions later
```

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
  copilot          Show workspace Copilot instruction/chatmode usage
  copilot-global   Link user-level Copilot prompt files (advanced)
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
