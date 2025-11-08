---
description: Makefile conventions for this project
applyTo: "**/Makefile,**/*.mk"
---

# Makefile Standards

## Target Conventions

- Use `.PHONY` declaration for non-file targets
- Add descriptive comments above each target for help documentation
- Keep target names lowercase with hyphens for multi-word names

## Command Formatting

- Use `@` prefix to suppress command echo for clean output
- Add `@echo` statements to inform users of progress
- Check for required dependencies before executing commands

## Variables

- Define variables at the top of the file
- Use `:=` for simple expansion, `=` for recursive expansion
- Document purpose of non-obvious variables

## Dependency Management

- Check for required tools before using them
- Provide helpful error messages when dependencies are missing
- Example: `command -v brew >/dev/null 2>&1 || { echo "Homebrew required"; exit 1; }`

## Target Organization

- Group related targets together
- Keep targets focused on single responsibilities
- Use target dependencies for proper execution order
