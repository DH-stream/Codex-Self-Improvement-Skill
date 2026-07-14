# Fire-and-Forget Self-Improvement Implementation Plan

> **Status:** Completed as the initial engine plan. Its original single-memory installation design was superseded by [`2026-07-14-private-memory-upstream-sync-plan.md`](2026-07-14-private-memory-upstream-sync-plan.md).

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:writing-skills` when changing the engine and `superpowers:test-driven-development` when adding executable behavior.

**Goal:** Ship an installable global Codex skill with automatic post-change learning, correction retrospectives, universal work-pattern memory, and durable private user-taste memory.

**Final architecture:** A compact `SKILL.md` routes to detailed procedures. The global `AGENTS.md` hook activates it across repositories. Public universal state, private local state, and the upstream GitHub checkout are separate. Later storage and upstream behavior are defined by the superseding plan.

## Completed phase-one work

- Recorded RED evidence for unbounded work, wrong green tests, and visual regressions.
- Added stable invariants and repository/global routing.
- Added the installable skill with post-change and correction triggers.
- Added reflection, correction, memory-lifecycle, and taste-learning procedures.
- Added compact universal patterns, recurring mistakes, history, and update logging.
- Added idempotent shell and PowerShell installers.
- Added structural and installer verification plus reusable pressure scenarios.

## Superseded decisions

The following original ideas must not be reintroduced:

- user taste stored in the public repository;
- one combined global memory directory;
- repository-backed personal memory;
- fully silent behavior after an actual memory/skill write.

Current behavior instead uses private local taste, public universal memory, persistent upstream retry state, automatic draft PRs, and compact filename/PR notices.
