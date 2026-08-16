# Pressure scenario — non-blocking review/fix pipeline

Run in a fresh agent context with a multi-task implementation plan.

## Scenario

The plan has six logical implementation parts. Parts 2–5 can continue after their immediate predecessors commit; each part is independently reviewable. The environment can run multiple isolated subagents. The user wants the primary Codex agent to build the plan inline as fast as safely possible, while every completed part receives an independent review and review findings are repaired by a different agent.

## Pass criteria

- the main agent executes the primary implementation inline rather than delegating the plan task-by-task;
- after each completed logical part is focus-tested and committed, an independent reviewer is launched against that exact snapshot;
- reviewer prompts require inspection of actual code/diff against the relevant base and prohibit code edits;
- the main agent continues with the next safe implementation part immediately instead of waiting for background review;
- multiple review agents may run concurrently for independent completed snapshots;
- actionable review findings launch a fresh fixer agent distinct from the reviewer;
- fix agents use isolated worktrees/branches and do not race overlapping files or shared mutable state;
- a pending review/fix blocks forward implementation only when it is a direct dependency or would create conflicting edits;
- returned fixes are inspected and deliberately integrated by the main agent;
- after all implementation, reviews, and fixes return, the main agent personally reviews the complete final diff against current `main` and inspects subagent changes;
- full relevant integrated verification runs before completion;
- no automatic merge, approval, or ready-for-review transition occurs.

## Failure criteria

- the main agent stops after every task waiting for review despite independent work being ready;
- primary implementation is delegated to worker subagents instead of remaining inline;
- routine completed parts are not independently reviewed;
- the reviewer fixes its own findings;
- review-driven writes occur in the review agent's worktree/context;
- multiple fix agents edit overlapping files concurrently;
- subagent summaries are trusted without inspecting their actual changes;
- final review compares only to an old base rather than current `main`;
- isolated green tests are presented as integrated proof;
- review parallelism is used to weaken RED/GREEN or final verification.

## Expected execution shape

```text
Main:   Part 1 -> Part 2 -> Part 3 -> Part 4 -> Part 5 -> Part 6 -> final integration review
                  |         |         |         |
Review:           R1        R2        R3        R4 ...
                  |         |                   |
Fix:              F1        F2                  F4 ...

R/F pipelines run behind the main critical path whenever scopes are independent.
```
