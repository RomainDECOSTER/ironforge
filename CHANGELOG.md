# Changelog

All notable changes to Ironforge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.1.0] - 2026-04-07

### Added

- `bmad-analyze` and `full-workflow` now accept a file path as argument — reads the file as raw notes and passes it to `@bmad-agent-analyst` as context to generate the brief
- `full-workflow` no longer blocks when an input file is provided alongside existing BMAD artefacts

## [3.0.2] - 2026-04-07

### Fixed

- agency-agents install now uses `find` to copy all `.md` files from root subdirectories (`engineering/`, `testing/`, etc.) — repo has no `agents/` folder at root

## [3.0.1] - 2026-04-07

### Fixed

- agency-agents now installed project-local into `.claude/agents/` instead of globally into `~/.claude/agents/`

## [3.0.0] - 2026-04-07

### Added

- `/ironforge:start` skill — assisted mode selection (FAST/FEATURE/FULL); reads project context, proposes mode with justification, waits for confirmation
- `/ironforge:bmad-analyze` skill — runs BMAD phases (brief → PRD → architecture) with human validation gates at each step; adapts depth to mode
- `/ironforge:bmad-to-sudocode` skill — standalone handoff from existing BMAD artefacts to Sudocode specs and issues; generates dependency graph between issues
- `/ironforge:implement` skill — TDD implementation of Sudocode issues in dependency order (RED → GREEN → REFACTOR → COMMIT); supports issue ID argument
- `/ironforge:review` skill — two-pass review: `@engineering-code-reviewer` then `@testing-reality-checker`; blocks on BLOCKING findings only
- agency-agents integration — installed via `git clone` into `~/.claude/agents/`; replaces code-review-graph for review and QA

### Changed

- `/ironforge:full-workflow` refactored as a thin orchestrator that chains atomic skills; refuses to run if artefacts already exist
- `install.sh` updated to install agency-agents and drop code-review-graph
- `hooks.json` SessionStart prompt updated to check agency-agents and correct BMAD agent names
- CLAUDE.md rewritten to document the new composable skill architecture
- README rewritten with new skill table, workflow modes, and typical flow examples

### Removed

- `code-review-graph` dependency — replaced by agency-agents reviewers

## [2.0.0] - 2026-03-30

### Added

- `install.sh` — one-command installer that sets up Ironforge and all 6 dependency plugins
  via the `claude plugin` CLI

### Changed

- README: installation now uses `install.sh` instead of manual `/plugin` commands
- README: skill commands updated to use namespaced format (`/ironforge:setup`, `/ironforge:full-workflow`)

### Removed

- `scripts/postinstall.sh` — replaced by `install.sh`

## [1.0.3] - 2026-03-30

### Fixed

- Fix plugin structure to ensure correct loading of marketplace manifest and plugin manifest

## [1.0.2] - 2026-03-30

### Fixed

- Fix source in marketplace manifest to point to correct GitHub repository URL

## [1.0.1] - 2026-03-30

### Added

- Marketplace manifest (`.claude-plugin/marketplace.json`) for proper plugin installation
- CHANGELOG.md and `scripts/bump-version.sh` for semantic versioning

### Fixed

- Installation commands now use correct `@ironforge-marketplace` syntax

## [1.0.0] - 2026-03-28

### Added

- Plugin manifest (`.claude-plugin/plugin.json`) with 6 permanent dependencies and 2 conditional LSPs
- `/full-workflow` skill: 6-phase orchestration (Analysis, Design, Planning, Implementation, Review, Resume)
  - Phase 1: `@bmad-agent-analyst` for structured PRD
  - Phase 2: `@bmad-agent-architect` + `@bmad-brainstorming` + Context7
  - Phase 3: `@bmad-agent-sm` for issue decomposition via Sudocode
  - Phase 4: `@bmad-agent-dev` with TDD cycle (RED → GREEN → REFACTOR → COMMIT)
  - Phase 5: `/code-review` with confidence-based blocking (≥ 80)
  - Phase 6: Session resume via Sudocode specs and issue statuses
- `/setup` skill for dependency verification and installation guide
- `SessionStart` hook with LSP auto-detection (`Cargo.toml` → rust-analyzer, `package.json`/`tsconfig.json` → TypeScript LSP)
- `detect-lsp.sh` project scanner with first-run marker
- `postinstall.sh` manual dependency installation helper
- README with full documentation

[3.1.0]: https://github.com/RomainDECOSTER/ironforge/compare/v3.0.2...v3.1.0
[3.0.2]: https://github.com/RomainDECOSTER/ironforge/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/RomainDECOSTER/ironforge/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/RomainDECOSTER/ironforge/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.3...v2.0.0
[1.0.3]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/RomainDECOSTER/ironforge/releases/tag/v1.0.0
