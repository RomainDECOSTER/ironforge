---
name: full-workflow
description: >
  Ironforge full pipeline orchestrator. Chains all skills in order for a new project or feature:
  start → bmad-analyze → bmad-to-sudocode → implement → review. Use this for projects with no
  existing artefacts. For projects with partial artefacts, invoke individual skills directly.
argument-hint: "Describe the feature or project, or provide a path to an existing notes/ideas file (e.g. my-notes.md)"
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

Before starting the pipeline, check if `$ARGUMENTS` is a file path (ends in `.md`, `.txt`, or exists on disk). If so, read the file and treat its content as raw input notes for the BMAD analyst. This is not a BMAD artefact — it is free-form context. Continue with the pipeline.

Then check for existing BMAD artefacts:

- Does `docs/briefs/brief.md` exist?
- Does `docs/prd/prd.md` exist?
- Does `docs/arch/architecture.md` exist?
- Does `.sudocode/` contain existing specs or issues?

If any of these exist **and no input file was provided**, stop and tell the user:

> Existing artefacts detected. Use individual skills to avoid overwriting prior work:
> - To regenerate BMAD docs: `/ironforge:bmad-analyze`
> - To convert existing BMAD docs: `/ironforge:bmad-to-sudocode`
> - To implement pending issues: `/ironforge:implement`
> - To review: `/ironforge:review`

If nothing exists, or if an input file was provided, continue.

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

### Graph context for Step 3 (if available)

If `graphify-out/` exists, delegate to the graph-explore agent once per BMAD phase (Brief, PRD, Architecture)
with the same questions as in `/ironforge:bmad-analyze`:
- Brief: delegate to the graph-explore agent with this query: "Quels modules et features existent déjà dans le codebase ?"
- PRD: delegate to the graph-explore agent with this query: "Quelles sont les interfaces publiques et les points d'entrée existants ?"
- Architecture: delegate to the graph-explore agent with this query: "Quels patterns architecturaux sont utilisés ? Quelles dépendances du module cible ?"

Prepend any returned content as `## Contexte graphe\n{graph_context}` to each agent's context.
If `graphify-out/` is absent, run the phases normally.

---

## Step 3 — BMAD Analysis

Invoke the logic of `/ironforge:bmad-analyze` inline.

Pass the task description and confirmed mode as context. Run all three phases (brief → PRD →
architecture) with their respective gates. Do not proceed until all three artefacts are validated
by the user.

---

### Graph context for Step 4 (if available)

If `graphify-out/` exists, delegate to the graph-explore agent before the Scrum Master maps issues:

> Delegate to the graph-explore agent with this query: "Quel est le blast radius du changement prévu ?"

Use the returned content to inform issue sizing and dependency mapping.
If `graphify-out/` is absent or graph-explore returns empty, proceed normally.

---

## Step 4 — BMAD → Sudocode

Invoke the logic of `/ironforge:bmad-to-sudocode` inline.

All three artefacts exist at this point. Run the full mapping. Present the spec and issue list
to the user before continuing.

Wait for the user to confirm the issue list looks correct before proceeding to implementation.

---

### Graph context for Step 5 (if available)

For each issue, if `graphify-out/` exists, delegate to the graph-explore agent before starting the TDD cycle:

> Delegate to the graph-explore agent with this query: "Qui appelle {cible} ? Que fait-elle appeler ?"

Replace `{cible}` with the function or module targeted by the current issue.
Use the returned content to identify additional files to read beyond those listed in the issue.
If `graphify-out/` is absent or graph-explore returns empty, proceed normally.

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
