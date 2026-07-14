# Fire-and-Forget Codex Self-Improvement Design

## Goal

Build one global Codex skill that learns safer and more efficient engineering behavior and the user's durable visual/UX taste across repositories without requiring manual activation after each prompt.

The public GitHub repository evolves from universal improvements. Personal learning remains private and local.

## Learning lanes

The system has two lanes owned by one engine:

1. **Universal work-pattern learning**
   - planning, exploration, implementation, testing, review, and reporting;
   - token/time waste detection;
   - recurring mistakes;
   - correction retrospectives when later prompts reveal blockers in prior work;
   - engine, schema, and installation improvements.

2. **Private taste learning**
   - UX, design, color, copy, interaction, visual density, animation, and image-editing preferences;
   - explicit corrections outweigh inference;
   - scope is recorded so one product preference does not control unrelated contexts;
   - records remain local and are never used as public PR evidence.

Project-specific facts such as test commands, frameworks, filenames, or business rules are not promoted as universal memory.

## Storage architecture

```text
~/.codex/self-improvement/
├── PRIVATE_LOCATION        -> local private state
├── UNIVERSAL_LOCATION      -> installed public-compatible state
├── UPSTREAM_LOCATION       -> local checkout used for contributions
├── UPSTREAM_REPOSITORY     -> configured GitHub repository
├── private/
│   ├── UX_TASTE.md
│   ├── UX_TASTE_HISTORY.md
│   ├── CANDIDATES.md
│   └── UPDATE_LOG.md
└── universal/
    ├── ACTIVE_PATTERNS.md
    ├── CANDIDATES.md
    ├── PATTERN_HISTORY.md
    ├── RECURRING_MISTAKES.md
    └── UPDATE_LOG.md
```

The public repository contains universal state and neutral private templates. It contains no learned user taste.

## Trigger model

Codex does not decide whether an abstract “task” is complete. Observable repository state drives the process.

Before technical work, capture a lightweight state snapshot. After responding:

- no meaningful technical file change → no reflection;
- technical repository files changed → bounded micro-retrospective;
- current work fixes, reviews, or supersedes earlier implementation → correction retrospective too;
- commit, completed plan, final verification, strong user correction, or session handoff → consolidation.

Technical files include code, tests, configuration, scripts, migrations, CI, `AGENTS.md`, and skill/workflow instructions. Ordinary prose documentation does not trigger reflection unless it changes agent behavior or technical workflow.

## Fire-and-forget behavior

- Never ask whether reflection should run.
- Never interrupt implementation solely to reflect.
- Reflection with no file write remains silent.
- Write no memory update when evidence is weak or project-specific.
- Read only relevant active categories at task start.
- After a real memory/skill write, emit one compact line naming the changed files and any draft PR.
- Do not explain the lesson unless requested.

## Correction retrospective

When prompt 2 supplies blockers/fixes for prompt 1, Codex asks:

1. What was missed?
2. Why was it missed?
3. Was the necessary evidence available during prompt 1?
4. What minimum check would have exposed it without hindsight?
5. Did a test encode the implementation instead of the requirement?
6. Is the lesson universal, private user taste, or merely project context?

The output must produce a preventive check, not “be more careful.”

## Memory lifecycle

```text
candidate → provisional → confirmed → low-relevance
                                  ↘ superseded
```

Nothing is deleted. Original evidence is immutable. New evidence appends:

- supporting evidence increases confidence;
- independent evidence from another task or repository promotes a pattern;
- one severe or clear universal incident may create a provisional pattern;
- contradicting evidence lowers confidence/relevance;
- replacement rules mark older ones superseded.

One qualified universal improvement is enough to propose a draft PR. Independent confirmation controls promotion and confidence, not whether a reviewable proposal may exist.

Active indexes stay compact; full history remains available for consolidation.

## Taste evidence hierarchy

1. Explicit correction or durable preference.
2. User accepts/repeats the same choice independently.
3. Repeated implicit selection.
4. Agent inference.

The latest explicit instruction wins within its stated scope. Conflicts do not erase private history. “Universal-to-user” scope never means public or universal across users.

## Universal upstream evolution

A qualified universal improvement follows this flow:

```text
local evidence
→ privacy-safe universal classification
→ RED/pressure scenario
→ isolated branch from current upstream main
→ minimal engine/pattern change
→ fresh verification and complete diff privacy review
→ push dedicated branch
→ open/update draft PR
→ stop for human review
```

Rules:

- one improvement is sufficient; batching is not required;
- each improvement uses a dedicated branch unless an open draft already represents the same change;
- direct writes to `main` are forbidden;
- automatic merge, approval, and ready-for-review transitions are forbidden;
- upstream/authentication failure keeps the sanitized observation in universal candidates;
- draft PRs disclose verification limitations;
- private memory is outside the public contribution surface.

## Notification contract

Actual writes produce one line:

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
```

The line names every changed memory/skill file. It does not restate the lesson, prompt, plan, or retrospective. No file change means no notice.

## Safety invariants

Efficiency may change sequencing, scope, and reporting. It may never:

- skip required RED/GREEN or final verification;
- replace evidence with confidence;
- omit security, race, accessibility, or data-integrity checks;
- review only a description when code/base comparison is required;
- hide blockers or overstate completion;
- modify the user's established visual direction while fixing unrelated behavior;
- expose private memory or proprietary context publicly.

## Installation architecture

The installable skill lives under `skills/codex-self-improvement/`.

Each install:

- refreshes engine files;
- refreshes public universal state from the checkout;
- seeds missing private files from neutral templates;
- preserves existing private files;
- migrates taste files from the first installer layout;
- records private, universal, checkout, and repository locations;
- updates one marked global `AGENTS.md` activation block.
