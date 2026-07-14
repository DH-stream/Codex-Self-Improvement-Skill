# Memory schema and lifecycle

## Storage roots

### Private root

The path in `PRIVATE_LOCATION` is local-only and never committed or pushed.

- `UX_TASTE.md` — active user preferences.
- `UX_TASTE_HISTORY.md` — taste evidence, conflicts, and superseded preferences.
- `CANDIDATES.md` — private observations not eligible for public storage.
- `UPSTREAM_QUEUE.md` — sanitized universal contributions waiting for or recording upstream delivery.
- `UPDATE_LOG.md` — concise private-memory changes.

`UPSTREAM_QUEUE.md` is operational local state, not taste memory. Entries must already satisfy the public privacy gate and survive reinstall.

### Universal snapshot

`UNIVERSAL_LOCATION` is a read-only installed snapshot copied from public upstream `main`.

- `ACTIVE_PATTERNS.md` — compact universal patterns used during work.
- `CANDIDATES.md` — hypotheses already represented in the public repository.
- `PATTERN_HISTORY.md` — public evidence and state history.
- `RECURRING_MISTAKES.md` — general failure modes and preventive checks.
- `UPDATE_LOG.md` — public universal changes.

Use the snapshot for lookup and deduplication only. Do not write proposals into it. Universal changes are authored in an isolated checkout under `UPSTREAM_LOCATION` and reach the snapshot only through a later repository sync/install.

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

Required sections: `Observation`, `Universal lesson`, `Use when`, `Action`, `Never`, `Evidence`, `Contradicting evidence`, and `Relevance history`.

Public evidence describes the observable failure and preventive action without names, private paths, proprietary code, credentials, personal preferences, or unnecessary repository details.

## Queue record

Every queued contribution uses one stable identity:

```yaml
contribution_id: universal-<normalized-slug>-<short-content-hash>
status: pending | branch-pushed | pr-open | superseded
created_at: ISO-8601
updated_at: ISO-8601
base_sha: upstream-main-sha
branch: codex/self-improvement/<contribution_id>
intended_public_files: []
content_hash: sha256-of-sanitized-proposal
attempt_count: 0
last_attempt_at: null
last_error_class: null
pr_url: null
public_safe: true
```

Required sections: `Sanitized improvement`, `Quality guardrails`, `Verification completed`, and `Remaining work`.

The same normalized improvement must produce the same `contribution_id` and branch. Before creating anything, search the queue, remote branches, and open draft PRs by ID.

## State rules

- `candidate`: plausible but weak or not independently confirmed.
- `provisional`: one strong, evidence-backed universal incident or explicit correction.
- `confirmed`: two independent observations, or durable instruction plus successful application.
- `low-relevance`: historically valid but currently uncommon or stale.
- `superseded`: a newer pattern expresses the behavior better.

One qualified universal improvement may be proposed upstream as `provisional`; batching is not required. Independence controls confidence and promotion, not draft-PR eligibility.

Evidence is independent when it comes from another task, repository, or meaningfully different failure—not another sentence in the same review.

## Update algorithm

1. Classify the destination: private, upstream contribution, project-local, or no write.
2. Search private memory and the read-only universal snapshot for overlap.
3. For private learning, append evidence without rewriting original evidence.
4. Recompute status, confidence, relevance, and `last_reviewed`.
5. Keep active files compact and preserve transitions in history.
6. For a qualified universal change, apply `upstream-contribution.md` in an isolated upstream worktree.
7. Never modify `UNIVERSAL_LOCATION` as part of proposing a change.
8. If upstream access fails, write/update the stable record in private `UPSTREAM_QUEUE.md`.
9. Retry an active queue record at most once per session or natural consolidation point unless explicitly requested.
10. When the draft PR is confirmed, set `status: pr-open` and record `pr_url`; preserve the record rather than deleting it.

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

After actual memory/skill writes, include one compact line:

```text
Self-improvement updated: `FILE_A.md`, `FILE_B.md`.
Self-improvement updated: `FILE_A.md`; draft PR #N opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

Name every changed memory/skill file, include a confirmed PR reference when applicable, omit the lesson unless asked, and emit no notice for unchanged files or reflection-only work.