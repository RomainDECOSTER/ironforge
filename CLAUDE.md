# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is Ironforge

Ironforge is a Claude Code plugin that orchestrates a structured development workflow by integrating five dependency plugins: BMAD Method, Superpowers, Sudocode, Context7, and security-guidance.

It does not have a build system or test suite of its own — the repository consists of shell scripts, JSON manifests, and Markdown skill files.

## Commands

**Install Ironforge and all dependencies:**
```bash
bash install.sh
```

**Bump version (updates `plugin.json`, `CHANGELOG.md`, creates git commit):**
```bash
./scripts/bump-version.sh <major|minor|patch>
```

**Verify all 5 dependency plugins are available (from within Claude Code):**
```
/ironforge:setup
```

## Architecture

### Plugin manifest
`.claude-plugin/plugin.json` is the entry point. It declares the plugin version, points to the `skills/` directory, and configures two LSP servers (rust-analyzer, typescript-language-server) that are conditionally activated by the detect-lsp hook.

### Session startup (hooks)
`hooks/hooks.json` registers a `SessionStart` hook that:
1. Runs `scripts/detect-lsp.sh` — scans the working directory for `Cargo.toml` (→ rust-analyzer) or `package.json`/`tsconfig.json` (→ TypeScript LSP), then writes a marker to `${CLAUDE_PLUGIN_DATA}/.initialized`
2. Prompts Claude to verify all 5 dependency plugins are available

### Skills (user-invocable commands)

| Skill | Command | Role |
|-------|---------|------|
| `skills/start/` | `/ironforge:start` | Assisted mode selection, detects existing artefacts, proposes entry point |
| `skills/bmad-analyze/` | `/ironforge:bmad-analyze` | Runs BMAD phases: brief → PRD → architecture, with human gates |
| `skills/bmad-to-sudocode/` | `/ironforge:bmad-to-sudocode` | Converts existing BMAD docs into Sudocode specs and issues |
| `skills/implement/` | `/ironforge:implement [issue-id]` | TDD implementation of Sudocode issues (RED→GREEN→REFACTOR→COMMIT) |
| `skills/review/` | `/ironforge:review` | Code review + QA sign-off via agency-agents |
| `skills/full-workflow/` | `/ironforge:full-workflow <task>` | Orchestrator: chains all skills for a project with no existing artefacts |
| `skills/setup/` | `/ironforge:setup` | Checks dependencies and reports what is missing |

### Workflow modes

| Mode | Trigger | Entry point |
|------|---------|-------------|
| FAST | Bug fix, small change (< 1h) | Superpowers `/quick-spec` directly |
| FEATURE | New feature, new component (1h–1 day) | `/ironforge:start` → bmad-analyze → bmad-to-sudocode → implement → review |
| FULL | New module, major refactor (1 day+) | `/ironforge:start` → bmad-analyze → bmad-to-sudocode → implement → review |

Skills are composable — invoke any skill independently when artefacts already exist.

### BMAD artefact paths (standardized)

```
docs/
  briefs/   → docs/briefs/brief.md
  prd/      → docs/prd/prd.md
  arch/     → docs/arch/architecture.md
.sudocode/  → specs and issues (FEATURE and FULL)
```

### Versioning
`scripts/bump-version.sh` handles semantic versioning. It updates `.claude-plugin/plugin.json` and `CHANGELOG.md`, and prints the git commands to commit and tag the release (it does not commit automatically).
