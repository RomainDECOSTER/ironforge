#!/usr/bin/env bash
# Ironforge manual post-install helper
# Prints the installation commands for all dependency plugins.
# Run this if automatic dependency resolution via plugin.json didn't work.

set -euo pipefail

echo "========================================="
echo " Ironforge -- Dependency Install Guide"
echo "========================================="
echo ""
echo "Run the following commands in Claude Code to install all dependencies:"
echo ""
echo "1. BMAD Method:"
echo "   npx bmad-method install"
echo ""
echo "2. Superpowers:"
echo "   /plugin marketplace add obra/superpowers-marketplace"
echo "   /plugin install superpowers"
echo ""
echo "3. Sudocode:"
echo "   /plugin marketplace add sudocode-ai/sudocode"
echo "   /plugin install sudocode"
echo ""
echo "4. Context7:"
echo "   /plugin marketplace add upstash/context7"
echo "   /plugin install context7-plugin@context7-marketplace"
echo ""
echo "5. security-guidance:"
echo "   /plugin install security-guidance@anthropics-claude-code"
echo ""
echo "6. code-review:"
echo "   /plugin install code-review@anthropics-claude-code"
echo ""
echo "After installation, initialize Sudocode in your project:"
echo "   sudocode init"
echo ""
echo "Then run /setup in Claude Code to verify everything is configured."
