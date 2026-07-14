---
name: codex-self-improvement
description: Use when technical repository work changes files, when reviewing or correcting earlier implementation, or when explicit or repeated user feedback reveals durable workflow, quality, UX, design, color, copy, interaction, or visual preferences.
---

# Codex Self-Improvement

## Core principle

Improve future work automatically from evidence. Be quiet, bounded, universal, and quality-preserving.

Memory root:

1. use `CODEX_SELF_IMPROVEMENT_HOME` when set;
2. otherwise read `~/.codex/self-improvement/LOCATION` when present;
3. otherwise use `~/.codex/self-improvement/memory`.

Read only relevant sections of `ACTIVE_PATTERNS.md`, `RECURRING_MISTAKES.md`, and—during visual/UX work—`UX_TASTE.md`.

## Automatic trigger

Before technical work, note `HEAD`, changed files, and intended verification.

After every user prompt:

1. Did code, tests, config, scripts, migrations, CI, agent instructions, or skills change?
   - No: stop.
   - Yes: run the bounded post-change procedure.
2. Does this prompt fix, review, or supersede earlier work?
   - Yes: also run the correction retrospective.
3. Is there material universal or user-taste evidence?
   - No: write nothing.
   - Yes: update memory through the schema.
4. Continue the normal user response. Do not announce routine reflection.

**REQUIRED REFERENCES:**
- `references/reflection-procedure.md`
- `references/correction-retrospective.md` for corrections/blockers
- `references/memory-schema.md` for writes
- `references/taste-learning.md` for UX/design feedback

## Consolidate automatically

Consolidate candidates after a commit, completed plan, final verification, strong user correction, or session handoff. Merge duplicates; promote, lower relevance, or supersede automatically. Never delete history.

## Quality firewall

Optimization may change order, scope, checkpoints, and report length. It must never:

- skip required RED/GREEN or final verification;
- treat self-authored green tests as independent proof;
- omit security, race, accessibility, or data-integrity checks;
- review only descriptions when code and base comparison are required;
- hide blockers or overstate completion;
- alter established visual direction during an unrelated functional fix.

## Engine upgrades

Update memory by default. Change this skill or its references only when evidence shows the procedure itself is missing or ambiguous. Add/update a pressure scenario, preserve quality gates, make the change tracked, and record it in `UPDATE_LOG.md`.

## Red flags

Stop and correct the process when reasoning becomes:

- “Run everything again just in case.”
- “The tests are green, so the requirement must be satisfied.”
- “This is only a small style regression.”
- “Reflection can wait until the user asks.”
- “Delete the old rule so it cannot confuse me.”
