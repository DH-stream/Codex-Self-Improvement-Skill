# Codex Self-Improvement Skill

A global, fire-and-forget learning system for Codex.

It improves two things over time:

1. **Engineering judgment and efficiency** — how Codex explores, implements, tests, reviews, and reports without wasting usage or weakening quality.
2. **User taste** — durable preferences in UX, design, color, copy, interaction, visual polish, and image work.

The system runs automatically after prompts that change technical repository files. Corrections and blocker follow-ups trigger a deeper retrospective: not only “how do I fix this?”, but “what evidence or check would have exposed this during the first implementation?”

## Principles

- One global engine is shared across every repository.
- Project facts stay project-local; universal lessons and user taste live globally.
- Routine reflection is silent and bounded.
- Nothing is deleted. Old knowledge is marked low-relevance or superseded.
- Quality, safety, TDD, and final verification are never traded for token savings.
- Explicit user corrections are high-value evidence.
- Memory updates are automatic; engine changes remain tracked and reviewable.

## Repository layout

```text
CORE.md                              Stable system invariants
AGENTS.md                            Routing for this repository
skills/codex-self-improvement/       Installable skill and procedures
memory/                              Seed memory and schemas
install/AGENTS-snippet.md            Global activation hook
install.ps1 / install.sh             Idempotent installers
tests/                               Pressure scenarios and baseline evidence
docs/superpowers/                    Design and implementation plan
```

## Install

### Windows PowerShell

```powershell
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.ps1
```

### macOS/Linux

```bash
git clone https://github.com/DH-stream/Codex-Self-Improvement-Skill
cd Codex-Self-Improvement-Skill
./install.sh
```

The installers:

- update the global skill under `~/.codex/skills/codex-self-improvement`;
- seed persistent memory under `~/.codex/self-improvement/memory` without overwriting learned memory;
- append an idempotent fire-and-forget hook to `~/.codex/AGENTS.md`.

Use `-UseRepositoryMemory` on PowerShell or `USE_REPOSITORY_MEMORY=1` on shell when learned memory should be written directly into this checkout for Git synchronization. The default keeps evolving personal memory local and private.

## Normal behavior

Codex should not announce routine reflection. After a code-changing prompt, it performs a small post-change review and writes nothing when there is no material lesson. A correction to earlier work invokes the deeper correction retrospective automatically.

See [`CORE.md`](CORE.md) and the installed [`SKILL.md`](skills/codex-self-improvement/SKILL.md).
