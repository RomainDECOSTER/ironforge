# Ironforge

A Claude Code plugin that orchestrates six development tools and conditional LSPs into a composable, skill-based development workflow.

## What It Does

Ironforge installs and coordinates the following tools:

### Permanent Tools (all projects)

| Tool | Role |
|------|------|
| **BMAD** | Specialized agents: `@bmad-agent-analyst`, `@bmad-agent-pm`, `@bmad-agent-sm`, `@bmad-agent-dev`, `@bmad-brainstorming` |
| **Superpowers** | TDD enforcement, brainstorming discipline, sub-agents |
| **Sudocode** | Git-native persistent memory: specs, issues, statuses (`.sudocode/`) |
| **Context7** | Up-to-date, version-specific library documentation injected into prompts |
| **security-guidance** | Security prevention hook during code writing (automatic) |
| **agency-agents** | 144 specialized agents for review, QA, architecture, and more |

### Conditional LSPs (detected per session)

| LSP | Activated when |
|-----|---------------|
| **rust-analyzer** | `Cargo.toml` detected |
| **TypeScript LSP** | `package.json` or `tsconfig.json` detected |

## Installation

One command installs Ironforge and all dependencies:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/RomainDECOSTER/ironforge/main/install.sh)
```

This automatically:
- Adds all required marketplaces
- Installs Ironforge, BMAD, Superpowers, Sudocode, Context7, and security-guidance
- Installs agency-agents into `~/.claude/agents/`
- Initializes Sudocode in the current project (if in a git repo)

After installation, verify everything is configured:

```
/ironforge:setup
```

## Workflow Modes

Ironforge supports three modes. Start with `/ironforge:start` — it reads the project context, proposes the right mode, and tells you what to invoke next.

| Mode | When | Entry point |
|------|------|-------------|
| **FAST** | Bug fix, small change (< 1h) | Superpowers `/quick-spec` |
| **FEATURE** | New feature, new component (1h–1 day) | `/ironforge:start` |
| **FULL** | New module, major refactor (1 day+) | `/ironforge:start` |

## Skills

Skills are composable — invoke any skill independently when artefacts already exist.

| Command | Description |
|---------|-------------|
| `/ironforge:start` | Reads project context, proposes mode and entry point, waits for confirmation |
| `/ironforge:bmad-analyze` | Runs BMAD phases (brief → PRD → architecture) with human gates at each step |
| `/ironforge:bmad-to-sudocode` | Converts existing BMAD docs into Sudocode specs and issues |
| `/ironforge:implement [issue-id]` | TDD implementation of Sudocode issues (RED → GREEN → REFACTOR → COMMIT) |
| `/ironforge:review` | Code review (`@engineering-code-reviewer`) + QA sign-off (`@testing-reality-checker`) |
| `/ironforge:full-workflow <task>` | Orchestrator: chains all skills for a project with no existing artefacts |
| `/ironforge:setup` | Verify and install all dependencies |

## Typical Flows

**Starting fresh:**
```
/ironforge:start Build a JWT authentication system
```

**Already have BMAD docs, need Sudocode issues:**
```
/ironforge:bmad-to-sudocode
```

**Resuming implementation on a specific issue:**
```
/ironforge:implement i-0042
```

**Ready to merge:**
```
/ironforge:review
```

## Using with GitHub Copilot CLI

Ironforge ships a parallel `copilot/` subtree for GitHub Copilot CLI. The same nine skills are
available with prose-based agent delegation instead of `@agent-name` shorthand.

**Install:**

```bash
bash <(curl -sSL https://raw.githubusercontent.com/RomainDECOSTER/ironforge/main/install-copilot.sh)
```

This installs Ironforge (`copilot/` subtree), BMAD Method, and agency-agents automatically.
The following dependencies require a separate manual install via `copilot plugin install` or
their respective CLI install commands:

- Superpowers
- Sudocode
- Context7
- security-guidance

After installation, verify everything is configured:

```
/ironforge:setup
```

**Limitations:**
- Agent delegation uses prose instructions — no `@agent` shorthand
- MCP tool prefix for Graphify (`mcp__graphify__<tool_name>`) may need verification against
  your Copilot MCP configuration
- `graphify install` writes its hook to the Claude Code `settings.json` path; verify it is
  registered in your Copilot settings after running `/ironforge:graph-init`

## BMAD Artefact Paths

Standardized paths expected by all Ironforge skills:

```
docs/
  briefs/   → docs/briefs/brief.md
  prd/      → docs/prd/prd.md
  arch/     → docs/arch/architecture.md
.sudocode/  → specs and issues (FEATURE and FULL modes)
```

## Context7

Context7 activates automatically whenever a library or framework is detected during design or implementation. It injects current, version-specific documentation into the prompt.

Manual trigger:
```
use context7
```

## Security

**security-guidance** runs as a `PreToolUse` hook before every `Edit` or `Write` operation. It warns about command injection, XSS, SQL injection, and other OWASP vulnerabilities. Fully automatic.

## Sudocode: Persistent Memory

Specs and issues live in `.sudocode/` and are committed to git. Project context survives across sessions — resuming work requires no re-explanation.

Initialize in a new project:
```
sudocode init
```

## License

MIT
