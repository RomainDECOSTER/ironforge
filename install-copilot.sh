#!/usr/bin/env bash
# Ironforge — One-command installer for GitHub Copilot CLI
# Usage: bash <(curl -sSL https://raw.githubusercontent.com/RomainDECOSTER/ironforge/main/install-copilot.sh)
#
# Installs Ironforge and all dependency plugins into GitHub Copilot CLI.

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[ironforge]${NC} $*"; }
warn()  { echo -e "${YELLOW}[ironforge]${NC} $*"; }
error() { echo -e "${RED}[ironforge]${NC} $*" >&2; }

# Check that GitHub Copilot CLI is available
if ! command -v copilot >/dev/null 2>&1; then
  warn "GitHub Copilot CLI not found in PATH."
  warn "Install it from: https://githubnext.com/projects/copilot-cli"
  warn "Continuing anyway — manual plugin installs may be required."
fi

info "Starting Ironforge installation for GitHub Copilot CLI..."
echo ""

# ─── Step 1: Install Ironforge plugin ────────────────────────────────────────

info "Installing Ironforge plugin (copilot/ subtree)..."
if command -v copilot >/dev/null 2>&1; then
  copilot plugin install https://github.com/RomainDECOSTER/ironforge --subdir copilot \
    || warn "Could not install Ironforge plugin via 'copilot plugin install'."
  warn "If the command above failed, install manually by cloning the repo and pointing"
  warn "Copilot CLI at the copilot/ subdirectory in your Copilot settings."
else
  warn "Skipping plugin install — copilot CLI not found."
  warn "After installing Copilot CLI, run:"
  warn "  copilot plugin install https://github.com/RomainDECOSTER/ironforge --subdir copilot"
fi

echo ""

# ─── Step 2: Install BMAD Method ─────────────────────────────────────────────

info "Installing BMAD Method..."
npx bmad-method install || warn "Could not install bmad-method via npx"

echo ""

# ─── Step 3: Install agency-agents ───────────────────────────────────────────

info "Installing agency-agents (project-local)..."

AGENT_COUNT=0
AGENCY_DIR="$(mktemp -d)"
if git clone --depth 1 https://github.com/msitarzewski/agency-agents "$AGENCY_DIR" 2>/dev/null; then
  mkdir -p .claude/agents

  # Only copy .md files that have valid YAML frontmatter (start with "---").
  # This avoids copying README, CONTRIBUTING, SECURITY, workflow templates,
  # and other non-agent .md files that break slash commands.
  # See: https://github.com/RomainDECOSTER/ironforge/issues/14
  SEARCH_DIR="$AGENCY_DIR"
  if [ -d "$AGENCY_DIR/agents" ]; then
    SEARCH_DIR="$AGENCY_DIR/agents"
  fi

  while IFS= read -r -d '' mdfile; do
    if head -1 "$mdfile" | grep -q "^---"; then
      cp "$mdfile" .claude/agents/
      AGENT_COUNT=$((AGENT_COUNT + 1))
    fi
  done < <(find "$SEARCH_DIR" -name "*.md" -not -path "*/.git/*" -print0)

  if [ "$AGENT_COUNT" -gt 0 ]; then
    info "  agency-agents installed into .claude/agents/ ($AGENT_COUNT agents)"
  else
    warn "No valid agent files found in agency-agents repository"
  fi

  rm -rf "$AGENCY_DIR"
else
  warn "Could not clone agency-agents — install manually:"
  warn "  git clone https://github.com/msitarzewski/agency-agents /tmp/agency-agents"
  warn "  mkdir -p .claude/agents && cp -r /tmp/agency-agents/agents/* .claude/agents/"
fi

echo ""

# ─── Step 4: Additional dependencies (manual) ────────────────────────────────

info "Additional dependencies require manual installation via Copilot CLI:"
echo ""
info "  Superpowers:"
info "    copilot plugin install superpowers"
info "    (check https://github.com/obra/superpowers for the current Copilot CLI install command)"
echo ""
info "  Sudocode:"
info "    copilot plugin install sudocode"
info "    (check https://github.com/sudocode-ai/sudocode for the current Copilot CLI install command)"
echo ""
info "  Context7:"
info "    copilot plugin install context7-plugin"
info "    (check https://github.com/upstash/context7 for the current Copilot CLI install command)"
echo ""
info "  security-guidance:"
info "    copilot plugin install security-guidance"
info "    (check the security-guidance repository for the current Copilot CLI install command)"
echo ""

# ─── Step 5: Initialize Sudocode (if in a project) ──────────────────────────

if [ -d ".git" ] && [ ! -d ".sudocode" ]; then
  info "Initializing Sudocode in current project..."
  npx sudocode init || warn "Could not initialize sudocode — run 'npx sudocode init' manually"
  echo ""
fi

# ─── Step 6: Suggest Graphify (existing projects only) ──────────────────────

if [ -d ".git" ] && git rev-parse HEAD >/dev/null 2>&1; then
  info "Tip: run /ironforge:graph-init in Copilot CLI to build the Graphify"
  info "     knowledge graph for this project (recommended for existing codebases)."
  echo ""
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
info "========================================="
info " Ironforge installation complete!"
info "========================================="
echo ""
info "Installed:"
info "  - Ironforge (copilot/ subtree)"
info "  - BMAD Method (specialized agents)"
info "  - agency-agents ($AGENT_COUNT specialized agents)"
info "  - Graphify (code knowledge graph, run /ironforge:graph-init)"
echo ""
info "Requires manual install (see instructions above):"
info "  - Superpowers"
info "  - Sudocode"
info "  - Context7"
info "  - security-guidance"
echo ""
info "Open Copilot CLI and run /ironforge:setup to verify all dependencies."
echo ""
