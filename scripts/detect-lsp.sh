#!/usr/bin/env bash
# Ironforge LSP detection script
# Scans the working directory for project indicators and reports findings.

set -euo pipefail

echo "=== Ironforge: Project scan ==="

FOUND_RUST=false
FOUND_TS=false

# Check for Rust project
if [ -f "Cargo.toml" ]; then
  FOUND_RUST=true
  echo "[rust] Cargo.toml detected -- rust-analyzer LSP applicable"
fi

# Check for TypeScript/JavaScript project
if [ -f "tsconfig.json" ]; then
  FOUND_TS=true
  echo "[typescript] tsconfig.json detected -- TypeScript LSP applicable"
elif [ -f "package.json" ]; then
  FOUND_TS=true
  echo "[typescript] package.json detected -- TypeScript LSP applicable"
fi

if [ "$FOUND_RUST" = false ] && [ "$FOUND_TS" = false ]; then
  echo "[info] No Rust or TypeScript/JavaScript project indicators found"
fi

# Check first-run marker
MARKER="${CLAUDE_PLUGIN_DATA:-.}/.initialized"
if [ ! -f "$MARKER" ]; then
  echo "[setup] First run detected. Run /setup to verify all dependencies are installed."
  mkdir -p "$(dirname "$MARKER")"
  touch "$MARKER"
fi

echo "=== Ironforge: Scan complete ==="
