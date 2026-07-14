# Private Memory and Upstream Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep personal learning private and local while automatically proposing each qualified universal improvement to the public GitHub repository through a verified draft PR, with a token-bounded filename-only notice.

**Architecture:** The installed engine reads two roots: a private local root for user taste/private evidence and a universal root sourced from the public repository. A dedicated upstream contribution contract classifies, sanitizes, branches, verifies, pushes, and opens draft PRs. One qualified universal improvement is sufficient; main is never pushed or merged automatically. Sanitized contributions blocked by upstream access wait in persistent local `UPSTREAM_QUEUE.md`.

**Tech Stack:** Markdown Agent Skill, Git, GitHub CLI contract, Bash installer, PowerShell installer.

## Global Constraints

- Personal taste, private evidence, project facts, local paths, and sensitive data never enter the public repository.
- One qualified universal improvement may open a draft PR; batching is not required.
- Every public engine change includes a relevant pressure scenario and verification evidence.
- No direct push to `main` and no automatic merge.
- After a memory or skill write, the user-visible notice names changed files and any draft PR only; it does not explain the lesson unless asked.
- Existing private memory and pending upstream queue entries are never overwritten on reinstall or upstream sync.
- Quality, TDD, review, security, accessibility, and final verification are never weakened.

---

### Task 1: Add behavioral RED coverage

**Files:**
- Modify: `tests/pressure-scenarios.md`
- Modify: `tests/baseline-observations.md`

- [x] **Step 1: Add private/public separation scenario**
- [x] **Step 2: Add one-improvement draft-PR scenario**
- [x] **Step 3: Add compact filename-only notification scenario**
- [x] **Step 4: Record the missing behavior in baseline RED evidence**

### Task 2: Split private and universal storage contracts

**Files:**
- Modify: `skills/codex-self-improvement/SKILL.md`
- Modify: `skills/codex-self-improvement/references/memory-schema.md`
- Modify: `skills/codex-self-improvement/references/taste-learning.md`
- Modify: `skills/codex-self-improvement/references/reflection-procedure.md`
- Create: `memory/private-template/*`
- Delete: public learned taste files

- [x] **Step 1: Define `PRIVATE_LOCATION` and `UNIVERSAL_LOCATION` resolution**
- [x] **Step 2: Route user taste and private evidence only to private storage**
- [x] **Step 3: Keep universal patterns and engine evidence public-compatible**
- [x] **Step 4: Replace public personal seeds with neutral private templates**
- [x] **Step 5: Require a compact filename-only update notice after actual writes**

### Task 3: Add automatic upstream contribution contract

**Files:**
- Create: `skills/codex-self-improvement/references/upstream-contribution.md`
- Modify: `skills/codex-self-improvement/SKILL.md`
- Modify: `install/AGENTS-snippet.md`

- [x] **Step 1: Define the universal qualification and privacy gate**
- [x] **Step 2: Define dedicated branch creation from current upstream `main`**
- [x] **Step 3: Require relevant pressure scenario and fresh verification**
- [x] **Step 4: Push and create/update a draft PR without direct main writes**
- [x] **Step 5: Make one qualified improvement sufficient**
- [x] **Step 6: Define compact completion notice with filename(s) and PR reference**

### Task 4: Update installers for separated state

**Files:**
- Modify: `install.sh`
- Modify: `install.ps1`

- [x] **Step 1: Install engine files normally**
- [x] **Step 2: Refresh universal memory from repository on reinstall**
- [x] **Step 3: Seed private templates only when missing**
- [x] **Step 4: Write `PRIVATE_LOCATION`, `UNIVERSAL_LOCATION`, `UPSTREAM_LOCATION`, and `UPSTREAM_REPOSITORY`**
- [x] **Step 5: Preserve existing private memory across repeated installs**

### Task 5: Add persistent retry state

**Files:**
- Create: `memory/private-template/UPSTREAM_QUEUE.md`
- Modify: `skills/codex-self-improvement/references/memory-schema.md`
- Modify: `skills/codex-self-improvement/references/upstream-contribution.md`
- Modify: installer verification scenarios

- [x] **Step 1: Add RED evidence for a pending contribution lost during universal refresh**
- [x] **Step 2: Store sanitized blocked contributions in local `UPSTREAM_QUEUE.md`**
- [x] **Step 3: Preserve the queue across reinstall while universal state refreshes**
- [x] **Step 4: Remove queue entries only after branch and draft-PR confirmation**

### Task 6: Update documentation and verification

**Files:**
- Modify: `README.md`
- Modify: `CORE.md`
- Modify: `AGENTS.md`
- Modify: `docs/superpowers/specs/2026-07-14-fire-and-forget-self-improvement-design.md`
- Modify: `tests/verification-report.md`

- [x] **Step 1: Document public/private architecture and upstream PR policy**
- [x] **Step 2: Remove personal seed examples from the final public diff**
- [x] **Step 3: Run structural checks for all required references and templates**
- [x] **Step 4: Run `bash -n install.sh` and repeat isolated shell installs**
- [x] **Step 5: Verify private files and pending queue remain unchanged while universal files refresh**
- [x] **Step 6: Statically verify PowerShell paths and preservation behavior**
- [x] **Step 7: Review the complete PR diff against `main`**
- [ ] **Step 8: Update the draft PR summary with exact evidence and limitations**

## Remaining external gates

- Execute `install.ps1` in a real PowerShell environment.
- Run the skill in a fresh authenticated Codex agent to prove autonomous branch push, queue retry, and draft-PR creation end to end.
- Run pressure scenarios with fresh agents before marking the draft ready for review.
