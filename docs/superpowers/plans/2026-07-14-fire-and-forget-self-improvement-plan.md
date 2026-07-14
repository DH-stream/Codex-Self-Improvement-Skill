# Fire-and-Forget Self-Improvement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:writing-skills` when changing the engine and `superpowers:test-driven-development` when adding executable behavior.

**Goal:** Ship an installable global Codex skill with automatic post-change learning, correction retrospectives, universal work-pattern memory, and durable user-taste memory.

**Architecture:** A compact `SKILL.md` routes to detailed procedures. Persistent memory is separate from the installed engine so updates do not overwrite learning. A global `AGENTS.md` hook makes activation automatic across repositories.

## Tasks

### 1. Record RED evidence and pressure scenarios

- Document the observed multi-hour, multi-reset run.
- Document the later blocker review that exposed missed runtime contracts.
- Define pass/fail scenarios for silent triggering, correction learning, taste learning, stale-memory handling, and quality protection.

### 2. Create stable invariants and routing

- Add `CORE.md`.
- Add repository `AGENTS.md`.
- Keep the global activation snippet short and explicit.

### 3. Create the installable skill

- Add frontmatter with trigger-only description.
- Implement observable post-change triggering.
- Route ordinary and correction retrospectives.
- Keep routine output silent.
- Protect quality gates.

### 4. Add supporting procedures

- Define reflection algorithm.
- Define correction retrospective.
- Define memory schema and lifecycle.
- Define taste-learning evidence and conflict rules.

### 5. Seed memory

- Add compact active patterns.
- Add candidates, history, recurring mistakes, and update log.
- Seed only explicit, durable UX/taste preferences.
- Keep project facts out of global memory.

### 6. Add idempotent installers

- Install/update engine files.
- Seed memory only when files are absent.
- Append the global activation hook once.
- Support optional repository-backed memory.

### 7. Verify

- Check SKILL frontmatter and word count.
- Check every referenced file exists.
- Run installer dry-run/manual review on Windows and shell.
- Run pressure scenarios with and without the skill when subagents are available.
- Record any engine change in `memory/UPDATE_LOG.md`.
