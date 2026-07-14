# Universal upstream contribution contract

## Entry condition

A single evidence-backed improvement may enter this flow when it is useful across repositories and remains actionable after private and project-specific details are removed. Unconfirmed improvements use `provisional` status; batching is not required.

## Storage boundary

| Information | Destination |
|---|---|
| Personal taste or private evidence | Private local memory only |
| Project fact or business rule | Project documentation only |
| Public-safe universal proposal | Isolated upstream branch and draft PR |
| Engine or schema defect | Isolated upstream branch and draft PR |
| Sanitized proposal blocked by upstream access | Private `UPSTREAM_QUEUE.md` |
| Installed universal knowledge | Read-only `UNIVERSAL_LOCATION` snapshot |

Files under `PRIVATE_LOCATION` are outside the public contribution surface. Public changes and queue entries exclude identities, personal facts, local paths, credentials, proprietary code, private repository identifiers, and unnecessary source-project detail.

Never author a proposal only in `UNIVERSAL_LOCATION`; reinstall may replace that snapshot from upstream `main`.

## Repository resolution

`UPSTREAM_LOCATION` identifies the local checkout. `UPSTREAM_REPOSITORY` identifies the configured GitHub repository. Environment variables named exactly `UPSTREAM_LOCATION` and `UPSTREAM_REPOSITORY` override location files.

Before contribution work, fetch the configured remote and resolve current remote `main`. An unavailable checkout may be recreated from the configured repository. Authentication or network failure updates the already-sanitized record in private `UPSTREAM_QUEUE.md`; it never changes the default branch.

## Stable identity and discovery

Derive `contribution_id` from the normalized universal action plus a short content hash. Use the deterministic branch:

```text
codex/self-improvement/<contribution_id>
```

Before creating a branch:

1. search active queue records by `contribution_id` and `content_hash`;
2. search remote branches for the deterministic branch;
3. search open draft PRs for the ID/branch;
4. reuse matching state instead of creating a duplicate.

If a branch exists but PR creation previously failed, continue from that branch. If a draft PR exists, update it only when the new evidence belongs to the same improvement.

## Isolation and branch policy

- Base new contributions on current remote upstream `main`, not stale local `main`.
- Use an isolated worktree for every contribution. Do not edit the configured checkout or the user's current project working tree.
- Refuse contribution work when the isolated base cannot be proven or unrelated changes appear in the worktree.
- Direct writes to `main`, automatic merge, automatic approval, and automatic ready-for-review transitions are forbidden.
- One qualified improvement is enough to create the draft PR.

## Required change set

Every contribution contains the smallest complete combination of:

1. structural RED evidence or a relevant pressure scenario;
2. the universal pattern, procedure, schema, installer, or engine change;
3. fresh verification available in the environment;
4. a complete diff and privacy review against remote upstream `main`;
5. a concise public update-log entry.

Behavioral checks that cannot run remain explicit draft-PR limitations. They are not presented as passed.

## Public file routing

| Improvement type | Typical files |
|---|---|
| Universal workflow pattern | `memory/ACTIVE_PATTERNS.md`, `memory/CANDIDATES.md`, `memory/PATTERN_HISTORY.md` |
| Universal recurring failure | `memory/RECURRING_MISTAKES.md` |
| Engine/procedure gap | `skills/codex-self-improvement/SKILL.md`, `skills/codex-self-improvement/references/*` |
| Behavioral protection | `tests/pressure-scenarios.md`, baseline and verification reports |
| Installation/schema change | installers, memory schema, README, design documents |

Private templates may change only as neutral schemas. Learned user data never belongs in them.

## Queue lifecycle

Queue records follow `memory-schema.md` and retain stable ID, content hash, branch, base SHA, status, attempts, last error class, and PR URL.

- Inspect active queue entries once at session start or a natural consolidation point.
- Retry each active entry at most once per session unless the user explicitly requests another attempt.
- Do not rerun expensive verification unless relevant files, the proposal, or remote `main` changed.
- Transition `pending → branch-pushed → pr-open`; do not delete successful records.
- Mark obsolete records `superseded` and link the replacement ID.
- Never move ordinary private observations into the queue.

## Draft PR record

The draft PR states the contribution ID, summary, anonymized evidence, scope and quality guardrails, RED/pressure scenario, verification and limitations, privacy-review result, and provisional/confirmed status.

The draft remains unmerged for human review. Do not claim it exists until the API or CLI returns its number or URL.

## Completion notice

```text
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

Name changed memory/skill files and the PR reference only. Omit the lesson unless requested.