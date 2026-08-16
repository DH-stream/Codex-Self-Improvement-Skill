# Update log

## 2026-08-16

- Replaced blocking/delegated multi-task orchestration with a main-agent inline implementation model.
- Added independent review subagents for each completed logical snapshot without blocking later safe implementation work.
- Added separate isolated fixer subagents for actionable review findings; reviewers never fix their own findings.
- Kept dependency/write-conflict analysis and made the main agent the final integration reviewer against current `main` after all background pipelines return.
- Added anonymized RED evidence and a pressure scenario for the non-blocking review/fix pipeline.

## 2026-07-14

- Created the fire-and-forget technical-change trigger.
- Added correction retrospectives for blocker and repair follow-ups.
- Added a no-deletion memory lifecycle with relevance and supersession.
- Seeded universal work patterns and recurring mistakes.
- Added scoped private UX, design, color, interaction, and image taste learning.
- Split private local state from public universal state.
- Removed learned user taste from the public repository and added neutral private templates.
- Added one-improvement upstream draft-PR proposals.
- Added filename-and-PR-only notices after actual memory or skill writes.
- Updated installers to preserve private state while refreshing engine and universal state.
- Added persistent `UPSTREAM_QUEUE.md` state for blocked upstream proposals.
- Separated durable feedback handling from the technical file-change gate.
- Defined installed universal memory as a read-only snapshot of upstream `main`.
- Added stable proposal IDs, deterministic branches, bounded retries, and duplicate prevention.
- Added installer preflight, staged replacement, complete snapshot refresh, and a Python-free shell path.
- Added executable shell installer regression coverage with observed failing and passing runs.
- Made single-agent inline execution the default and limited subagents to justified parallel or specialist work.
- Added safe streamed one-line installers backed by persistent validated checkouts.
- Added a friendly README landing page and reusable learning-bot brand kit.
