# Codex Self-Improvement Skill

A global, fire-and-forget learning system for Codex.

It improves two things over time:

1. **Engineering judgment and efficiency** — how Codex explores, implements, tests, reviews, and reports without wasting usage or weakening quality.
2. **Private user taste** — durable preferences in UX, design, color, copy, interaction, visual polish, and image work.

The system runs automatically after prompts that change technical repository files. Corrections and blocker follow-ups trigger a deeper retrospective: not only “how do I fix this?”, but “what evidence or check would have exposed this during the first implementation?”

## Public and private layers

The installation deliberately separates learning:

```text
GitHub repository / universal state
├── skill engine and references
├── universal work patterns
├── recurring engineering mistakes
├── pressure scenarios and verification
└── neutral private-memory templates

Local private state
├── user UX/design taste
├── private evidence and candidates
├── pending sanitized upstream contributions
├── private history
└── private update log
```

Personal taste and private evidence never enter GitHub. Universal improvements are sanitized, pressure-tested, verified, and proposed through a dedicated draft PR.

## Principles

- One global engine is shared across every repository.
- Project facts stay project-local.
- Personal taste stays local and private.
- Public memory contains only universal, anonymized, quality-preserving improvements.
- One qualified universal improvement is enough to open a draft PR; batching is not required.
- Codex never pushes directly to `main` and never merges automatically.
- Reflection is silent when it writes nothing.
- Actual memory/skill writes produce one compact notice naming changed files and any draft PR.
- Nothing is deleted. Old knowledge is marked low-relevance or superseded.
- Quality, safety, TDD, review, and final verification are never traded for token savings.

## Repository layout

```text
CORE.md                              Stable system invariants
AGENTS.md                            Routing for this repository
skills/codex-self-improvement/       Installable skill and procedures
memory/*.md                          Public universal seed state
memory/private-template/             Neutral templates for private local state
install/AGENTS-snippet.md            Global activation hook
install.ps1 / install.sh             Idempotent installers
tests/                               Pressure scenarios and verification evidence
docs/superpowers/                    Designs and implementation plans
```

## Install

### Windows PowerShell

```powershell
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.ps1
```

An alternative upstream checkout may be supplied with `-UpstreamCheckout`. The configured public repository may be changed with `-UpstreamRepository`.

### macOS/Linux

```bash
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.sh
```

Environment overrides:

```text
SELF_IMPROVEMENT_UPSTREAM_CHECKOUT
SELF_IMPROVEMENT_UPSTREAM_REPOSITORY
```

The installers:

- refresh the global skill under `~/.codex/skills/codex-self-improvement`;
- refresh public universal state under `~/.codex/self-improvement/universal`;
- seed private state under `~/.codex/self-improvement/private` only when files are missing;
- preserve existing private taste and `UPSTREAM_QUEUE.md` during reinstall;
- migrate taste files from the first installer layout;
- record private, universal, and upstream locations;
- maintain one idempotent activation block in `~/.codex/AGENTS.md`.

## Universal self-updates

When Codex finds one qualified universal improvement, it may automatically:

1. use the configured upstream checkout;
2. create an isolated branch from current upstream `main`;
3. add RED/pressure evidence and the smallest complete improvement;
4. run available verification and inspect the complete public diff for privacy;
5. push the branch and open or update a draft PR;
6. leave the PR unmerged for human review.

Authentication or upstream failure stores the sanitized contribution in local `UPSTREAM_QUEUE.md`. That queue survives reinstall and is retried on a later authenticated run; `main` remains untouched.

## Normal visibility

No memory/skill change means no self-improvement narration.

An actual write adds one compact line to the normal completion response:

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

The lesson itself is omitted unless requested, keeping the mechanism useful without spending tokens on routine retrospective prose.

See [`CORE.md`](CORE.md) and the installed [`SKILL.md`](skills/codex-self-improvement/SKILL.md).
