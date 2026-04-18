---
name: bmad-to-sudocode
description: >
  Converts existing BMAD artefacts (brief, PRD, architecture) into Sudocode specs and issues.
  Invocable standalone on projects that already have BMAD docs. Checks which files exist,
  maps each to Sudocode, and generates a dependency graph between issues.
user-invocable: true
disable-model-invocation: false
effort: medium
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

# BMAD → Sudocode Handoff

You are executing the Ironforge BMAD → Sudocode handoff. Your job is to read the existing BMAD
artefacts and persist them into Sudocode as specs and issues.

Do not regenerate or rewrite the BMAD docs. Work strictly from what exists.

---

## Step 1 — Check available artefacts

Verify which BMAD files are present. Report status before doing anything.

| File | Path | Status |
|------|------|--------|
| Brief | `docs/briefs/brief.md` | ✓ / missing |
| PRD | `docs/prd/prd.md` | ✓ / missing |
| Architecture | `docs/arch/architecture.md` | ✓ / missing |

If none of the three files exist, stop and tell the user:
> No BMAD artefacts found. Run `/ironforge:bmad-analyze` first to produce them.

If some files are missing, continue with what is available and note the gaps clearly.

---

## Step 2 — Check Sudocode state

Check if `.sudocode/` exists and is initialized. If not, run:

```bash
sudocode init
```

Then check for existing specs and issues to avoid creating duplicates. If specs already exist,
ask the user whether to update them or skip.

---

## Step 3 — Map brief → high-level spec

If `docs/briefs/brief.md` exists:

1. Read the file
2. Extract:
   - Project name and one-line description
   - Core problem being solved
   - Out-of-scope items
3. Create one top-level spec via `upsert_spec()`:
   - **Title**: project name from the brief
   - **Description**: problem + objective synthesized from the brief (2-4 sentences)
   - **Acceptance criteria**: none at this level — this is a container spec
   - **Tags**: `["brief", "top-level"]`

---

## Step 4 — Map PRD → functional specs

If `docs/prd/prd.md` exists:

1. Read the file
2. Identify each distinct feature or functional requirement section
3. For each feature, create one spec via `upsert_spec()`:
   - **Title**: feature name
   - **Description**: feature description from the PRD
   - **Acceptance criteria**: extracted verbatim from the PRD section
   - **Parent**: the top-level spec created in Step 3 (if it exists)
   - **Tags**: `["prd", "functional"]`
4. After creating all specs, present the list to the user for a quick sanity check before continuing

---

## Step 5 — Map architecture → technical specs and issues

If `docs/arch/architecture.md` exists:

1. Read the file
2. Identify the major technical components, layers, or decisions described

**For each major component**, create one technical spec via `upsert_spec()`:
   - **Title**: component name
   - **Description**: technical description and responsibilities
   - **Acceptance criteria**: technical constraints and interface contracts
   - **Parent**: the relevant functional spec from Step 4, if a clear mapping exists
   - **Tags**: `["architecture", "technical"]`

**For each implementation task implied by the architecture**, create one issue via `upsert_issue()`:
   - **Title**: concrete action (e.g. "Implement X struct with Y interface")
   - **Description**: what needs to be built, which files are affected
   - **Spec**: linked to the relevant technical spec
   - **Size**: keep to 2-5 minutes of focused implementation work — split if larger
   - **Dependencies**: note dependencies between issues (do not link yet, collect first)

---

## Step 6 — Set issue dependencies

After all issues are created:

1. Review the collected dependency notes
2. For each dependency pair (A depends on B), update issue A with the dependency link via `upsert_issue()`
3. Present the resulting dependency graph as a simple list:

```
[issue-id] Title
  └─ depends on: [issue-id] Title
```

---

## Step 7 — Summary

Output a final summary:

```
## BMAD → Sudocode — Done

**Specs created:** X
**Issues created:** Y
**Artefacts skipped:** [list missing files]

**Next step:** /ironforge:implement
```

If issues existed before this run, report what was updated vs. created.
