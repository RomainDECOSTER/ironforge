---
name: implement
description: >
  Implements Sudocode issues one by one in dependency order using strict TDD (RED → GREEN → REFACTOR → COMMIT).
  Activates Context7 for library documentation and leverages LSP diagnostics when available.
  Updates issue status in Sudocode after each commit.
argument-hint: "Issue ID to implement (e.g. i-xxxx), or omit to start from the next pending issue"
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

# Ironforge Implement

You are executing the Ironforge implementation phase. Work through Sudocode issues in dependency
order, one at a time. Follow the TDD cycle strictly for every issue.

## Arguments

$ARGUMENTS

- If a specific issue ID is provided, start from that issue.
- If no argument is given, read Sudocode to find the next pending issue (no blockers, not started).
- If all issues are complete, tell the user and suggest `/ironforge:review`.

---

## Step 1 — Load context

1. Read `.sudocode/` to get the full list of specs and issues
2. Identify the target issue:
   - If an ID was given: load that issue and verify its blockers are resolved
   - Otherwise: find the first pending issue with no unresolved dependencies
3. Read the linked spec for the target issue
4. Present a one-line summary of what will be implemented and wait 3 seconds — do not ask for
   confirmation unless a blocker is detected

If a blocker is detected (dependency issue not yet complete), stop and report:
> Issue [id] is blocked by [id] — implement that one first, or run `/ironforge:implement [id]`

---

## Step 2 — Pre-implementation check

Before writing any code:

1. Read the files listed in the issue as "files to modify or create"
2. If the files don't exist yet, note they will be created
3. Verify the issue's done criteria are unambiguous — if they are vague, ask the user to clarify
   before starting

---

## Step 3 — TDD cycle

Activate `@bmad-agent-dev`. Follow this cycle strictly. Do not skip or merge steps.

### RED — Write a failing test

1. Write a test that captures the issue's acceptance criteria
2. The test must fail before any implementation code is written
3. Run the test suite to confirm the failure:
   ```bash
   # Rust
   cargo test [test_name] 2>&1

   # TypeScript / Node
   npm test -- --testNamePattern="[test_name]" 2>&1

   # Python
   pytest [test_file]::[test_name] -v 2>&1
   ```
4. Confirm the failure is for the right reason (not a compile error or unrelated failure)

### GREEN — Write minimal code

1. Write the minimum code to make the failing test pass
2. Do not add features beyond what the test requires
3. Use Context7 for any library or framework involved:
   > `use context7` — fetch documentation for [library@version]
4. Run the test suite to confirm the test passes:
   ```bash
   cargo test 2>&1 | tail -5
   # or npm test / pytest equivalent
   ```
5. If LSP diagnostics are active (rust-analyzer or TypeScript LSP), fix all type errors and
   warnings before moving to REFACTOR

### REFACTOR — Clean up

1. Review the code written in GREEN for:
   - Duplication that can be extracted
   - Names that are unclear
   - Logic that can be simplified
   - Missing error handling at system boundaries (user input, external calls)
2. Run the full test suite after each refactor change to confirm nothing broke
3. Do not add new behaviour during REFACTOR

### COMMIT — Commit the passing implementation

```bash
git add [files changed]
git commit -m "[issue-id] [short description of what was implemented]"
```

Commit message format: `i-xxxx Short description in imperative mood`

---

## Step 4 — Update Sudocode

After the commit, mark the issue as complete via `upsert_issue()`:
- Status: `done`
- Include the commit hash in the issue notes

---

## Step 5 — Continue or stop

Check the remaining issue list:

- **If there are more pending issues with no blockers**: ask the user whether to continue with
  the next issue or stop here.
- **If all issues are complete**: output:

```
## Implementation — Done

All issues implemented and committed.

**Next step:** /ironforge:review
```

- **If the next issue is blocked**: report which issue is blocked and by what, and ask whether
  to continue with an unblocked issue or stop.
