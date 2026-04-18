# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is Ironforge

Ironforge is a Claude Code plugin that orchestrates a structured development workflow by integrating five dependency plugins: BMAD Method, Superpowers, Sudocode, Context7, and security-guidance.

It does not have a build system or test suite of its own — the repository consists of shell scripts, JSON manifests, and Markdown skill files.

## Commands

**Install Ironforge and all dependencies (Claude Code):**
```bash
bash install.sh
```

**Install Ironforge for GitHub Copilot CLI:**
```bash
bash install-copilot.sh
```

**Versioning (automated via release-please):**

Releases are fully automated. On every push to `main`:
1. GitHub Actions scans commits since the last tag
2. If releasable commits are found (`feat:`, `fix:`, `feat!:`), a Release PR is opened/updated
3. Merging the Release PR creates the git tag and GitHub Release

Use [Conventional Commits](https://www.conventionalcommits.org/) in your commit messages:
- `feat: description` → minor bump
- `fix: description` → patch bump
- `feat!: description` or `BREAKING CHANGE:` footer → major bump
- `docs:`, `chore:`, `refactor:` → no release

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
2. Runs `scripts/start-sudocode-server.sh` — starts the sudocode local server as a background process (singleton-guarded: no-ops if an instance is already running for the current user)
3. Prompts Claude to verify all 5 dependency plugins are available

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

### Copilot CLI support

`copilot/` is a parallel plugin subtree for GitHub Copilot CLI. It mirrors the Claude Code
plugin but uses prose-based agent delegation instead of `@agent-name` syntax.

| File | Purpose |
|------|--------|
| `copilot/plugin.json` | Copilot CLI manifest |
| `copilot/AGENTS.md` | Ambient instructions (equivalent of the SessionStart prompt hook) |
| `copilot/hooks/hooks.json` | Copilot CLI hooks format (command hooks only) |
| `copilot/skills/` | Adapted SKILL.md files (9 skills) |
| `install-copilot.sh` | One-command installer for Copilot CLI |

Scripts in `scripts/` are shared — both sides invoke them via `${CLAUDE_PLUGIN_ROOT}`.

### Release workflow

Releases are managed by [release-please](https://github.com/googleapis/release-please) via GitHub Actions. The workflow:
- Scans for Conventional Commits since the last tag
- Opens or updates a Release PR with bumped version and updated CHANGELOG
- Merging the Release PR automatically creates a git tag and GitHub Release

No manual version bumping needed — use Conventional Commits in your PRs and commits.

Configuration files: `.release-please-manifest.json`, `release-please-config.json`, `.github/workflows/release-please.yml`
