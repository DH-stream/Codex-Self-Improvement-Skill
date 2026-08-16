---
name: codex-self-improvement
description: Use when technical repository work changes files, when executing multi-step repository plans, when reviewing or correcting earlier implementation, or when explicit or repeated user feedback reveals durable workflow, quality, UX, design, color, copy, interaction, or visual preferences.
---

# Codex Self-Improvement

## Core principle

Improve future work automatically from evidence. Stay bounded, quality-preserving, and strict about private versus universal knowledge.

Resolve storage from `~/.codex/self-improvement/`:

- `PRIVATE_LOCATION` — writable personal taste, private evidence, history, and upstream queue;
- `UNIVERSAL_LOCATION` — read-only installed snapshot of public upstream `main`;
- `UPSTREAM_LOCATION` and `UPSTREAM_REPOSITORY` — checkout and repository used for universal draft PRs.

Environment variables named for those keys may override location files. Read only relevant sections. During visual work, read private `UX_TASTE.md`; never publish unrelated private history.

## Automatic trigger

Before technical work, note `HEAD`, changed files, and intended verification. Retry pending `UPSTREAM_QUEUE.md` entries at most once per session or natural consolidation point when upstream access is available. Before executing a plan with two or more tasks, run the plan-execution gate below.

After every user prompt:

1. Evaluate durable explicit feedback and correction/review signals first, even when no file changed.
   - Taste or personal preference → private taste contract.
   - Review, blocker, or correction → correction retrospective.
2. Did code, tests, config, scripts, migrations, CI, agent instructions, or skills change?
   - Yes → run the bounded post-change procedure.
   - No → skip technical efficiency reflection only; do not discard feedback from step 1.
3. Classify material evidence:
   - private evidence → private memory only;
   - project fact → project-local only;
   - qualified universal improvement → dedicated upstream branch/draft PR;
   - blocked universal contribution → private `UPSTREAM_QUEUE.md`;
   - weak or one-off observation → no write.
4. Continue the normal response without narrating the retrospective.

`UNIVERSAL_LOCATION` is never a second writable source. Universal changes are authored in the upstream worktree and enter the installed snapshot only through a later sync/install.

## Plan-execution gate

For every multi-task implementation plan, read `references/parallel-plan-execution.md` before dispatching workers.

1. Review dependencies, produced interfaces, exact file ownership, shared mutable state, and specialist risk.
2. Keep the primary implementation in the main agent inline. Task numbering alone is not a dependency; continue to the next safe task as soon as the current logical part is committed.
3. For every completed logical part, launch an independent review subagent against that exact snapshot while the main agent continues implementing later independent work. Reviews inspect actual code/diffs and do not edit.
4. If a review returns actionable findings, launch a separate fix subagent for that review. The reviewer never fixes its own findings. Keep fix work isolated and non-blocking unless it directly conflicts with or is required by the main agent's next work.
5. The main agent remains the integration owner. Integrate returned fixes deliberately, resolve overlaps, and keep later work rebased on the authoritative branch state.
6. Parallel review/fix pipelines may overlap across completed parts when their scopes are independent. Never let multiple write agents race the same files or shared state.
7. After implementation plus all review/fix work completes, the main agent reviews the entire final branch itself against current `main`, inspects all subagent changes, and runs fresh integrated verification.

Proceed automatically after the compact execution map unless there is a real plan contradiction, security-sensitive installation, destructive action, missing authority, or required asset/user approval.

**REQUIRED REFERENCES:**

- `references/parallel-plan-execution.md` for multi-task plans
- `references/reflection-procedure.md`
- `references/correction-retrospective.md` for corrections/blockers
- `references/memory-schema.md` for writes and notices
- `references/taste-learning.md` for UX/design feedback
- `references/upstream-contribution.md` for universal GitHub updates

## Write visibility

Reflection is silent; actual writes are not. After memory or skill writes, add one compact line naming changed files and any confirmed draft PR. Do not explain the lesson unless asked. Emit no notice when nothing changed.

## Consolidate automatically

Consolidate after a commit, completed plan, final verification, strong correction, or handoff. Merge duplicates; promote, lower relevance, or supersede automatically. Preserve history.

## Quality firewall

Never optimize by skipping required RED/GREEN or final verification, treating self-authored tests as independent proof, omitting security/accessibility/data-integrity checks, reviewing only descriptions, hiding blockers, regressing accepted visuals, exposing private memory publicly, letting reviewers fix their own findings, blocking independent main-agent work on background reviews, sharing one write worktree between concurrent writers, dispatching conflicting fixes concurrently, or calling isolated green tasks integrated proof.

## Engine and universal upgrades

One qualified universal improvement is enough. Follow the upstream contract; never push directly to `main`, merge automatically, or create duplicate branches/PRs for the same contribution. Engine changes require a pressure scenario, fresh verification, privacy review, and public update-log entry.
