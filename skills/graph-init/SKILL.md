---
name: graph-init
description: >
  Initialize Graphify on an existing project. Builds the code knowledge graph, configures
  the MCP server via .mcp.json, installs git hooks for incremental rebuild, and adds
  graphify-out/ to .gitignore. Only useful for existing projects — greenfield projects
  have no ROI.
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
---

# Ironforge Graph Init

Initialize Graphify on the current project. This creates a persistent code knowledge graph
that BMAD agents can query via the `graph-explore` subagent.

---

## Step 1 — Check existing graph

```bash
ls graphify-out/ 2>/dev/null
```

If `graphify-out/` exists, ask the user:

> A Graphify graph already exists. Choose an option:
> 1. Rebuild from scratch (`graphify build` — overwrites existing graph)
> 2. Cancel

Wait for the user's response. If cancel, stop.

---

## Step 2 — Install Graphify

```bash
graphify --version 2>/dev/null || pip install graphifyy
```

If `pip install` fails, tell the user to run it manually and wait for confirmation before
continuing.

---

## Step 3 — Build the graph

```bash
graphify build
```

This indexes the entire codebase. For large projects, this may take a few minutes.
Output lands in `graphify-out/`:
- `graph.json` — queryable graph (used by the MCP server)
- `graph.html` — visual explorer (open in browser to explore)
- `GRAPH_REPORT.md` — top nodes and structural surprises

---

## Step 4 — Install Claude Code integration

```bash
graphify install
```

Graphify manages its own Claude Code integration:
- Writes the MCP server config to `.mcp.json`
- Adds a section to `CLAUDE.md` pointing to `GRAPH_REPORT.md`
- Installs a `PreToolUse` hook in `settings.json`

Do not modify these files manually — Graphify owns them.

---

## Step 5 — Install git hooks

```bash
graphify hook install
```

Installs `post-commit` and `post-checkout` hooks in `.git/hooks/`. These rebuild the graph
incrementally after every commit and branch switch, keeping the graph in sync without
manual intervention.

---

## Step 6 — Update .gitignore

Check if `graphify-out/` is already ignored:

```bash
grep -s "graphify-out" .gitignore
```

If not found, ask the user:

> Add `graphify-out/` to `.gitignore`? The graph is a local artefact — it should not be
> committed. (y/n)

If confirmed, append the line to `.gitignore` (create the file if it does not exist):

```
graphify-out/
```

---

## Step 7 — Summary

Print the final status:

```
## Graphify — Initialized

✓ Graph built           (N nodes, M edges)
✓ MCP configured        (.mcp.json written by graphify install)
✓ Git hooks installed   (post-commit, post-checkout)
✓ graphify-out/ ignored (.gitignore updated)

→ Restart Claude Code to activate the MCP server.
  The MCP server starts automatically from .mcp.json on session start.
  BMAD agents will query the graph via the graph-explore subagent.
```
