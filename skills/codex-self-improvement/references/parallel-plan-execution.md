# Non-blocking review/fix pipeline for multi-task plans

Use this procedure before executing any implementation plan with two or more tasks.

## Core rule

The main agent owns and executes the primary implementation inline. Reviews and review-driven fixes form a background pipeline around completed snapshots; they must not turn every task into a blocking checkpoint.

Parallelism may reduce wall-clock time; it may never weaken TDD, review, safety, or final integrated verification.

## 1. Map topology before implementation

For every task, record:

| Field | Required question |
|---|---|
| Dependencies | Which committed interfaces or outputs must exist first? |
| Produces | Which interfaces, files, schemas, or generated outputs become inputs later? |
| File ownership | Which exact files or directories may this task modify? |
| Shared mutable state | Does it touch lockfiles, shared manifests, generated output, migrations, snapshots, or the same runtime state? |
| Risk | Does review need security, data-integrity, concurrency, architecture, accessibility, or migration focus? |

Task numbering is presentation order, not proof of dependency. If task boundaries are too broad to assess, split them before execution.

Produce a compact execution map containing the dependency graph, critical path, likely review scopes, and shared-file conflicts. Continue automatically unless a genuine approval gate exists.

## 2. Main agent implements continuously

The primary agent executes the plan inline and remains the integration owner.

For each logical part:

1. write the failing test where required;
2. observe RED;
3. implement the smallest GREEN change;
4. run focused verification;
5. self-review and commit a recoverable snapshot;
6. immediately continue to the next safe task if no direct dependency or file conflict requires waiting.

Do not delegate the primary implementation plan to a chain of worker subagents merely because the plan has multiple tasks.

## 3. Launch a review as soon as a part is complete

Every completed logical part gets an independent review subagent against the exact commit/snapshot that completed it.

The reviewer receives:

- exact commit or snapshot;
- intended task/requirements;
- relevant base/main reference;
- focused risk areas;
- instruction to inspect actual code and diff, not summaries;
- instruction to report findings only and **not edit code**.

The main agent does not wait for this review when later work is independent. Multiple completed parts may have reviews in flight concurrently.

## 4. Separate fix agents handle findings

When a review reports actionable findings, dispatch a **new fix subagent** scoped to that review. A reviewer never fixes its own findings.

The fix agent receives the review findings, exact snapshot/base, owned files, and required tests. It works in an isolated worktree/task branch and returns a commit plus verification evidence.

Fix agents may run concurrently when their write scopes are disjoint. Do not run concurrent fix agents that edit the same files, migrations, lockfiles, generated outputs, or shared external state. Queue conflicting fixes under the integration owner instead.

A review or fix blocks the main agent only when its outcome is a prerequisite for the next implementation step or when continuing would create conflicting edits.

## 5. Integrate continuously but deliberately

As review/fix work returns:

1. inspect each review and resulting fix diff;
2. confirm the fix addresses the reported root cause without widening scope;
3. integrate the fix into the authoritative feature branch;
4. resolve conflicts against newer inline work explicitly;
5. run focused tests covering the integrated change.

Never assume a subagent commit is correct because its own tests pass.

## 6. Final main-agent gate

After the implementation plan is complete and every launched review/fix pipeline has returned:

- compare the full final branch with **current `main`**;
- inspect all primary-agent and subagent changes;
- check that later tasks did not invalidate earlier reviews/fixes;
- look for duplicated interfaces, stale assumptions, race conditions, privacy/security regressions, and cross-task integration defects;
- run the repository's complete relevant test, typecheck, lint, build, migration, security, accessibility, browser/E2E, and data-integrity gates as applicable;
- fix remaining issues before declaring completion;
- preserve requested PR/draft/merge gates.

The final review belongs to the main agent. Background reviewers supplement it; they never replace it.

## Red flags

- Main agent stops after every task waiting for reviewer output despite independent work being ready.
- Primary implementation is delegated task-by-task to subagents instead of staying inline.
- Reviewer edits the code it reviewed.
- Review findings are fixed by the same reviewer instead of a fresh fixer.
- Multiple write agents race the same files or shared state.
- Review only reads summaries, reports, or PR descriptions.
- Final review compares only with the original base rather than current `main`.
- Parallel green tasks are treated as proof that the integrated branch is green.
- Review/fix parallelism is used to justify weaker RED/GREEN or final verification.
