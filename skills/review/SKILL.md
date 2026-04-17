---
name: review
description: >
  Reviews implemented code via agency-agents before merge. Runs @engineering-code-reviewer
  on the diff, then @testing-reality-checker for QA sign-off. Blocks on critical findings
  and loops back to /ironforge:implement for fixes.
user-invocable: true
disable-model-invocation: false
effort: medium
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

# Ironforge Review

You are executing the Ironforge review phase. Run two passes — code review then QA sign-off.
Block on critical findings. Do not approve a merge with unresolved blocking issues.

---

## Step 1 — Prepare the diff

Get the changes to review:

```bash
# All commits since branching from main
git diff main...HEAD 2>&1

# Or if on main, commits since last tag
git diff $(git describe --tags --abbrev=0)...HEAD 2>&1
```

Also get the list of files changed:

```bash
git diff --name-only main...HEAD 2>&1
```

If the diff is empty, stop and tell the user there is nothing to review.

Present a brief summary of what changed (files touched, rough scope) before activating agents.

---

## Step 2 — Graph context (optional)

If `graphify-out/` exists in the project root, spawn the `graph-explore` subagent before activating the reviewer:

- Query: the list of files changed from Step 1
- Ask for direct dependents and callers of the modified modules

Use the returned context to enrich the review in Step 3: flag any caller or dependent module that may be impacted but is not covered by the diff or existing tests.

If `graphify-out/` is absent or `graph-explore` returns empty, skip this step and proceed normally.

---

## Step 3 — Code review

Activate `@engineering-code-reviewer`.

Provide the agent with:
- The full diff from Step 1
- The relevant Sudocode specs and issues (read from `.sudocode/`) for acceptance criteria context
- The architecture doc (`docs/arch/architecture.md`) if it exists
- The graph context from Step 2 (if available) — list of impacted callers and dependents

The agent should evaluate:

**Correctness**
- Does the implementation match the acceptance criteria in the specs?
- Are edge cases handled?
- Is error handling present at system boundaries?

**Code quality**
- Are names clear and consistent with the existing codebase?
- Is there duplication that should be extracted?
- Are abstractions at the right level (not too early, not missing)?

**Security**
- Any injection vectors (SQL, command, XSS)?
- Secrets or credentials in code or logs?
- Improper input validation at boundaries?

**For each finding**, the agent must classify:
- **BLOCKING** — must be fixed before merge (correctness bug, security issue, broken contract)
- **SUGGESTION** — improvement worth making but not blocking
- **NITPICK** — style or minor preference, take it or leave it

Present the full review output.

---

## Step 4 — Handle findings

**If there are BLOCKING findings:**

List them clearly:
```
## Blocking findings

1. [file:line] Description of the issue
   Fix: suggested correction

2. ...
```

Then stop and tell the user:
> These findings must be fixed before proceeding. Run `/ironforge:implement` to address them,
> then re-run `/ironforge:review`.

Do not continue to Step 5 until all BLOCKING findings are resolved.

**If there are only SUGGESTION and NITPICK findings:**

Present them and ask the user which (if any) they want to address. Do not block on them.
Continue to Step 5.

**If there are no findings:**

Note it and continue to Step 5.

---

## Step 5 — QA sign-off

Activate `@testing-reality-checker`.

Provide the agent with:
- The diff from Step 1
- The acceptance criteria from Sudocode specs
- The test files changed or added during implementation

The agent should verify:

**Test coverage**
- Does each acceptance criterion have at least one test?
- Are happy path and failure cases both covered?
- Are tests testing behaviour (not implementation details)?

**Test quality**
- Do tests actually fail when the code is broken? (no tautological assertions)
- Are test names descriptive enough to diagnose failures without reading the body?

**Reality check**
- Is there anything in the implementation that looks correct but will fail in production
  (race conditions, wrong assumptions about external systems, missing config)?

For each gap, classify as BLOCKING or SUGGESTION using the same criteria as Step 3.

Present the full QA output.

---

## Step 6 — Handle QA findings

Same logic as Step 4: block on BLOCKING, present suggestions without blocking.

---

## Step 7 — Final verdict

**If all findings are resolved or non-blocking:**

```
## Review — Approved

- Code review: ✓
- QA sign-off: ✓

**Suggestions noted:** X (non-blocking)

Ready to merge.
```

**If blocking findings remain unresolved:**

```
## Review — Blocked

Fix the blocking findings above, then re-run /ironforge:review.
```
