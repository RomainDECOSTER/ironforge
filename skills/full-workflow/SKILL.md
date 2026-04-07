---
name: full-workflow
description: >
  Ironforge full pipeline orchestrator. Chains all skills in order for a new project or feature:
  start → bmad-analyze → bmad-to-sudocode → implement → review. Use this for projects with no
  existing artefacts. For projects with partial artefacts, invoke individual skills directly.
argument-hint: "Describe the feature or project"
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

You are the Ironforge pipeline orchestrator. Your job is to call each skill in sequence and hand
off context between them. You do not implement the logic of each skill — you coordinate.

This skill is appropriate when starting from scratch. If artefacts already exist, tell the user
to invoke individual skills directly instead.

## Task

$ARGUMENTS

If `$ARGUMENTS` is empty, ask the user what feature or project they want to work on.

---

## Step 1 — Entry check

Before starting the pipeline, run the same artefact check as `/ironforge:start`:

- Does `docs/briefs/brief.md` exist?
- Does `docs/prd/prd.md` exist?
- Does `docs/arch/architecture.md` exist?
- Does `.sudocode/` contain existing specs or issues?

If any of these exist, stop and tell the user:

> Existing artefacts detected. Use individual skills to avoid overwriting prior work:
> - To regenerate BMAD docs: `/ironforge:bmad-analyze`
> - To convert existing BMAD docs: `/ironforge:bmad-to-sudocode`
> - To implement pending issues: `/ironforge:implement`
> - To review: `/ironforge:review`

If nothing exists, continue.

---

## Step 2 — Mode selection

Propose a mode based on the task description (same logic as `/ironforge:start`):

```
## Ironforge — Proposed mode: [FEATURE / FULL]

**Why:** [1-2 sentences]

**Pipeline:**
1. /ironforge:bmad-analyze
2. /ironforge:bmad-to-sudocode
3. /ironforge:implement
4. /ironforge:review

Confirm?
```

FAST mode is not handled by this orchestrator — for FAST tasks, use Superpowers `/quick-spec` directly.

Wait for confirmation before continuing.

---

## Step 3 — BMAD Analysis

Invoke the logic of `/ironforge:bmad-analyze` inline.

Pass the task description and confirmed mode as context. Run all three phases (brief → PRD →
architecture) with their respective gates. Do not proceed until all three artefacts are validated
by the user.

---

## Step 4 — BMAD → Sudocode

Invoke the logic of `/ironforge:bmad-to-sudocode` inline.

All three artefacts exist at this point. Run the full mapping. Present the spec and issue list
to the user before continuing.

Wait for the user to confirm the issue list looks correct before proceeding to implementation.

---

## Step 5 — Implementation

Invoke the logic of `/ironforge:implement` inline.

Work through all pending issues in dependency order. After each issue, ask whether to continue
or pause. Do not run all issues silently in one shot.

---

## Step 6 — Review

Invoke the logic of `/ironforge:review` inline.

Run both passes (code review + QA). If blocking findings are raised, loop back to Step 5 for
fixes, then re-run the review.

---

## Step 7 — Done

```
## Ironforge Full Workflow — Complete

- [✓] BMAD analysis (brief, PRD, architecture)
- [✓] Sudocode specs and issues created
- [✓] All issues implemented and committed
- [✓] Code review and QA approved

Ready to merge.
```
