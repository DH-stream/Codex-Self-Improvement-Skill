# Universal upstream contribution contract

## Entry condition

A single evidence-backed improvement may enter this flow when it is useful across repositories and remains actionable after private and project-specific details are removed. Unconfirmed improvements use `provisional` status; batching is not required.

## Storage boundary

| Information | Destination |
|---|---|
| Personal taste or private evidence | Private local memory only |
| Project fact or business rule | Project documentation only |
| Public-safe universal pattern | Universal memory and upstream draft PR |
| Engine or schema defect | Skill repository draft PR |

Files under `PRIVATE_LOCATION` are outside the public contribution surface. Public changes exclude identities, personal facts, local paths, credentials, proprietary code, private repository identifiers, and unnecessary source-project detail.

## Repository resolution

`UPSTREAM_LOCATION` identifies the local checkout. `UPSTREAM_REPOSITORY` identifies the configured GitHub repository. Matching environment variables take precedence over location files.

An unavailable checkout may be recreated from the configured repository. Authentication or network failure leaves the sanitized observation in universal `CANDIDATES.md`; it does not change the default branch.

## Branch and PR policy

- Base every contribution on current upstream `main`.
- Use one dedicated branch per improvement, named `codex/self-improvement/<timestamp>-<slug>`.
- Prefer an isolated git worktree so unrelated repositories and working trees remain untouched.
- When the same improvement is already on an open draft branch, update it instead of creating a duplicate.
- Direct writes to `main`, automatic merge, automatic approval, and automatic ready-for-review transitions are forbidden.
- One qualified improvement is enough to create the draft PR.

## Required change set

Every contribution contains the smallest complete combination of:

1. structural RED evidence or a relevant pressure scenario;
2. the universal pattern, procedure, schema, installer, or engine change;
3. fresh verification evidence available in the environment;
4. a complete diff privacy review against upstream `main`;
5. a concise public update-log entry.

Behavioral checks that cannot run remain an explicit draft-PR limitation. They are not silently presented as passed.

## Public file routing

| Improvement type | Typical files |
|---|---|
| Universal workflow pattern | `memory/ACTIVE_PATTERNS.md`, `memory/CANDIDATES.md`, `memory/PATTERN_HISTORY.md` |
| Universal recurring failure | `memory/RECURRING_MISTAKES.md` |
| Engine/procedure gap | `skills/codex-self-improvement/SKILL.md`, `skills/codex-self-improvement/references/*` |
| Behavioral protection | `tests/pressure-scenarios.md`, baseline and verification reports |
| Installation/schema change | installers, memory schema, README, design documents |

Private templates may change only as neutral schemas. Learned user data never belongs in them.

## Draft PR record

The draft PR states:

- summary;
- anonymized universal evidence;
- scope and quality guardrails;
- RED or pressure scenario;
- verification performed and limitations;
- privacy review result;
- provisional or confirmed status.

The draft remains unmerged for human review.

## Completion notice

After an upstream write succeeds:

```text
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
```

After a public-safe local candidate write when upstream creation fails:

```text
Self-improvement updated: `CANDIDATES.md`; upstream draft PR failed.
```

The notice names changed memory/skill files and the PR reference only. The lesson is omitted unless requested. A PR is never claimed without a returned number or URL.
