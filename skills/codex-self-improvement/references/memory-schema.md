# Memory schema and lifecycle

## Storage roots

### Private root

The path in `PRIVATE_LOCATION` is local-only and never committed or pushed.

- `UX_TASTE.md` — active user preferences.
- `UX_TASTE_HISTORY.md` — taste evidence, conflicts, and superseded preferences.
- `CANDIDATES.md` — private observations not eligible for public storage.
- `UPSTREAM_QUEUE.md` — sanitized universal contributions waiting for upstream access.
- `UPDATE_LOG.md` — concise private-memory changes.

`UPSTREAM_QUEUE.md` is operational local state, not taste memory. Its entries must already satisfy the public privacy gate and survive reinstall until a branch and draft PR exist.

### Universal root

The path in `UNIVERSAL_LOCATION` contains only public-compatible knowledge already sourced from or ready to mirror the public repository.

- `ACTIVE_PATTERNS.md` — compact universal patterns used during work.
- `CANDIDATES.md` — universal hypotheses represented in the public repository.
- `PATTERN_HISTORY.md` — immutable public-compatible evidence and state history.
- `RECURRING_MISTAKES.md` — general failure modes and preventive checks.
- `UPDATE_LOG.md` — concise universal changes.

Project facts stay in project documentation. They belong in neither root unless generalized into an evidence-backed universal action.

## Universal pattern record

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
public_safe: true
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

Public evidence describes the observable failure and preventive action without names, private paths, proprietary code, credentials, personal preferences, or unnecessary repository details.

## State rules

- `candidate`: plausible but weak or not independently confirmed.
- `provisional`: one strong, evidence-backed universal incident or explicit correction.
- `confirmed`: two independent observations, or durable instruction plus successful application.
- `low-relevance`: historically valid but currently uncommon or stale.
- `superseded`: a newer pattern expresses the behavior better.

One qualified universal improvement may be proposed upstream as `provisional`; batching is not required. Independence controls confidence and promotion, not whether a safe draft PR may exist.

Evidence is independent when it comes from another task, repository, or meaningfully different failure—not another sentence in the same review.

## Update algorithm

1. Classify the destination: private, universal, project-local, or no write.
2. Search only the destination root for overlap.
3. Append evidence without rewriting original evidence.
4. Recompute status, confidence, relevance, and `last_reviewed`.
5. Keep active files compact.
6. Copy state transitions to the matching history.
7. Add one short update-log line.
8. Never delete a record.
9. For a qualified universal change, apply `upstream-contribution.md`.
10. If upstream access fails, write the sanitized contribution to private `UPSTREAM_QUEUE.md`, not the refreshable universal cache.
11. Remove a queued entry only after its branch and draft PR are confirmed; preserve the resulting public history.

Conflict priority:

1. newest explicit user evidence within matching private scope;
2. confirmed high-confidence evidence;
3. provisional evidence;
4. inference.

Every conflict remains visible in the correct history.

## Privacy gate

A universal write or queue entry is forbidden when it contains or depends on:

- personal taste or identity;
- family, health, employment, financial, location, or account details;
- private repository names, private URLs, local filesystem paths, secrets, or credentials;
- proprietary code or business rules;
- evidence that cannot be safely generalized without losing its actionable meaning.

When uncertain, keep the observation as an ordinary private candidate and do not create an upstream branch or queue entry.

## Notice contract

After one or more actual memory/skill writes, include one compact line in the normal completion response:

```text
Self-improvement updated: `FILE_A.md`, `FILE_B.md`.
Self-improvement updated: `FILE_A.md`; draft PR #N opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

Requirements:

- name every changed memory/skill file;
- include the draft PR reference when applicable;
- do not summarize the lesson unless asked;
- do not emit a notice for unchanged files or reflection-only work.
