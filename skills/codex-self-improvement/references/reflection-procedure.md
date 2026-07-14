# Post-change reflection contract

## Trigger

`technical_files_changed = true`

Technical files include code, tests, configuration, scripts, migrations, CI, agent instructions, and skills. Ordinary prose documentation is excluded unless it changes technical workflow.

## Inputs

```text
head_before
head_after
changed_files_before
changed_files_after
verification_evidence
```

No extra command is required solely to create reflection evidence.

## Fixed questions

1. What materially changed?
2. Which action produced real evidence?
3. Which repeated action produced no new information?
4. Which smaller or earlier check could preserve the same quality?
5. Which memory class fits: universal pattern, user taste, recurring mistake, engine gap, project fact, or no lesson?

## Classification

| Class | Storage action |
|---|---|
| Project fact | Keep project-local; no global write |
| One-off event | No write |
| Universal candidate | Add or update candidate/provisional pattern |
| User taste | Apply taste-learning contract |
| Recurring mistake | Add evidence and preventive check |
| Engine gap | Create an engine-upgrade candidate |

## Write gate

A memory update requires all of these properties:

- concrete;
- reusable;
- correctly scoped;
- evidence-backed;
- behavior-changing;
- quality-preserving.

Otherwise the result is `no_write`.

## Visibility

Routine result: silent. A normal completion report may mention only material new lessons and must not restate the prompt, plan, or full diff as learning.
