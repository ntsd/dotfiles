# Dotfiles Project - Copilot Instructions

## Project Overview

This is a dotfiles management project that provides automated setup and configuration for macOS and Linux development environments. The project uses Make for orchestration, shell scripts for system configuration, and Homebrew for package management.

## General Coding Standards

- Follow Unix philosophy: write programs that do one thing well
- Use clear, descriptive variable and function names
- Add comments for complex logic and non-obvious decisions
- Maintain backward compatibility when modifying existing scripts
- Test changes on both macOS and Linux when applicable

## Shell Scripting Guidelines

- Use `#!/usr/bin/env bash` for portability
- Set strict error handling: `set -euo pipefail`
- Quote all variables to prevent word splitting: `"${variable}"`
- Use `[[` instead of `[` for conditionals in bash
- Prefer `$()` over backticks for command substitution
- Check for command existence before using: `command -v tool &> /dev/null`

## File Organization

- **bin/**: Utility scripts and dotfiles management commands
- **config/**: Application configuration files (git, prettier, etc.)
- **install/**: Package lists and installation manifests
- **macos/**: macOS-specific configuration scripts
- **runcom/**: Shell configuration files (e.g., .bashrc, .zshrc equivalents)
- **system/**: System-level configuration and setup scripts

## Makefile Standards

- Use `.PHONY` targets for non-file targets
- Add help text for each target
- Keep targets focused on single responsibilities
- Use `@` prefix to suppress command echo for clean output
- Check for required dependencies before executing

## Dependencies and Package Management

- Homebrew packages go in `install/Brewfile`
- Cask applications go in `install/Caskfile`
- Node/NPM global packages go in `install/npmfile`
- VS Code extensions go in `install/VSCodefile`
- Version-managed tools use asdf and are defined in `runcom/.tool-versions`

## Testing

- All scripts should handle missing dependencies gracefully
- Test on fresh installations when possible
- CI/CD tests run on both Ubuntu and macOS via GitHub Actions
- Use the `test/` directory for automated tests using bats framework

## Documentation

- Update README.md when adding new features or commands
- Add inline comments for complex shell logic
- Document any system requirements or prerequisites
- Include usage examples for new scripts or commands
