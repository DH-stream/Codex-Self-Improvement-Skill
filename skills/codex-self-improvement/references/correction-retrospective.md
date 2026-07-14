# Correction retrospective contract

## Trigger

`current_change_corrects_or_reviews_prior_work = true`

Examples: blocker follow-up, regression repair, stale completion claim, changed expectation, user correction, or later review of the same implementation area.

## Required record

For each related cluster of misses:

```text
miss
root_cause
available_evidence_at_original_time
earliest_cheap_check
preventive_action
memory_scope
```

## Anti-hindsight test

The preventive action must be usable before the eventual bug is known.

Weak result:

```text
Check that navigation works.
Be more careful with async code.
```

Useful result:

```text
After an awaited continuation, reread canonical state and compare the success
path with the stated end-to-end contract; exact identity is required only when
the contract requires it.
```

## Root-cause categories

- requirement not translated into executable invariants;
- incomplete end-to-end path review;
- self-authored test encoded the implementation;
- asynchronous boundary lacked a canonical reread;
- destructive action lacked exact authority;
- exploration scope was wrong;
- verification occurred at the wrong stage;
- established user taste or visual contract was ignored;
- completion claim exceeded evidence.

## Memory action

| Evidence | State change |
|---|---|
| First ordinary incident | candidate |
| One severe or costly incident | provisional, usually medium confidence |
| Independent confirmation | promote confidence/status |
| Contradiction | lower confidence or relevance |
| Better replacement | mark earlier pattern superseded |

The record preserves evidence and preventive behavior, not blame.
