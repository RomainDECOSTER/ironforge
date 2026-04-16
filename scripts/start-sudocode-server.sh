#!/bin/bash
# Singleton guard: only start a sudocode server if none is already running.
# Prevents multiple zombie processes accumulating across Claude Code sessions.

if pgrep -f "sudocode-server" > /dev/null 2>&1; then
  exit 0
fi

if command -v sudocode-server &>/dev/null; then
  sudocode-server &>/dev/null &
else
  sudocode server --detach &>/dev/null
fi
