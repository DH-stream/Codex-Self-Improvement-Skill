# Active universal work patterns

Read only categories relevant to the current work.

## Index

- Planning/execution: `execution-001`
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
