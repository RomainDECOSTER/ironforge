# Ironforge

A Claude Code plugin that orchestrates six development tools and conditional LSPs into a unified, structured development workflow.

## What It Does

Ironforge installs and coordinates the following tools into a single pipeline:

### Permanent Tools (all projects)

| Tool | Role |
|------|------|
| **BMAD** | Specialized agents by role: `@bmad-agent-analyst`, `@bmad-agent-architect`, `@bmad-agent-sm`, `@bmad-agent-dev` + `@bmad-brainstorming` |
| **Superpowers** | Workflow discipline: forced brainstorming, TDD enforcement, sub-agents |
| **Sudocode** | Git-native persistent memory: specs, issues, statuses (`.sudocode/`) |
| **Context7** | Up-to-date, version-specific library documentation injected into prompts |
| **security-guidance** | Security prevention hook during code writing (automatic) |
| **code-review** | Automated parallel-agent review before merge |

### Conditional LSPs (detected per session)

| LSP | Activated when |
|-----|---------------|
| **rust-analyzer** | `Cargo.toml` detected |
| **TypeScript LSP** | `package.json` or `tsconfig.json` detected |

LSP detection runs at every session start via the `SessionStart` hook, so it adapts as the project evolves.

## Installation

One command installs Ironforge and all 6 dependency plugins:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/RomainDECOSTER/ironforge/main/install.sh)
```

This automatically:
- Adds all required marketplaces
- Installs Ironforge, BMAD, Superpowers, Sudocode, Context7, security-guidance, and code-review
- Initializes Sudocode in the current project (if in a git repo)

After installation, verify everything is configured:

```
/ironforge:setup
```

## Workflow (6 Phases)

When you describe a feature or bug, Ironforge orchestrates:

1. **Analysis** -- `@bmad-agent-analyst` produces a structured PRD with acceptance criteria
2. **Design** -- `@bmad-agent-architect` + `@bmad-brainstorming` + Context7 for up-to-date API docs. Validated spec is persisted via Sudocode `upsert_spec()`
3. **Planning** -- `@bmad-agent-sm` decomposes into 2-5 min issues with exact files and dependencies. Each issue saved via Sudocode `upsert_issue()`
4. **Implementation** -- `@bmad-agent-dev` implements issue by issue following the TDD cycle (RED -> GREEN -> REFACTOR -> COMMIT). security-guidance and LSPs run automatically in the background.
5. **Review** -- `/code-review` runs parallel agents. Blocks on findings with confidence >= 80. Posts comments on PR with `--comment` flag.
6. **Resume** -- On new session, reads Sudocode specs and issue statuses to resume without re-explaining context.

Trigger the full workflow:

```
/ironforge:full-workflow Implement user authentication with JWT tokens
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/ironforge:full-workflow <task>` | Run the complete 6-phase workflow |
| `/ironforge:setup` | Verify and install all dependencies |
| `@bmad-agent-analyst` | BMAD analysis agent (requirements, PRD) |
| `@bmad-agent-architect` | BMAD architecture agent (design, tech decisions) |
| `@bmad-agent-sm` | BMAD planning agent (issue decomposition) |
| `@bmad-agent-dev` | BMAD developer agent (implementation) |
| `@bmad-brainstorming` | BMAD brainstorming facilitator |
| `/code-review` | Automated code review with parallel agents |

## Context7 Usage

Context7 activates automatically whenever a library or framework is detected during design or implementation. It injects current, version-specific documentation into the prompt, ensuring the APIs used in specs and code actually exist in the installed version.

You can also trigger it manually:

```
use context7
```

## Security Gates

Ironforge has two layers of security:

1. **security-guidance** (prevention) -- Runs as a `PreToolUse` hook before every `Edit` or `Write` operation. Warns about command injection, XSS, SQL injection, and other OWASP vulnerabilities. Fully automatic, no command needed.

2. **code-review** (validation) -- Runs before merge via `/code-review`. Launches parallel review agents that score findings by confidence. Blocks on high-confidence issues (>= 80).

## Sudocode: Persistent Memory

Specs and issues live in the `.sudocode/` directory and are committed to git. This means:

- Project context survives across sessions
- Any team member can see the current state of specs and issues
- Resuming work requires no re-explanation -- Ironforge reads `.sudocode/` at session start

Initialize in a new project:

```
sudocode init
```

## License

MIT
