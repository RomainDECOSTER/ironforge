#!/usr/bin/env bash
set -euo pipefail

# Singleton guard: only start a sudocode server if none is already running.
# Prevents multiple zombie processes accumulating across Claude Code sessions.

if pgrep -u "$(id -u)" -f "sudocode-server" > /dev/null 2>&1; then
  exit 0
fi

if command -v sudocode-server &>/dev/null; then
  sudocode-server &>/dev/null &
elif command -v sudocode &>/dev/null; then
  sudocode server --detach &>/dev/null
else
  npx sudocode server --detach &>/dev/null
fi
