#!/usr/bin/env bash
# Ironforge — One-command installer
# Usage: bash <(curl -sSL https://raw.githubusercontent.com/RomainDECOSTER/ironforge/main/install.sh)
#
# Installs Ironforge and all 5 dependency plugins into Claude Code.

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[ironforge]${NC} $*"; }
warn()  { echo -e "${YELLOW}[ironforge]${NC} $*"; }
error() { echo -e "${RED}[ironforge]${NC} $*" >&2; }

# Check that claude CLI is available
if ! command -v claude >/dev/null 2>&1; then
  error "Claude Code CLI not found. Install it first: https://docs.anthropic.com/en/docs/claude-code"
  exit 1
fi

info "Starting Ironforge installation..."
echo ""

# ─── Step 1: Add marketplaces ────────────────────────────────────────────────

info "Adding plugin marketplaces..."

MARKETPLACES=(
  "RomainDECOSTER/ironforge"
  "obra/superpowers-marketplace"
  "sudocode-ai/sudocode"
  "upstash/context7"
)

for mp in "${MARKETPLACES[@]}"; do
  info "  Adding marketplace: $mp"
  claude plugin marketplace add "$mp" || warn "  Could not add $mp (may already exist)"
done

echo ""

# ─── Step 2: Install plugins ─────────────────────────────────────────────────

info "Installing plugins..."

PLUGINS=(
  "ironforge@ironforge-marketplace"
  "superpowers@superpowers-marketplace"
  "sudocode@sudocode-marketplace"
  "context7-plugin@context7-marketplace"
  "security-guidance@claude-plugins-official"
)

for plugin in "${PLUGINS[@]}"; do
  info "  Installing: $plugin"
  claude plugin install --scope project "$plugin" || warn "  Could not install $plugin (may already exist or name may differ)"
done

echo ""

# ─── Step 3: Install BMAD Method ─────────────────────────────────────────────

info "Installing BMAD Method..."
npx bmad-method install || warn "Could not install bmad-method via npx"

echo ""

# ─── Step 4: Install agency-agents ───────────────────────────────────────────

info "Installing agency-agents..."

AGENCY_DIR="$(mktemp -d)"
if git clone --depth 1 https://github.com/msitarzewski/agency-agents "$AGENCY_DIR" 2>/dev/null; then
  if [ -f "$AGENCY_DIR/scripts/install.sh" ]; then
    bash "$AGENCY_DIR/scripts/install.sh" --tool claude-code || warn "agency-agents install script failed"
  else
    mkdir -p ~/.claude/agents
    cp -r "$AGENCY_DIR"/agents/* ~/.claude/agents/ 2>/dev/null || warn "Could not copy agency-agents to ~/.claude/agents/"
  fi
  rm -rf "$AGENCY_DIR"
  info "  agency-agents installed"
else
  warn "Could not clone agency-agents — install manually:"
  warn "  git clone https://github.com/msitarzewski/agency-agents"
  warn "  bash agency-agents/scripts/install.sh --tool claude-code"
fi

echo ""

# ─── Step 5: Initialize Sudocode (if in a project) ──────────────────────────

if [ -d ".git" ] && [ ! -d ".sudocode" ]; then
  info "Initializing Sudocode in current project..."
  claude -p "Run sudocode init" || warn "Could not initialize sudocode"
  echo ""
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
info "========================================="
info " Ironforge installation complete!"
info "========================================="
echo ""
info "Installed plugins:"
info "  - Ironforge (workflow orchestration)"
info "  - BMAD Method (specialized agents)"
info "  - Superpowers (TDD enforcement)"
info "  - Sudocode (persistent memory)"
info "  - Context7 (library documentation)"
info "  - security-guidance (security hooks)"
info "  - agency-agents (144 specialized agents)"
echo ""
info "Open Claude Code and try:"
info "  /ironforge:start Describe your task here"
echo ""
