# Universal upstream contribution queue

Neutral template for local persistent state. The active copy lives under `PRIVATE_LOCATION` and is never committed or pushed.

Store only sanitized, public-compatible improvements blocked before draft-PR confirmation. Exclude personal taste, private evidence, project identifiers, proprietary code, local paths, and credentials.

## Active index

List only records with `status: pending` or `status: branch-pushed`.

## Record format

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
superseded_by: null
```

Required sections:

```text
Sanitized improvement
Quality guardrails
Verification completed
Remaining work
```

Derive the same ID and branch for the same normalized proposal. Retry active entries at most once per session or natural consolidation point. Reuse an existing remote branch or draft PR. After confirmation, mark `status: pr-open` and record `pr_url`; preserve the record instead of deleting it.

This public template contains no pending contributions.