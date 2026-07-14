# Memory schema and lifecycle

## Storage files

- `ACTIVE_PATTERNS.md` — compact patterns used during work.
- `CANDIDATES.md` — unconfirmed hypotheses.
- `PATTERN_HISTORY.md` — immutable evidence and state history.
- `RECURRING_MISTAKES.md` — repeated failure modes and checks.
- `UX_TASTE.md` — active user preferences.
- `UX_TASTE_HISTORY.md` — taste evidence, conflicts, and superseded preferences.
- `UPDATE_LOG.md` — concise material changes.

## Pattern record

```yaml
id: category-NNN
title: concise action
status: candidate | provisional | confirmed | low-relevance | superseded
confidence: low | medium | high
relevance: low | medium | high
category: planning | exploration | implementation | testing | review | reporting
first_observed: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
independent_evidence_count: 1
superseded_by: null
```

Required text fields:

```text
Observation
Universal lesson
Use when
Action
Never
Evidence
Contradicting evidence
Relevance history
```

## State rules

- `candidate`: plausible but weak or not independent.
- `provisional`: one strong incident or clear explicit correction.
- `confirmed`: two independent observations, or durable explicit instruction plus successful application.
- `low-relevance`: historically valid but currently uncommon or stale.
- `superseded`: a newer pattern expresses the behavior better.

Evidence is independent when it comes from another task, repository, or meaningfully different failure—not another sentence in the same review.

## Update algorithm

1. Search IDs and titles for overlap.
2. Append evidence without rewriting original evidence.
3. Recompute status, confidence, relevance, and `last_reviewed`.
4. Keep active files compact.
5. Copy state transitions to history.
6. Add one short update-log line.
7. Never delete a record.

Conflict priority:

1. newest explicit user evidence within matching scope;
2. confirmed high-confidence evidence;
3. provisional evidence;
4. inference.

Every conflict remains visible in history.
