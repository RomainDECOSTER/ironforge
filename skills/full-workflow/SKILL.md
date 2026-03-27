---
name: full-workflow
description: >
  Ironforge main workflow. Triggers when the user describes a new feature, bug fix, or refactoring task.
  Orchestrates BMAD agents, Superpowers brainstorming and TDD, Sudocode persistence, Context7 documentation,
  security-guidance, and code-review into a 6-phase structured development pipeline.
argument-hint: "Describe the feature, bug, or refactoring task"
user-invocable: true
disable-model-invocation: false
effort: high
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - Agent
  - WebFetch
  - WebSearch
---

# Ironforge Full Workflow

You are executing the Ironforge structured development workflow. Follow all 6 phases in order. Do not skip any phase.

## Task

$ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what feature, bug, or refactoring task they want to work on before proceeding.

---

## Phase 1: Analysis

Activate the BMAD `@analyst` agent to produce a structured PRD (Product Requirements Document):

- Break down the task into clear, measurable acceptance criteria
- Identify affected components, modules, and system boundaries
- List assumptions and open questions
- Output a structured PRD before moving to Phase 2

---

## Phase 2: Design

Activate the BMAD `@architect` agent combined with Superpowers:

1. **Brainstorming first** — Trigger the Superpowers brainstorming skill before making any technical decision. Explore at least 3 approaches before converging.
2. **Context7 documentation** — For every library or framework mentioned in the design, run `use context7` to fetch up-to-date, version-specific API documentation. Ensure the APIs referenced in the spec actually exist in the current version.
3. **User validation** — Present the proposed architecture to the user for validation before persisting.
4. **Persist the spec** — On user approval, call `upsert_spec()` from Sudocode to save the specification into git (`.sudocode/` directory).

---

## Phase 3: Planning

Activate the BMAD `@scrum-master` agent:

1. Decompose the validated spec into small issues of **2-5 minutes** each
2. Each issue must specify:
   - Exact files to create or modify
   - Dependencies on other issues (execution order)
   - Clear done criteria
3. Call `upsert_issue()` from Sudocode for each issue, including dependency links
4. Present the full issue list to the user for review

---

## Phase 4: Implementation

Activate the BMAD `@dev` agent. Implement issues one by one in dependency order:

### For each issue:

1. **Context7 auto-activation** — When working with any library or framework, Context7 activates automatically to provide current documentation
2. **security-guidance** — Runs automatically as a pre-tool hook before every file write. No manual action needed.
3. **LSP diagnostics** — If rust-analyzer or TypeScript LSP is active, leverage real-time diagnostics (type errors, clippy warnings) and fix them as they appear
4. **TDD cycle (Superpowers)** — Follow the strict RED → GREEN → REFACTOR → COMMIT cycle enforced by Superpowers:
   - **RED**: Write a failing test that captures the issue's acceptance criteria
   - **GREEN**: Write the minimal code to make the test pass
   - **REFACTOR**: Clean up while keeping tests green
   - **COMMIT**: Commit the passing implementation
5. **Update status** — After completing each issue, update its status in Sudocode

---

## Phase 5: Review

After implementing each critical issue (or at the end of the full implementation):

1. Trigger `/code-review` to run automated review with parallel agents
2. **Block on high-confidence findings** — If any issue scores **confidence ≥ 80**, it must be fixed before proceeding
3. Use `/code-review --comment` to post review findings on the PR if one exists
4. Loop back to Phase 4 to fix any blocking findings

---

## Phase 6: Resume Context

This phase applies when resuming work in a new session:

1. Read specs from Sudocode (`.sudocode/` directory) to reload the full project context
2. Read issue statuses to identify what has been completed and what remains
3. Resume from the next pending issue without requiring the user to re-explain the context

---

## Important Guidelines

- Follow phases in strict order (1 → 2 → 3 → 4 → 5)
- Phase 6 only applies when resuming an existing workflow
- If any phase reveals issues or gaps, loop back to the appropriate earlier phase
- Always get user validation before persisting specs (Phase 2) and before starting implementation (Phase 3)
- Each BMAD agent activation should leverage the agent's full capabilities — do not shortcut the methodology
