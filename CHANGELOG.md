# Changelog

All notable changes to Ironforge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.4.0](https://github.com/RomainDECOSTER/ironforge/compare/v3.3.0...v3.4.0) (2026-04-14)


### Features

* offer full /graphify pipeline or quick build in graph-init ([7e257c3](https://github.com/RomainDECOSTER/ironforge/commit/7e257c3ca08a77588de1fc57630781be61ff0c97))


### Bug Fixes

* replace graphify build with graphify update . (correct command) ([5bbe789](https://github.com/RomainDECOSTER/ironforge/commit/5bbe789fdba0e5881d95d3730088b5b28e3ca793))

## [3.3.0](https://github.com/RomainDECOSTER/ironforge/compare/v3.2.0...v3.3.0) (2026-04-14)


### Features

* mention Graphify in install.sh output and suggest graph-init for existing projects ([13980c9](https://github.com/RomainDECOSTER/ironforge/commit/13980c9d00e223ff30dc400bb61e6bfde8276d23))


### Bug Fixes

* auto-start Sudocode server on session start ([df92f11](https://github.com/RomainDECOSTER/ironforge/commit/df92f1172f1539fdfd9ba8a6b39341334c198146))
* complete graph-init skill with missing graphify install steps ([2e79606](https://github.com/RomainDECOSTER/ironforge/commit/2e7960688d5c4ec829ef64714fc0848ab267919c))

## [3.2.0](https://github.com/RomainDECOSTER/ironforge/compare/v3.1.0...v3.2.0) (2026-04-14)


### Features

* add graph-explore subagent — encapsulates Graphify MCP queries ([f8d58c4](https://github.com/RomainDECOSTER/ironforge/commit/f8d58c408dbd027d16c85c739c66cdc9fb79b024))
* add graph-init skill — initialize Graphify on existing projects ([bf9ccec](https://github.com/RomainDECOSTER/ironforge/commit/bf9ccec3e03654afeb7815368f4025137ef5701c))
* add Graphify awareness to SessionStart hook prompt ([2c5868b](https://github.com/RomainDECOSTER/ironforge/commit/2c5868b61a59a49f99ca3228a7774596d2988a8f))
* add release-please GitHub Actions workflow ([d829802](https://github.com/RomainDECOSTER/ironforge/commit/d8298024146d9b853467056d7423907debf04705))
* inject graph-explore blast radius check into implement skill ([395470c](https://github.com/RomainDECOSTER/ironforge/commit/395470c2d8e3719f2a13a232c4c93c08305fe30c))
* inject graph-explore context into bmad-analyze phases ([42b17a8](https://github.com/RomainDECOSTER/ironforge/commit/42b17a8858bc75f951be6bb0c734798ff8ff5926))
* inject graph-explore context into full-workflow phases ([6b2548d](https://github.com/RomainDECOSTER/ironforge/commit/6b2548d4b9a5107c1cf593206b4e9a495e39b467))


### Bug Fixes

* clarify MCP error fallback in graph-explore ([c19ca1e](https://github.com/RomainDECOSTER/ironforge/commit/c19ca1e3463b61b2d4a5144b227787e9a23c210b))
* remove unsupported changelog-type from release-please config ([a0d6d3a](https://github.com/RomainDECOSTER/ironforge/commit/a0d6d3a783d5fb9ff77801ded73f8eaa0616e920))

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
