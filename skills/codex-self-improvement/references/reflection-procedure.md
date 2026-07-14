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
5. Which memory class fits: universal pattern, user taste/private evidence, recurring mistake, engine gap, project fact, or no lesson?

## Classification

| Class | Storage action |
|---|---|
| Project fact | Keep project-local; no global write |
| One-off event | No write |
| Private observation | Write only under `PRIVATE_LOCATION` when durable |
| User taste | Apply the private taste-learning contract |
| Universal candidate/pattern | Write public-safe data under `UNIVERSAL_LOCATION` and apply upstream contribution |
| Recurring universal mistake | Add public-safe evidence and a preventive check |
| Engine gap | Create a public-safe engine upgrade with a pressure scenario |

## Write gate

A memory update requires all of these properties:

- concrete;
- reusable;
- correctly scoped;
- evidence-backed;
- behavior-changing;
- quality-preserving.

A universal write additionally requires:

- applicability across repositories or technologies;
- safe anonymization without losing the action;
- no personal, proprietary, secret, or project-specific dependency.

Otherwise the result is `no_write` or private-only storage.

## Upstream threshold

One qualified universal improvement is enough to propose upstream. Do not wait for batching. Store it as provisional when confidence is not yet confirmed, then follow `upstream-contribution.md`.

## Visibility

Routine reasoning remains silent.

When no memory or skill file changed, emit no self-improvement notice.

When files changed, use one compact notice from `memory-schema.md` naming only the changed file(s) and any upstream draft PR. Do not explain the lesson unless asked.
