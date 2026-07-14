---
name: codex-self-improvement
description: Use when technical repository work changes files, when reviewing or correcting earlier implementation, or when explicit or repeated user feedback reveals durable workflow, quality, UX, design, color, copy, interaction, or visual preferences.
---

# Codex Self-Improvement

## Core principle

Improve future work automatically from evidence. Be quiet, bounded, quality-preserving, and strict about private versus universal knowledge.

Resolve storage from the files under `~/.codex/self-improvement/`:

- `PRIVATE_LOCATION` — personal taste, private evidence, and private history;
- `UNIVERSAL_LOCATION` — public-compatible active patterns, candidates, mistakes, and history;
- `UPSTREAM_LOCATION` and `UPSTREAM_REPOSITORY` — checkout and repository used for universal draft PRs.

Environment variables with matching names override location files. Read only relevant sections. During visual work, read private `UX_TASTE.md`; never read or publish unrelated private history.

## Automatic trigger

Before technical work, note `HEAD`, changed files, and intended verification.

After every user prompt:

1. Did code, tests, config, scripts, migrations, CI, agent instructions, or skills change?
   - No: stop.
   - Yes: run the bounded post-change procedure.
2. Does this prompt fix, review, or supersede earlier work?
   - Yes: also run the correction retrospective.
3. Classify material evidence:
   - personal preference or private evidence → private memory only;
   - project fact → project-local only;
   - qualified universal improvement → universal memory and upstream contribution;
   - weak or one-off observation → no write.
4. Continue the normal response without narrating the retrospective.

**REQUIRED REFERENCES:**

- `references/reflection-procedure.md`
- `references/correction-retrospective.md` for corrections/blockers
- `references/memory-schema.md` for writes and notices
- `references/taste-learning.md` for UX/design feedback
- `references/upstream-contribution.md` for universal GitHub updates

## Write visibility

Reflection is silent; actual writes are not. After any memory or skill write, add exactly one compact completion line naming changed files. When an upstream draft PR was opened or updated, append its reference.

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
```

Do not explain the lesson unless asked. Emit no notice when no memory or skill file changed.

## Consolidate automatically

Consolidate after a commit, completed plan, final verification, strong correction, or handoff. Merge duplicates; promote, lower relevance, or supersede automatically. Never delete history.

## Quality firewall

Optimization may change order, scope, checkpoints, and report length. It must never:

- skip required RED/GREEN or final verification;
- treat self-authored green tests as independent proof;
- omit security, race, accessibility, or data-integrity checks;
- review only descriptions when code and base comparison are required;
- hide blockers or overstate completion;
- alter established visual direction during an unrelated functional fix;
- expose private memory in public diffs, commits, branches, issues, or PRs.

## Engine and universal upgrades

One qualified universal improvement is enough; batching is not required. Follow the upstream contribution contract to create or update a dedicated branch and draft PR. Never push directly to `main` and never merge automatically.

Change the engine only when evidence shows the procedure is missing or ambiguous. Add or update a pressure scenario, preserve quality gates, verify the change, and record it in the public update log.
