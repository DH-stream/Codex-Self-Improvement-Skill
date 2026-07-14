# Private Memory and Upstream Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep personal learning private and local while automatically proposing each qualified universal improvement to the public GitHub repository through a verified draft PR, with a token-bounded filename-only notice.

**Architecture:** The installed engine reads two roots: a private local root for user taste/private evidence and a universal root sourced from the public repository. A dedicated upstream contribution contract classifies, sanitizes, branches, verifies, pushes, and opens draft PRs. One qualified universal improvement is sufficient; main is never pushed or merged automatically.

**Tech Stack:** Markdown Agent Skill, Git, GitHub CLI contract, Bash installer, PowerShell installer.

## Global Constraints

- Personal taste, private evidence, project facts, local paths, and sensitive data never enter the public repository.
- One qualified universal improvement may open a draft PR; batching is not required.
- Every public engine change includes a relevant pressure scenario and verification evidence.
- No direct push to `main` and no automatic merge.
- After a memory or skill write, the user-visible notice names changed files and any draft PR only; it does not explain the lesson unless asked.
- Existing private memory is never overwritten on reinstall or upstream sync.
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
- Create: `memory/private-template/UX_TASTE.md`
- Create: `memory/private-template/UX_TASTE_HISTORY.md`
- Create: `memory/private-template/CANDIDATES.md`
- Create: `memory/private-template/UPDATE_LOG.md`
- Delete: `memory/UX_TASTE.md`
- Delete: `memory/UX_TASTE_HISTORY.md`

- [ ] **Step 1: Define `PRIVATE_LOCATION` and `UNIVERSAL_LOCATION` resolution**
- [ ] **Step 2: Route user taste and private evidence only to private storage**
- [ ] **Step 3: Keep universal patterns and engine evidence public-compatible**
- [ ] **Step 4: Replace public personal seeds with neutral private templates**
- [ ] **Step 5: Require a compact filename-only update notice after actual writes**

### Task 3: Add automatic upstream contribution contract

**Files:**
- Create: `skills/codex-self-improvement/references/upstream-contribution.md`
- Modify: `skills/codex-self-improvement/SKILL.md`
- Modify: `install/AGENTS-snippet.md`

- [ ] **Step 1: Define the universal qualification and privacy gate**
- [ ] **Step 2: Define dedicated branch creation from current upstream `main`**
- [ ] **Step 3: Require relevant pressure scenario and fresh verification**
- [ ] **Step 4: Push and create/update a draft PR without direct main writes**
- [ ] **Step 5: Make one qualified improvement sufficient**
- [ ] **Step 6: Define compact completion notice with filename(s) and PR reference**

### Task 4: Update installers for separated state

**Files:**
- Modify: `install.sh`
- Modify: `install.ps1`

- [ ] **Step 1: Install engine files normally**
- [ ] **Step 2: refresh universal memory from repository on reinstall**
- [ ] **Step 3: seed private templates only when missing**
- [ ] **Step 4: write `PRIVATE_LOCATION`, `UNIVERSAL_LOCATION`, `UPSTREAM_LOCATION`, and `UPSTREAM_REPOSITORY`**
- [ ] **Step 5: preserve existing private memory across repeated installs**

### Task 5: Update documentation and verification

**Files:**
- Modify: `README.md`
- Modify: `CORE.md`
- Modify: `docs/superpowers/specs/2026-07-14-fire-and-forget-self-improvement-design.md`
- Modify: `tests/verification-report.md`

- [ ] **Step 1: Document public/private architecture and upstream PR policy**
- [ ] **Step 2: Remove personal seed examples from public documentation**
- [ ] **Step 3: Run structural checks for all required references and templates**
- [ ] **Step 4: run `bash -n install.sh` and repeat isolated shell installs**
- [ ] **Step 5: verify private files remain unchanged and universal files refresh**
- [ ] **Step 6: statically verify PowerShell paths and preservation behavior**
- [ ] **Step 7: update the draft PR summary with exact evidence and limitations**
