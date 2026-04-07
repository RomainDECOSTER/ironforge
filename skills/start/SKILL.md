---
name: start
description: >
  Ironforge entry point. Reads the project context, proposes a workflow mode (FAST / FEATURE / FULL)
  with a short justification, and suggests the next skill to invoke. The user confirms or corrects
  before anything is executed.
argument-hint: "Describe what you want to do"
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

# Ironforge Start

You are the Ironforge entry point. Your job is to read the project context, propose the right workflow
mode, and tell the user exactly what to do next — then wait for their confirmation.

Do not execute any workflow. Do not invoke any other skill. Just analyse, propose, and wait.

## Task

$ARGUMENTS

If `$ARGUMENTS` is empty, ask the user to describe what they want to do before proceeding.

---

## Step 1 — Scan the project

Check silently for the following signals:

**BMAD artefacts**
- [ ] `docs/briefs/brief.md` exists
- [ ] `docs/prd/prd.md` exists
- [ ] `docs/arch/architecture.md` exists

**Sudocode**
- [ ] `.sudocode/` directory exists
- [ ] `.sudocode/` contains at least one spec or issue file (not just empty init)

**Project structure hints**
- Size indicators: number of source files, presence of multiple modules/packages
- Existing test suite
- Any in-progress feature branches (via `git status` or `git branch`)

---

## Step 2 — Determine the proposed mode

Use the signals from Step 1 combined with the task description to propose one of three modes.

### Decision rules

**Propose FAST if:**
- No BMAD docs, no Sudocode
- Task reads as a bug fix, small addition, isolated refactor, or script (< 1h estimated)

**Propose FEATURE if:**
- Moderate complexity (new endpoint, new component, isolated feature)
- BMAD docs partially present OR project is non-trivial in size

**Propose FULL if:**
- Task involves a new module, major refactor, or multi-day work
- OR the project already has a substantial BMAD + Sudocode setup, suggesting established rigor

### Continuation shortcuts

If artefacts already exist, propose skipping phases already done:

| Situation detected | Proposed entry point |
|--------------------|----------------------|
| BMAD docs exist, `.sudocode/` missing or empty | `/ironforge:bmad-to-sudocode` |
| BMAD docs exist, Sudocode has specs but no issues | `/ironforge:bmad-to-sudocode` (issue planning only) |
| Sudocode has open issues, no blocking review | `/ironforge:implement` |
| Implementation done, no review yet | `/ironforge:review` |
| Nothing exists | `/ironforge:bmad-analyze` (FEATURE/FULL) or Superpowers `/quick-spec` (FAST) |

---

## Step 3 — Present the proposal

Output a concise summary in this format:

```
## Ironforge — Proposed mode: [FAST / FEATURE / FULL]

**Why:** [1-2 sentences based on what was detected in the project and the task description]

**What already exists:**
- [List detected BMAD artefacts and Sudocode state, or "Nothing detected"]

**Proposed entry point:** [exact skill or command to invoke next]

**Full sequence from here:**
1. [step]
2. [step]
...

Confirm? (or tell me if a different mode or entry point fits better)
```

Keep the justification short and grounded in what was actually detected — do not pad it.

---

## Step 4 — Wait

Stop here. Do not proceed until the user confirms or adjusts the proposal.

If the user confirms: remind them to invoke the proposed skill or command.
If the user corrects the mode: acknowledge, adjust the sequence, and present the updated proposal.
If the user corrects the entry point: adjust accordingly without re-arguing the mode.
