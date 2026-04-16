#!/usr/bin/env bash
set -euo pipefail

# Singleton guard: only start a sudocode server if none is already running.
# Prevents redundant background server instances accumulating across Claude Code sessions.
# Uses flock to avoid a race condition when multiple sessions start simultaneously.

LOCKFILE="/tmp/sudocode-server-${USER}.lock"

(
  flock -n 9 || exit 0

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
) 9>"$LOCKFILE"
