# Codex Self-Improvement Skill

A global, fire-and-forget learning system for Codex.

It improves two things over time:

1. **Engineering judgment and efficiency** — exploration, implementation, testing, review, and reporting without wasting usage or weakening quality.
2. **Private user taste** — durable preferences in UX, design, color, copy, interaction, visual polish, and image work.

Technical file changes trigger a bounded efficiency reflection. Explicit durable feedback and review/correction signals are evaluated independently, so useful learning is not lost merely because implementation is deferred.

## Public and private layers

```text
GitHub repository / writable universal source
├── skill engine and references
├── universal work patterns
├── recurring engineering mistakes
├── pressure scenarios and verification
└── neutral private-memory templates

Installed universal snapshot / read-only
└── copy of public upstream main used for lookup and deduplication

Local private state / writable
├── user UX/design taste
├── private evidence and candidates
├── sanitized upstream retry queue
├── private history
└── private update log
```

Personal taste and private evidence never enter GitHub. Universal proposals are authored only in isolated upstream branches/worktrees. The installed universal snapshot is never used as a second writable source.

## Principles

- One global engine is shared across repositories.
- Project facts stay project-local.
- Personal taste stays local and private.
- One qualified universal improvement is enough to open a draft PR.
- Stable contribution IDs and deterministic branches prevent duplicate retries.
- Codex never pushes directly to `main`, merges automatically, approves, or marks its own update ready for review.
- Reflection is silent when it writes nothing.
- Actual memory/skill writes produce one compact filename/PR notice.
- Learned history is preserved; old knowledge becomes low-relevance or superseded.
- Quality, safety, TDD, review, and final verification are never traded for token savings.

## Repository layout

```text
CORE.md                              Stable system invariants
AGENTS.md                            Routing for this repository
skills/codex-self-improvement/       Installable skill and procedures
memory/*.md                          Public universal seed state
memory/private-template/             Neutral templates for private local state
install/AGENTS-snippet.md            Global activation hook
install.ps1 / install.sh             Idempotent staged installers
tests/test-install.sh                Executable shell installer regressions
tests/pressure-scenarios.md          Agent behavior scenarios
docs/superpowers/                    Designs and implementation plans
```

## Install

### Windows PowerShell

```powershell
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.ps1
```

Optional parameters: `-UpstreamCheckout` and `-UpstreamRepository`.

### macOS/Linux

```bash
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.sh
```

Runtime overrides:

```text
UPSTREAM_LOCATION
UPSTREAM_REPOSITORY
```

Legacy installer aliases remain accepted:

```text
SELF_IMPROVEMENT_UPSTREAM_CHECKOUT
SELF_IMPROVEMENT_UPSTREAM_REPOSITORY
```

The installers:

- validate required sources before changing active files;
- stage complete skill, universal, and activation-hook replacements;
- refresh `~/.codex/skills/codex-self-improvement`;
- refresh the read-only universal snapshot under `~/.codex/self-improvement/universal`;
- seed private files only when missing;
- preserve private taste and `UPSTREAM_QUEUE.md`;
- migrate taste files from the first installer layout;
- record private, universal, checkout, and repository locations;
- maintain exactly one marked block in `~/.codex/AGENTS.md`.

The shell installer uses standard Bash/awk tooling and has no Python runtime dependency.

## Universal self-updates

For one qualified universal improvement, Codex may automatically:

1. derive a stable contribution ID and deterministic branch;
2. inspect the queue, remote branches, and open draft PRs for an existing match;
3. fetch current remote `main` and create an isolated worktree;
4. add RED/pressure evidence and the smallest complete public-safe change;
5. run available verification and inspect the complete diff for privacy;
6. push the branch and open or update a draft PR;
7. leave the PR unmerged for human review.

Authentication or network failure updates the sanitized record in local `UPSTREAM_QUEUE.md`. Active entries retry at most once per session or natural consolidation point. A confirmed draft PR changes the record to `status: pr-open`; history is preserved.

## Normal visibility

No memory/skill change means no self-improvement narration. An actual write adds one compact line:

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

The lesson itself is omitted unless requested.

## Verify

```bash
bash -n install.sh
bash tests/test-install.sh
```

Fresh-agent pressure scenarios and an authenticated end-to-end upstream PR run remain separate behavioral gates.

See [`CORE.md`](CORE.md) and the installed [`SKILL.md`](skills/codex-self-improvement/SKILL.md).