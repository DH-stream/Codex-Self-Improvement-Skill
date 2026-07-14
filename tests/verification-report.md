# Verification report — self-updating skill

Date: 2026-07-14
Branch: `chatgpt/fire-and-forget-self-improvement`
Base: `main` at `4abdeb8f8ef16f59c28616a9bfe874fc30c510b9`
Code/diff reviewed through head: `46d016904aeafe5b0aae2360ca8a22a62036287f`

## Skill structure

Fresh checks:

```text
SKILL.md frontmatter: valid
name: codex-self-improvement
description begins with Use when: yes
SKILL.md word count: 468
required references found: 5/5
pressure scenarios: 15
executable installer regression file: present
```

The five required references are:

- `reflection-procedure.md`
- `correction-retrospective.md`
- `memory-schema.md`
- `taste-learning.md`
- `upstream-contribution.md`

Result: PASS.

## Second code review findings and corrections

A fresh review of the actual PR code against `main` found and corrected four load-bearing issues:

1. Explicit durable feedback and review-only corrections were skipped when no repository file changed.
2. Installed universal memory and GitHub branches could act as competing writable sources.
3. Queue retries lacked stable identity, deterministic branches, and bounded automatic retry.
4. The shell installer changed active state before complete preflight/staging, depended on Python, and left stale nested universal paths.

The corrected contracts now:

- evaluate feedback/correction signals independently from the technical-change gate;
- treat `UNIVERSAL_LOCATION` as a read-only upstream snapshot;
- author universal proposals only in isolated branches/worktrees based on current remote `main`;
- use stable contribution IDs, deterministic branches, machine-scannable queue states, existing branch/PR discovery, and once-per-session/natural-gate retries;
- stage and validate complete installer replacements before activation.

## Executable shell installer RED/GREEN

The previous shell installer was exercised against three new regression tests before production edits.

Observed RED:

```text
FAIL: missing source preserves existing install
FAIL: shell installer has no Python runtime dependency
FAIL: universal refresh removes stale directories
Installer tests: 0 passed, 3 failed
```

Fresh final commands:

```bash
bash -n install.sh
bash -n tests/test-install.sh
bash tests/test-install.sh
```

Observed GREEN:

```text
PASS: missing source preserves existing install
PASS: shell installer has no Python runtime dependency
PASS: universal refresh removes stale directories
PASS: reinstall preserves private state and refreshes universal snapshot
PASS: unmatched AGENTS markers fail before activation
Installer tests: 5 passed, 0 failed
```

The final tests also verify that a pending private `UPSTREAM_QUEUE.md` record survives reinstall, the universal snapshot refreshes, and only one activation marker remains.

The verification container could not resolve `github.com`, so the exact final `install.sh` and `tests/test-install.sh` contents were mirrored into an isolated fixture with the required repository layout rather than cloned over the network.

Result: PASS for shell syntax and executable behavior.

## PowerShell installer

The complete final `install.ps1` was reviewed against the shell contract. It contains:

- source/template/snippet preflight;
- root-destination rejection;
- documented environment and parameter precedence;
- staged skill, universal, and AGENTS replacements;
- activation-marker validation before replacement;
- private memory and queue preservation;
- backup/rollback for active skill, universal snapshot, and AGENTS file;
- four location/repository files;
- cleanup through `finally`.

Limitation: no PowerShell runtime was available, so this is a static code review, not an executed PowerShell test.

## Public/private and upstream review

The complete PR diff against `main` was reviewed, not only the PR description.

Assertions:

```text
learned public memory/UX_TASTE.md: absent
learned public memory/UX_TASTE_HISTORY.md: absent
neutral private templates: present
installed universal snapshot documented read-only: yes
universal proposals routed to isolated upstream branch: yes
stable contribution ID and deterministic branch: yes
queue states pending/branch-pushed/pr-open/superseded: yes
successful queue history preserved: yes
direct main / auto merge / auto approve / auto ready prohibited: yes
compact filename/PR notice: yes
```

Result: PASS for final repository structure and privacy contract.

## Remaining behavioral gates

- Execute `install.ps1` in a real Windows PowerShell environment.
- Run fresh agent pressure scenarios with and without the installed skill.
- Run an authenticated Codex/GitHub end-to-end test proving branch discovery/creation, push, partial-failure retry, and draft-PR creation.

The PR must remain draft and unmerged until those gates are reviewed.