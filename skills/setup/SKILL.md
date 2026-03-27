---
name: setup
description: >
  Verify and install all Ironforge dependency plugins. Run this once after installing Ironforge,
  or anytime you need to check that all dependencies are properly configured.
user-invocable: true
disable-model-invocation: false
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Ironforge Setup

You are running the Ironforge setup procedure. Verify that all 6 dependency plugins are available and help the user install any that are missing.

## Required Plugins and Installation Commands

Check each plugin's availability in the current session. For any that are missing, provide the exact installation commands below.

### 1. BMAD Method
- **Check**: Look for BMAD agents (`@analyst`, `@architect`, `@scrum-master`, `@dev`)
- **Install**:
  ```
  npx bmad-method install
  ```

### 2. Superpowers
- **Check**: Look for Superpowers skills (brainstorming, TDD enforcement)
- **Install**:
  ```
  /plugin marketplace add obra/superpowers-marketplace
  /plugin install superpowers
  ```

### 3. Sudocode
- **Check**: Look for Sudocode functions (`upsert_spec`, `upsert_issue`)
- **Install**:
  ```
  /plugin marketplace add sudocode-ai/sudocode
  /plugin install sudocode
  ```

### 4. Context7
- **Check**: Look for the `use context7` capability
- **Install**:
  ```
  /plugin marketplace add upstash/context7
  /plugin install context7-plugin@context7-marketplace
  ```

### 5. security-guidance
- **Check**: Look for security-guidance pre-tool hook
- **Install**:
  ```
  /plugin install security-guidance@anthropics-claude-code
  ```

### 6. code-review
- **Check**: Look for `/code-review` command
- **Install**:
  ```
  /plugin install code-review@anthropics-claude-code
  ```

## Post-Install: Initialize Sudocode

After all plugins are confirmed, check if the `.sudocode/` directory exists in the project root. If not, run:

```
sudocode init
```

This creates the `.sudocode/` directory where specs and issues are persisted and committed to git.

## Steps

1. Check which of the 6 plugins are currently available in this session
2. For each missing plugin, display the installation commands above — do NOT run `/plugin` commands yourself, the user must invoke them
3. If `.sudocode/` is missing, inform the user to run `sudocode init`
4. Summarize the status of all 6 plugins (installed / missing)
5. Confirm whether Ironforge is fully configured or list remaining actions
