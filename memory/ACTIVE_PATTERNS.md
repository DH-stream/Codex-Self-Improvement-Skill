# Active universal work patterns

Read only categories relevant to the current work.

## Index

- Planning/execution: `execution-001`, `execution-002`, `execution-003`
- Testing/verification: `verification-001`
- Review: `review-001`
- UI implementation: `ux-implementation-001`

## execution-001 — Use independently reviewable checkpoints

- Status: provisional
- Confidence: medium
- Relevance: high
- Use when: a run contains multiple separable implementation stages.
- Action: finish, focus-test, commit, and preserve a review boundary before expanding scope.
- Never: replace final integration verification with isolated checkpoints.
- Evidence: one multi-hour run consumed two usage resets before review.

## execution-002 — Default to one primary agent when parallel width is absent

- Status: confirmed
- Confidence: high
- Relevance: high
- Use when: executing a plan or multi-step repository change whose ready work is coupled, overlapping, too small, or exploratory.
- Action: keep one primary agent working inline through natural verified checkpoints; dispatch targeted specialist review only when its expected benefit exceeds coordination cost.
- Never: create one worker and one reviewer for every routine task by default.
- Evidence: durable explicit user correction after repeated subagent-per-task workflows added substantial latency.
- Later assessment (2026-07-18): this pattern does not justify serializing independent task domains; `execution-003` governs plans with safe parallel width.

## execution-003 — Review topology, then run safe parallel waves

- Status: confirmed
- Confidence: high
- Relevance: high
- Use when: an implementation plan has two or more tasks and some work may be independent.
- Action: build a dependency/file-ownership/shared-state graph first; dispatch ready disjoint tasks concurrently in isolated worktrees under one integration owner; integrate in dependency order and test each combined wave.
- Never: infer dependencies from task numbering, share one write worktree, race shared files, or treat isolated green tasks as integrated proof.
- Evidence: durable explicit correction after a numbered plan with independent domains was executed strictly sequentially without topology review.

## verification-001 — Verify the requirement, not only the new test

- Status: provisional
- Confidence: medium
- Relevance: high
- Use when: implementation and regression tests are authored together.
- Action: compare each expectation with the stated end-to-end contract and inspect the complete affected path.
- Never: call self-authored green tests independent proof.
- Evidence: lifecycle tests encoded frozen-identity behavior that contradicted intended forward progress.

## review-001 — Review actual code against its base

- Status: confirmed
- Confidence: high
- Relevance: high
- Use when: reviewing a PR or follow-up implementation.
- Action: inspect actual changed code, relevant complete files, and comparison with the target/base branch.
- Never: review only the PR description, generated report, or latest commit.
- Evidence: durable explicit user instruction.

## ux-implementation-001 — Preserve established visuals during functional fixes

- Status: confirmed
- Confidence: high
- Relevance: high
- Use when: requested work is functional and the existing visual direction is accepted.
- Action: preserve layout, styling, color, and interaction polish unless redesign is explicitly requested.
- Never: replace a polished UI with a visually regressed but technically working version.
- Evidence: repeated explicit corrections across UI work.
