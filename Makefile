SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
ASDF_PATH := $(HOME)/.asdf
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

.PHONY: test

all: $(OS)

macos: sudo core-macos packages link asdf-packages

linux: core-linux link asdf-packages

core-macos: brew zsh git

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

packages: brew-packages cask-apps

link: stow-$(OS)
	# backup old dotfiles
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	# restore old dotfiles
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

asdf:
	is-executable asdf || git clone https://github.com/asdf-vm/asdf.git $(ASDF_PATH)

zsh: ZSH=/usr/local/bin/zsh
zsh: SHELLS=/private/etc/shells
zsh: brew
ifdef GITHUB_ACTION
	if ! grep -q $(ZSH) $(SHELLS); then \
		brew install zsh && \
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
		sudo append $(ZSH) $(SHELLS) && \
		sudo chsh -s $(ZSH); \
	fi
else
	if ! grep -q $(ZSH) $(SHELLS); then \
		brew install zsh && \
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
		sudo append $(ZSH) $(SHELLS) && \
		chsh -s $(ZSH); \
	fi
endif

git: brew
	brew list git || brew install git
	brew list git || brew install git-extras

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	for EXT in $$(cat install/VSCodefile); do code --install-extension $$EXT; done
	xattr -d -r com.apple.quarantine ~/Library/QuickLook

asdf-packages: asdf
	. $(ASDF_PATH)/asdf.sh && cd $(DOTFILES_DIR)/install && \
		cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {} && \
		asdf install

test:
	bats test
