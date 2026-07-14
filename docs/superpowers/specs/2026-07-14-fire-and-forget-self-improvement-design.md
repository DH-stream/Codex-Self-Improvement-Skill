# Fire-and-Forget Codex Self-Improvement Design

## Goal

Build one global Codex skill that learns safer and more efficient engineering behavior and the user's durable visual/UX taste across repositories without requiring manual activation.

The public GitHub repository evolves from universal improvements. Personal learning remains private and local.

## Learning lanes

The engine owns two separate lanes:

1. **Universal work-pattern learning**
   - planning, exploration, implementation, testing, review, and reporting;
   - token/time waste detection;
   - recurring mistakes and correction retrospectives;
   - engine, schema, and installation improvements.

2. **Private taste and preference learning**
   - UX, design, color, copy, interaction, visual density, animation, and image-editing preferences;
   - explicit corrections outweigh inference;
   - scope prevents a preference from leaking into unrelated contexts;
   - records remain local and never support a public PR.

Project facts such as commands, frameworks, filenames, repository names, or business rules are not universal memory.

## Storage architecture

```text
~/.codex/self-improvement/
├── PRIVATE_LOCATION        -> writable local private state
├── UNIVERSAL_LOCATION      -> read-only installed snapshot of upstream main
├── UPSTREAM_LOCATION       -> checkout used for isolated contributions
├── UPSTREAM_REPOSITORY     -> configured GitHub repository
├── private/
│   ├── UX_TASTE.md
│   ├── UX_TASTE_HISTORY.md
│   ├── CANDIDATES.md
│   ├── UPSTREAM_QUEUE.md
│   └── UPDATE_LOG.md
└── universal/
    ├── ACTIVE_PATTERNS.md
    ├── CANDIDATES.md
    ├── PATTERN_HISTORY.md
    ├── RECURRING_MISTAKES.md
    └── UPDATE_LOG.md
```

The public repository is the only writable universal source. `UNIVERSAL_LOCATION` is used for lookup and deduplication only and changes through later repository sync/install. `UPSTREAM_QUEUE.md` contains only sanitized public-compatible proposals blocked before draft-PR confirmation.

## Trigger model

The engine evaluates observable signals rather than guessing whether a task is complete.

After every user prompt, evaluate in this order:

1. **Explicit durable feedback**
   - evaluate private taste/workflow memory even when no repository file changed.
2. **Review, blocker, or correction of earlier work**
   - run the correction retrospective even when implementation is deferred.
3. **Technical repository change**
   - run the bounded efficiency retrospective only when code, tests, config, scripts, migrations, CI, agent instructions, or skills changed.
4. **Consolidation point**
   - commit, completed plan, final verification, strong correction, or session handoff may consolidate evidence and retry queued upstream work.

Ordinary conversation with no durable feedback, correction, or technical change produces no reflection write or notice.

## Fire-and-forget behavior

- Never ask whether reflection should run.
- Never interrupt implementation solely to reflect.
- Reflection with no file write remains silent.
- Weak, one-off, or project-specific evidence creates no global write.
- Read only relevant active categories.
- After a real memory/skill write, emit one compact line naming changed files and any confirmed draft PR.
- Do not explain the lesson unless requested.

## Correction retrospective

When later feedback reveals blockers or flaws in earlier work, Codex asks:

1. What was missed?
2. Why was it missed?
3. Was the necessary evidence available during the original implementation?
4. What minimum check would have exposed it without hindsight?
5. Did a test encode the implementation instead of the requirement?
6. Is the result universal, private user taste, or project context?

The result must be a preventive action, not “be more careful.”

## Memory lifecycle

```text
candidate → provisional → confirmed → low-relevance
                                  ↘ superseded
```

Nothing learned is deleted. Original evidence is immutable and later evidence appends:

- supporting independent evidence raises confidence;
- one strong universal incident may create a provisional proposal;
- contradiction lowers confidence/relevance;
- a better rule marks the older one superseded.

One qualified universal improvement is enough for a draft PR. Independent confirmation controls promotion and confidence, not proposal eligibility.

## Taste evidence hierarchy

1. Explicit correction or durable preference.
2. Independent repeated acceptance or choice.
3. Repeated implicit selection.
4. Agent inference.

The latest explicit instruction wins within its scope. “Universal-to-user” never means public or universal across users.

## Universal upstream evolution

A universal proposal follows this flow:

```text
local evidence
→ privacy-safe universal classification
→ stable contribution ID + deterministic branch
→ inspect queue, remote branch, and open draft PR for duplicates
→ fetch current remote main
→ isolated worktree
→ RED/pressure scenario
→ smallest complete public-safe change
→ fresh verification + full diff privacy review
→ push branch
→ open/update draft PR
→ stop for human review
```

Rules:

- one improvement is sufficient;
- `contribution_id` derives from normalized action plus a short content hash;
- branch name is `codex/self-improvement/<contribution_id>`;
- reuse matching queue, remote branch, or draft PR state;
- base new work on current remote `main`, not stale local `main`;
- refuse work when the isolated base is unproven or unrelated changes appear;
- never push directly to `main`, merge, approve, or mark ready automatically;
- disclose verification limitations in the draft PR;
- keep private memory outside the contribution surface.

## Queue lifecycle

When authentication, network, or PR creation blocks delivery:

```text
sanitized proposal
→ stable UPSTREAM_QUEUE.md record
→ status pending or branch-pushed
→ retry at most once per session or natural consolidation point
→ reuse deterministic branch / existing draft PR
→ status pr-open + recorded PR URL after confirmation
```

Successful records remain as operational history rather than being deleted. Obsolete records become `superseded` and link their replacement. The queue never contains ordinary private observations or learned taste.

## Notification contract

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
Self-improvement updated: `UPSTREAM_QUEUE.md`; upstream draft PR failed.
```

The line names changed memory/skill files and any confirmed PR. It does not restate the lesson, prompt, plan, or retrospective. No write means no notice.

## Safety invariants

Efficiency may change sequencing, scope, and reporting. It may never:

- skip required RED/GREEN or final verification;
- replace evidence with confidence;
- omit security, race, accessibility, or data-integrity checks;
- review only a description when code/base comparison is required;
- hide blockers or overstate completion;
- alter established visual direction while fixing unrelated behavior;
- expose private memory, local paths, proprietary context, or credentials publicly.

## Installation architecture

Each installer:

1. validates source directories, templates, activation snippet, destination safety, and upstream checkout;
2. stages complete skill, universal-snapshot, and `AGENTS.md` replacements;
3. rejects malformed activation markers before active files change;
4. preserves and seeds private files without overwriting learned state;
5. activates complete replacements, removing stale universal files/directories;
6. records private, universal, checkout, and repository locations;
7. keeps exactly one activation block.

The shell path uses Bash/awk and has no Python dependency. Executable regression tests cover source failure, portability, stale-directory cleanup, private preservation, universal refresh, and malformed markers. PowerShell follows the same staged/preflight contract and remains subject to a real Windows runtime gate.