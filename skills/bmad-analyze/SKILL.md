---
name: bmad-analyze
description: >
  Runs the BMAD analysis phases to produce structured project artefacts: brief, PRD, and architecture.
  Activates the appropriate BMAD agent for each phase. Each phase requires explicit user validation
  before the next begins. Produces files consumed by /ironforge:bmad-to-sudocode.
argument-hint: "Describe the feature or project, or provide a path to an existing notes/ideas file (e.g. my-notes.md)"
user-invocable: true
disable-model-invocation: false
effort: high
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
  - Write
  - Edit
---

# BMAD Analysis

You are executing the Ironforge BMAD analysis phases. Produce structured artefacts that will feed
into Sudocode via `/ironforge:bmad-to-sudocode`. Each phase ends with user validation — do not
proceed to the next phase without explicit confirmation.

## Task

$ARGUMENTS

If `$ARGUMENTS` is empty and no prior context exists in the conversation, ask the user to describe
the feature or project before starting.

---

## Step 0 — Resolve input

Before anything else, check what `$ARGUMENTS` contains:

**If `$ARGUMENTS` looks like a file path** (ends in `.md`, `.txt`, or the path exists on disk):
1. Read the file
2. Use its content as the raw context for the BMAD analyst in Step 2
3. Tell the user: "I'll use [filename] as input for the brief phase."
4. Do not treat the file as a BMAD brief — it is raw notes, not a structured artefact

**If `$ARGUMENTS` is a text description**: use it directly as context for Step 2.

**If `$ARGUMENTS` is empty**: proceed to Step 1 normally.

---

## Step 1 — Determine which phases to run

Check which artefacts already exist:

| File | Path |
|------|------|
| Brief | `docs/briefs/brief.md` |
| PRD | `docs/prd/prd.md` |
| Architecture | `docs/arch/architecture.md` |

- If a file exists, ask the user whether to regenerate it or skip to the next missing phase.
- Default: skip existing artefacts, run only what is missing.

Also check the workflow mode from context. The mode determines the depth of each phase:

| Mode | Brief | PRD | Architecture |
|------|-------|-----|--------------|
| FEATURE | Short (1 page max) | Focused on the feature only | Component-level only |
| FULL | Complete | Full product scope | System-wide |

If mode is unknown, ask before continuing.

---

## Step 2 — Brief (skip if `docs/briefs/brief.md` exists and user confirms)

Activate `@bmad-agent-analyst`.

Produce a structured brief covering:
- **Problem**: what pain is being solved and for whom
- **Objective**: the measurable outcome
- **Scope**: what is in and explicitly out of scope
- **Constraints**: technical, time, or resource constraints
- **Open questions**: unresolved decisions that will affect design

**FEATURE mode**: keep to a conversational summary, 1 page max. No need for full stakeholder analysis.
**FULL mode**: complete brief with context, user personas, success metrics.

On completion, write the output to `docs/briefs/brief.md` (create `docs/briefs/` if it does not exist).

Present the brief to the user.

> **Gate**: wait for explicit validation ("looks good", "approved", etc.) before continuing.
> If the user requests changes, apply them and re-present. Do not continue until approved.

---

## Step 3 — PRD (skip if `docs/prd/prd.md` exists and user confirms)

Activate `@bmad-agent-pm`.

Produce a PRD from the validated brief covering:
- **Features**: each distinct capability with a clear title
- **User stories**: for each feature, who does what and why
- **Acceptance criteria**: specific, testable conditions for each feature
- **Priority**: MoSCoW or simple P0/P1/P2 labelling
- **Non-goals**: explicitly excluded from this release

**FEATURE mode**: one feature, focused acceptance criteria, no priority matrix needed.
**FULL mode**: complete feature set with priorities and non-goals.

Write the output to `docs/prd/prd.md` (create `docs/prd/` if it does not exist).

Present the PRD to the user.

> **Gate**: wait for explicit validation before continuing.
> Changes requested → apply → re-present → wait again.

---

## Step 4 — Architecture (skip if `docs/arch/architecture.md` exists and user confirms)

Activate `@engineering-software-architect` from agency-agents, combined with `@bmad-brainstorming`.

### Brainstorming first

Before converging on a design, trigger `@bmad-brainstorming`:
- Explore at least 3 distinct architectural approaches
- For each: describe the trade-offs (complexity, performance, maintainability, reversibility)
- Present the options to the user with a recommendation and reasoning

Do not proceed to the architecture doc until the user has chosen an approach (or confirmed the recommendation).

### Architecture document

From the chosen approach, produce:
- **Components**: each major module or service with its responsibilities
- **Interfaces**: how components communicate (APIs, events, data contracts)
- **Data model**: key entities and their relationships (if applicable)
- **Technology choices**: specific libraries/frameworks with version constraints
- **Cross-cutting concerns**: auth, error handling, observability, security boundaries
- **Implementation sequence**: suggested order to build components, with rationale

**FEATURE mode**: component-level only. Skip data model and cross-cutting concerns unless directly relevant.
**FULL mode**: full system-wide architecture.

For every library or framework mentioned, use Context7 to verify the API exists in the current version:
> `use context7` — fetch documentation for [library@version]

Write the output to `docs/arch/architecture.md` (create `docs/arch/` if it does not exist).

Present the architecture to the user.

> **Gate**: wait for explicit validation before continuing.
> Changes requested → apply → re-present → wait again.

---

## Step 5 — Handoff

Once all required phases are validated, output:

```
## BMAD Analysis — Done

**Artefacts produced:**
- [✓ / skipped] docs/briefs/brief.md
- [✓ / skipped] docs/prd/prd.md
- [✓ / skipped] docs/arch/architecture.md

**Next step:** /ironforge:bmad-to-sudocode
```
