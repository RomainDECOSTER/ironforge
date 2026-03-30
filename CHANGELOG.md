# Changelog

All notable changes to Ironforge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[2.0.0]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.3...v2.0.0
[1.0.3]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/RomainDECOSTER/ironforge/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/RomainDECOSTER/ironforge/releases/tag/v1.0.0
