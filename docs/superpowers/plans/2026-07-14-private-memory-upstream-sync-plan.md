# Private Memory and Upstream Sync Implementation Plan

> **Status:** Implemented on draft PR #1. Remaining external gates are listed at the end.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Keep personal learning private and local while proposing each qualified universal improvement to the public GitHub repository through a verified draft PR, with a token-bounded filename-only notice.

**Final architecture:** Private taste/evidence is writable local state. The installed universal directory is a read-only snapshot of public upstream `main`. Universal proposals use stable IDs and deterministic isolated branches. Blocked delivery waits in persistent `UPSTREAM_QUEUE.md` and retries idempotently.

**Tech Stack:** Markdown Agent Skill, Git/GitHub contribution contract, Bash installer, PowerShell installer.

## Global Constraints

- Personal taste, private evidence, project facts, local paths, and sensitive data never enter the public repository.
- One qualified universal improvement may open a draft PR; batching is not required.
- Every public engine change includes relevant RED/pressure evidence and verification.
- No direct push to `main`, automatic merge, approval, or automatic ready-for-review transition.
- Actual writes produce only a filename/PR notice unless the lesson is requested.
- Existing private memory and upstream queue history are preserved across reinstall.
- Quality, TDD, review, security, accessibility, and final verification are never weakened.

---

### Task 1: Add behavioral RED coverage

- [x] Add private/public separation scenario.
- [x] Add one-improvement draft-PR scenario.
- [x] Add compact filename-only notification scenario.
- [x] Record initial missing behavior in baseline RED evidence.

### Task 2: Split private and universal storage

- [x] Define `PRIVATE_LOCATION` and `UNIVERSAL_LOCATION`.
- [x] Route user taste and private evidence only to private storage.
- [x] Keep public repository files universal and anonymized.
- [x] Replace public personal seeds with neutral private templates.
- [x] Require a compact notice after actual writes.

### Task 3: Add automatic upstream contribution contract

- [x] Define universal qualification and privacy gates.
- [x] Require a dedicated branch and draft PR.
- [x] Require relevant pressure evidence and fresh verification.
- [x] Prevent direct main writes and automatic merge.
- [x] Make one qualified improvement sufficient.

### Task 4: Install separated state

- [x] Install engine files.
- [x] Refresh the universal snapshot from the repository.
- [x] Seed private templates only when missing.
- [x] Write private, universal, checkout, and repository locations.
- [x] Preserve private memory across repeated installs.

### Task 5: Add persistent retry state

- [x] Add RED evidence for pending work lost during universal refresh.
- [x] Store sanitized blocked proposals in local `UPSTREAM_QUEUE.md`.
- [x] Preserve the queue across reinstall.
- [x] Record successful delivery as `status: pr-open` with the PR URL rather than deleting history.

### Task 6: Initial documentation and verification

- [x] Document public/private architecture and upstream policy.
- [x] Remove personal seed examples from the final public diff.
- [x] Check required references/templates.
- [x] Exercise repeated isolated shell installs.
- [x] Verify private preservation and universal refresh.
- [x] Statically inspect PowerShell behavior.
- [x] Review the complete PR diff against `main`.

### Task 7: Second-review contract hardening

- [x] Add RED scenarios for feedback-only prompts, competing universal sources, and non-idempotent retry.
- [x] Evaluate explicit durable feedback and correction signals before the technical file-change gate.
- [x] Make `UNIVERSAL_LOCATION` read-only and author proposals only in isolated upstream branches.
- [x] Add stable contribution IDs, deterministic branches, machine-scannable queue states, and bounded retries.
- [x] Require current remote `main`, duplicate discovery, and existing branch/PR reuse.

### Task 8: Installer safety and executable verification

- [x] Write executable tests and observe three RED failures in the previous shell installer.
- [x] Preflight all required sources and activation markers before changing active files.
- [x] Stage complete skill, universal, and AGENTS replacements.
- [x] Remove the shell installer's undeclared Python dependency.
- [x] Replace the universal snapshot completely so stale nested paths disappear.
- [x] Preserve private queue/taste across reinstall and maintain one activation block.
- [x] Run the final five-test shell suite GREEN.
- [x] Implement matching PowerShell staging/preflight/rollback behavior.

### Task 9: Final review and evidence refresh

- [x] Recount skill/reference/scenario structure.
- [x] Run fresh shell syntax and executable installer tests.
- [x] Run static PowerShell checks on the final script.
- [x] Review the complete final diff against current `main` for behavior and privacy.
- [x] Refresh `tests/verification-report.md` and the draft PR body.
- [x] Confirm PR remains draft and unmerged.

## Remaining external gates

- Execute `install.ps1` in a real Windows PowerShell environment.
- Run the skill in a fresh authenticated Codex agent to prove branch push, queue retry, and draft-PR creation end to end.
- Run pressure scenarios with fresh agents before marking the draft ready for review.