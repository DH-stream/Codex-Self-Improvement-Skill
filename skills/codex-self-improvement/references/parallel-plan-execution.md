# Dependency-aware parallel plan execution

Use this procedure before executing any implementation plan with two or more tasks.

## Core rule

Review task topology before choosing an execution model. Task numbering is presentation order, not proof of dependency.

- No safe parallel width → one primary agent works inline through verified checkpoints.
- Safe independent width → dispatch those tasks concurrently in isolated worktrees.
- Mixed plan → execute bounded parallel waves separated by integration gates.

Parallelism may reduce wall-clock time; it may never weaken TDD, review, safety, or final integrated verification.

## 1. Build the task topology

For every task, record:

| Field | Required question |
|---|---|
| Dependencies | Which committed interfaces or outputs must exist first? |
| Produces | Which interfaces, files, schemas, or generated outputs become inputs later? |
| File ownership | Which exact files or directories may this task modify? |
| Shared mutable state | Does it touch lockfiles, shared manifests, generated output, migrations, snapshots, or the same runtime state? |
| Risk | Is specialist review needed for security, data integrity, migrations, concurrency, or architecture? |
| Worktree safety | Can it commit independently without relying on another worker's uncommitted state? |

Treat hidden shared writes as conflicts. Common examples: `package.json`, lockfiles, barrel exports, generated catalogs, database migrations, shared fixtures, snapshot files, and one global config.

If task boundaries are too broad to assess, split them before dispatch. If the plan contradicts itself, requires user-approved assets, or introduces a security-sensitive installation, stop for one batched decision. Do not ask for approval merely because safe parallelism exists.

## 2. Create a dependency graph and waves

A task is ready only when all dependencies are committed and reviewed enough for downstream use.

Build waves from ready tasks that also have disjoint write ownership:

```text
Wave 1: contract
Wave 2: generator || resolver
Wave 3: renderer || fixtures
Wave 4: integration surface
Wave 5: final verification
```

Use bounded concurrency: at most four implementation workers by default, or fewer when available capacity, repository size, test contention, or risk makes a smaller wave cheaper. Do not serialize independent tasks merely because their task numbers are consecutive.

Before dispatch, produce a compact execution map containing:

1. dependency graph;
2. parallel waves;
3. shared-file conflicts and assigned owner;
4. worktree/task-branch names;
5. sequential critical path versus expected parallel critical path.

Keep this map brief. Continue automatically unless a genuine approval gate is present.

## 3. Isolate workers and ownership

One integration owner controls the feature branch. Each concurrent implementation worker receives:

- its own worktree and task branch;
- one exact task/domain;
- binding global constraints;
- committed interfaces it may consume;
- exact files/directories it owns;
- focused test commands;
- a required commit and concise report.

Workers must not push to `main`, modify the integration branch directly, or edit files owned by another active worker.

Assign unavoidable shared files to the integration owner or a single sequential task. A worker may report a required shared-file change, but must not race another worker to apply it.

## 4. Review and integrate continuously

Each worker must run RED/GREEN where required, focused tests, and self-review before reporting completion.

As soon as a task finishes:

1. inspect its actual diff against its task base;
2. verify its declared interfaces and focused test evidence;
3. use a specialist reviewer only when task risk or ambiguity justifies the extra coordination cost;
4. integrate the approved commit in topological order;
5. run tests covering the combined wave.

Do not create one implementer-plus-reviewer pair for every routine task by default. The integration owner supplies the routine task gate; specialist subagents are for meaningful risk or independent judgment.

A failed worker does not block unrelated workers in the same wave. Resolve its blocker, narrow its task, or replace it while other independent work continues.

## 5. Final integrated gate

After all waves:

- inspect the complete branch diff against the intended base;
- run the repository's required test, typecheck, lint, build, migration, security, accessibility, and data-integrity gates as applicable;
- verify no worker-only assumption or duplicated interface survived integration;
- confirm production/merge/activation gates remain as requested;
- perform one broad final review;
- report blockers honestly.

Parallel green tasks are not proof that their integration is green.

## Do not parallelize when

- tasks edit the same files or generated outputs;
- a downstream interface is still undecided or uncommitted;
- one task's fix may change the root cause of another;
- migrations or shared external state cannot be isolated;
- the work is exploratory and task boundaries are not yet known;
- coordination costs more than the ready work.

## Red flags

- Running tasks 1–8 sequentially without first checking dependencies.
- Dispatching every task simultaneously despite unresolved prerequisites.
- Multiple write agents sharing one worktree.
- Two workers editing a lockfile, shared manifest, migration chain, or generated catalog.
- Workers merging directly into the feature branch or `main`.
- Repeating full-suite verification in every worker while skipping integrated verification.
- Spawning reviewer agents for trivial tasks where the integration owner can inspect the diff.
- Treating parallelism as permission to reduce tests or review.
