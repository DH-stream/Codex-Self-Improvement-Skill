# Verification report — initial skill implementation

Date: 2026-07-14
Branch: `chatgpt/fire-and-forget-self-improvement`
Base: `main` at `4abdeb8f8ef16f59c28616a9bfe874fc30c510b9`

## Skill structure

Fresh structural checks:

- `SKILL.md` frontmatter starts and ends correctly.
- Skill name is `codex-self-improvement`.
- Description begins with `Use when` and contains trigger conditions only.
- `SKILL.md` word count: 495.
- All five required reference paths are present, including `upstream-contribution.md`.
- Private, universal, upstream, installer, routing, design, history, and pressure-scenario files are present in the branch diff.
- Eleven pressure scenarios are defined.

Result: PASS.

## Public/private diff review

The complete PR diff against `main` was reviewed through the GitHub API.

Assertions:

```text
learned memory/UX_TASTE.md in public diff: no
learned memory/UX_TASTE_HISTORY.md in public diff: no
neutral memory/private-template/ files present: yes
neutral UPSTREAM_QUEUE.md template present: yes
private/public storage contract present: yes
one-improvement upstream draft-PR contract present: yes
direct-main and automatic-merge prohibitions present: yes
compact filename/PR notice contract present: yes
```

Result: PASS for repository structure and final public diff.

## Shell installer

The verification container could not resolve `github.com`, so it could not clone the branch directly. The exact current `install.sh` content from the GitHub branch was mirrored into an isolated fixture with the same directory layout.

Checks exercised:

```bash
bash -n install.sh
CODEX_HOME=<temp> bash install.sh
CODEX_HOME=<temp> bash install.sh
CODEX_HOME=<legacy-temp> bash install.sh
CODEX_HOME=<queue-temp> bash install.sh
CODEX_HOME=<queue-temp> bash install.sh
```

Observed assertions:

```text
bash syntax: pass
activation marker count after two installs: 1
installed SKILL.md present: yes
existing private UX_TASTE.md preserved: yes
universal ACTIVE_PATTERNS.md refreshed after source change: yes
legacy UX_TASTE.md migrated before template seeding: yes
legacy UX_TASTE_HISTORY.md migrated before template seeding: yes
pending UPSTREAM_QUEUE.md preserved across reinstall: yes
universal refresh still occurs while queue is preserved: yes
PRIVATE_LOCATION correct: yes
UNIVERSAL_LOCATION correct: yes
UPSTREAM_LOCATION correct: yes
UPSTREAM_REPOSITORY correct: yes
```

Result: PASS for shell installer behavior.

## PowerShell installer

Fresh static checks on the current script:

- parentheses, braces, and brackets balanced;
- skill and universal directories refresh on reinstall;
- private templates copy only when destination files are absent;
- legacy taste migration occurs before template seeding;
- all four location/repository files are written;
- idempotent activation-marker replacement remains present;
- the generic private-template loop includes and preserves `UPSTREAM_QUEUE.md`.

Result: PASS for static structure.

Limitation: no PowerShell runtime was available, so `install.ps1` was not executed.

## Upstream contribution behavior

Structural coverage now includes:

- one qualified universal improvement is sufficient;
- private files are outside the contribution surface;
- contribution branches start from current upstream `main`;
- draft PRs are required;
- direct `main`, automatic merge, approval, and ready-for-review transitions are forbidden;
- RED/pressure evidence, fresh verification, and complete diff privacy review are required;
- authentication/network failure writes an already-sanitized record to local `UPSTREAM_QUEUE.md`;
- the queue survives reinstall and is removed only after branch and draft-PR confirmation.

The current implementation is itself on draft PR #1, and the branch remains unmerged.

Limitation: the installed skill has not yet been run in a fresh Codex agent with authenticated Git/GitHub CLI to prove autonomous branch push, retry, and draft-PR creation end to end.

## Pressure scenarios

The RED evidence is recorded in `tests/baseline-observations.md`. Eleven reusable pressure scenarios are defined in `tests/pressure-scenarios.md`, including private/public separation, one-improvement upstream contribution, token-bounded update notices, and persistent retry state.

Limitation: fresh-context agent runs with and without the installed skill were not available in this environment. They remain the behavioral verification gate before marking the draft ready for review.
