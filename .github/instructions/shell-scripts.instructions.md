---
description: Shell scripting standards for Bash/Zsh scripts
applyTo: "**/*.sh,bin/*"
---

# Shell Scripting Standards

## Script Headers

- Always include shebang: `#!/usr/bin/env bash` for portability
- Set strict error handling at the top: `set -euo pipefail`
- Add brief description comment after shebang

## Variable Handling

- Always quote variables: `"${variable}"` to prevent word splitting
- Use `${variable}` syntax instead of `$variable` for clarity
- Declare local variables in functions: `local var_name`
- Use uppercase for environment variables, lowercase for local variables

## Conditionals

- Use `[[` instead of `[` for test conditions in bash
- Prefer explicit conditions: `[[ -n "${var}" ]]` instead of `[[ "${var}" ]]`

## Command Substitution

- Use `$()` instead of backticks for command substitution
- Check command existence: `command -v tool &> /dev/null` or `type tool &> /dev/null`

## Error Handling

- Check exit codes for critical commands
- Provide meaningful error messages
- Clean up temporary files/resources on exit using trap

## Functions

- Use descriptive function names with underscores
- Document function purpose with comments
- Keep functions focused on single responsibility
