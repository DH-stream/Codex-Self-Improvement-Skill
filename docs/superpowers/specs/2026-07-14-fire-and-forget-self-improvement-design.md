# Fire-and-Forget Codex Self-Improvement Design

## Goal

Build one global Codex skill that learns safer and more efficient engineering behavior and the user's durable visual/UX taste across repositories without requiring manual activation after each prompt.

## Scope

The system has two learning lanes owned by one engine:

1. **Work-pattern learning**
   - planning, exploration, implementation, testing, review, and reporting;
   - token/time waste detection;
   - recurring mistakes;
   - correction retrospectives when later prompts reveal blockers in prior work.

2. **Taste learning**
   - UX, design, color, copy, interaction, visual density, animation, image-editing preferences;
   - explicit corrections outweigh inference;
   - scope is recorded so a family app preference does not become a universal enterprise-dashboard rule.

Project-specific facts such as test commands, frameworks, filenames, or business rules are not promoted as universal memory.

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
- Routine reflection is silent.
- Write no memory update when evidence is weak or project-specific.
- Mention only material new learning in the ordinary completion report.
- Read only relevant active categories at task start.

## Correction retrospective

When prompt 2 supplies blockers/fixes for prompt 1, Codex asks:

1. What was missed?
2. Why was it missed?
3. Was the necessary evidence available during prompt 1?
4. What minimum check would have exposed it without hindsight?
5. Did a test encode the implementation instead of the requirement?
6. Is the lesson universal, user-specific taste, or merely project context?

The output must produce a preventive check, not “be more careful.”

## Memory lifecycle

```text
candidate → provisional → confirmed → low-relevance
                                  ↘ superseded
```

Nothing is deleted. Original evidence is immutable. New evidence appends:

- supporting evidence increases confidence;
- independent evidence from another task or repository promotes a pattern;
- one severe, costly incident may create a provisional medium-confidence pattern;
- contradicting evidence lowers confidence/relevance;
- replacement rules mark older ones superseded.

Active indexes stay compact; full history remains available for consolidation.

## Taste evidence hierarchy

1. Explicit correction or durable preference.
2. User accepts/repeats the same choice independently.
3. Repeated implicit selection.
4. Agent inference.

The latest explicit instruction wins within its stated scope. Conflicts do not erase history.

## Engine evolution

Most learning updates memory, not the engine. Codex may propose or apply a tracked skill/reference change when evidence shows the procedure itself is missing or ambiguous. Engine changes require:

- a concrete failure scenario;
- an updated pressure scenario;
- no weakening of quality gates;
- a visible repository diff and update-log entry.

## Safety invariants

Efficiency may change sequencing, scope, and reporting. It may never:

- skip required RED/GREEN or final verification;
- replace evidence with confidence;
- omit security, race, accessibility, or data-integrity checks;
- review only a description when code/base comparison is required;
- hide blockers or overstate completion;
- modify the user's established visual direction while fixing unrelated behavior.

## Installation architecture

The installable skill lives under `skills/codex-self-improvement/`. Evolving memory defaults to a private global directory under `~/.codex/self-improvement/memory`. The repository `memory/` directory is the seed and can optionally become the live memory root for Git-backed synchronization.
