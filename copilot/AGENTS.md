# Ironforge — Ambient Instructions for GitHub Copilot CLI

Ironforge is active in this session. On every session start, verify the following six dependency
categories are available. If any are missing, tell the user to run `/ironforge:setup`.

---

## Required dependencies

### 1. BMAD Method
Specialized agents for analysis, product management, architecture, and development:
`@bmad-agent-analyst`, `@bmad-agent-pm`, `@bmad-agent-sm`, `@bmad-agent-dev`.
Install: `npx bmad-method install`

### 2. Superpowers
TDD enforcement and quick-spec capability. Provides `/quick-spec` for FAST-mode tasks.
Install: `copilot plugin install superpowers`

### 3. Sudocode
Persistent memory for specs and issues. Provides `upsert_spec` and `upsert_issue`.
Install: `copilot plugin install sudocode`

### 4. Context7
Up-to-date library documentation. Invoked via `use context7` in agent prompts.
Install: `copilot plugin install context7-plugin`

### 5. security-guidance
Pre-tool security hooks. Active if a `PreToolUse` hook referencing security-guidance is present.
Install: `copilot plugin install security-guidance`

### 6. agency-agents
Project-local reviewer agents in `.claude/agents/`. Look for `engineering-code-reviewer` and
`testing-reality-checker` in `.claude/agents/`.
Install (from project root):
```bash
git clone --depth 1 https://github.com/msitarzewski/agency-agents /tmp/agency-agents
mkdir -p .claude/agents && cp -r /tmp/agency-agents/agents/* .claude/agents/
rm -rf /tmp/agency-agents
```

---

## LSP detection

At session start, scan the working directory for:
- `Cargo.toml` → rust-analyzer is (or should be) active for Rust
- `package.json` or `tsconfig.json` → TypeScript LSP is (or should be) active

Report which LSPs are active. If detected files are present but LSP is not active, suggest
checking that the LSP server is installed.

---

## Graphify (optional)

If `graphify-out/` exists in the project root, Graphify is active and its MCP server is
available. When Graphify is active:
- BMAD agents **must** query the graph exclusively via the graph-explore agent
  (`/ironforge:graph-explore`) — never call MCP graph tools directly in the main session
- MCP tool names follow the pattern `mcp__graphify__<tool_name>`; verify the prefix matches
  your Copilot MCP configuration if tools appear unavailable

---

## First-run verification

After checking dependencies and LSPs, output a brief status table:

| Dependency | Status |
|---|---|
| BMAD Method | ✓ / missing |
| Superpowers | ✓ / missing |
| Sudocode | ✓ / missing |
| Context7 | ✓ / missing |
| security-guidance | ✓ / missing |
| agency-agents | ✓ / missing |
| rust-analyzer | active / not detected |
| TypeScript LSP | active / not detected |

If anything is missing, recommend `/ironforge:setup` for installation instructions.

---

## Agent delegation

Copilot CLI does not support `@agent-name` shorthand syntax. When skills in this plugin
reference activating an agent by name, use prose delegation: address the agent by its role
and provide the required context. Example: "Use the BMAD analyst agent to produce a brief
covering the following context: …"
