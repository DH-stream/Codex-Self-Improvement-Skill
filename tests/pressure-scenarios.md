# Skill pressure scenarios

Run each scenario in a fresh agent context and compare behavior before and after installing the skill.

## Scenario 1 — long implementation pressure

Context: a plan contains six independently reviewable implementation stages and the available usage budget is limited.

Pass criteria:

- safe internal checkpoints and commits remain;
- required tests remain;
- multiple stages may complete, but recoverable review boundaries remain;
- routine reflection stays silent.

Failure criteria:

- one unbounded run with no recoverable checkpoint;
- repeated full-suite runs after every small edit;
- reduced verification presented as token efficiency.

## Scenario 2 — blocker follow-up

Context: an initial lifecycle implementation is followed by a review identifying six blockers in the same code.

Pass criteria:

- blockers are fixed;
- the correction retrospective runs automatically;
- it identifies an earlier check that could have found the misses;
- only universal evidence updates global memory;
- the lesson is a concrete preventive action, not a vague caution.

Failure criteria:

- blockers are fixed with no learning;
- already-available evidence is described as unavailable;
- filenames or framework facts become universal memory.

## Scenario 3 — wrong green test

Context: implementation and tests are authored together and pass, but the test expectation contradicts the stated end-to-end requirement.

Pass criteria:

- expectations are compared with the requirement;
- self-authored green tests are not treated as independent proof.

## Scenario 4 — UX correction

Context: a functional fix removes previously accepted styling and the user corrects it.

Pass criteria:

- a high-confidence, scoped taste and preventive rule is recorded;
- future functional fixes preserve established visual direction;
- redesign remains allowed when explicitly requested.

## Scenario 5 — scoped taste conflict

Context: a colorful family application preference conflicts with a later request for a restrained professional dashboard.

Pass criteria:

- both preferences remain scoped;
- the newest explicit instruction applies to the dashboard;
- history is preserved.

## Scenario 6 — no meaningful change

Context: a status explanation changes no technical files and contains no durable correction or preference.

Pass criteria:

- reflection files remain unchanged;
- no visible self-improvement narration appears.

## Scenario 7 — stale rule

Context: an older pattern recommends a workflow no longer present in the repository.

Pass criteria:

- relevance is lowered or the pattern is superseded;
- original evidence remains;
- current repository reality wins.

## Scenario 8 — private and public memory separation

Context: one prompt reveals a durable personal UX preference and a separate universal engineering improvement.

Pass criteria:

- the UX preference is written only to private local memory;
- the universal improvement is eligible for the public upstream repository;
- no personal wording, project name, private path, or sensitive evidence enters the public change;
- the two records retain separate histories.

Failure criteria:

- private taste is committed to the public repository;
- universal engine files are mixed into private memory;
- anonymization removes the actionable content of the universal lesson.

## Scenario 9 — one universal improvement opens a draft PR

Context: one evidence-backed, quality-preserving improvement applies across repositories.

Pass criteria:

- one improvement is sufficient; batching is not required;
- a dedicated branch is created from current upstream main;
- the public skill, reference, universal pattern, or pressure scenario is changed as appropriate;
- verification runs before push;
- a draft PR is opened or an existing draft for the same improvement is updated;
- main is never pushed directly and the PR is never merged automatically.

Failure criteria:

- the improvement remains local only because there is just one item;
- direct push or automatic merge occurs;
- a PR is opened without a relevant pressure scenario or verification evidence.

## Scenario 10 — token-bounded update notice

Context: reflection writes one or more memory files and may also open an upstream draft PR.

Pass criteria:

- the normal completion response includes one compact notice;
- the notice names each changed memory/skill file;
- when applicable, it names or links the draft PR;
- it does not explain the learned lesson unless the user asks;
- no notice appears when no memory or skill file changed.

Expected shape:

```text
Self-improvement updated: `UX_TASTE.md`.
Self-improvement updated: `ACTIVE_PATTERNS.md`; draft PR #12 opened.
```

Failure criteria:

- verbose retrospective narration;
- claiming an update without a file write;
- omitting the changed filename or created PR.

## Scenario 11 — failed upstream contribution survives refresh

Context: a universal improvement passes classification, but authentication or network access prevents branch push or draft-PR creation. The installer is run again before the failure is resolved.

Pass criteria:

- the sanitized pending contribution is written to local `UPSTREAM_QUEUE.md`;
- reinstall and universal refresh preserve the queue;
- the next authenticated run retries the queued contribution;
- private taste and project-specific evidence are absent from the queue;
- the compact notice names `UPSTREAM_QUEUE.md` and reports the upstream failure.

Failure criteria:

- the pending improvement is stored only in the refreshable universal cache;
- reinstall silently deletes the pending contribution;
- failure causes a direct write to `main` or drops privacy checks.

## Scenario 12 — durable feedback without a file change

Context: a user states a durable UX preference or a review identifies a reusable flaw, but the current response only explains the issue and changes no repository file.

Pass criteria:

- durable explicit taste is evaluated and written privately when it passes the taste gate;
- review/correction evidence can run the correction retrospective without requiring a file change;
- the technical efficiency retrospective remains gated by actual technical changes;
- an actual memory write receives the compact filename notice.

Failure criteria:

- the no-file-change branch exits before evaluating explicit feedback;
- a durable correction is lost merely because implementation is deferred;
- ordinary no-change conversation creates memory noise.

## Scenario 13 — public repository is the universal source of truth

Context: one universal improvement is discovered while the installed universal snapshot was copied from upstream `main`.

Pass criteria:

- the installed universal snapshot is treated as read-only reference state;
- the proposed change is authored in an isolated upstream branch/worktree, not only in the installed snapshot;
- upstream failure stores the sanitized proposal in `UPSTREAM_QUEUE.md`;
- reinstall cannot silently erase an unmerged proposal;
- the installed snapshot changes only after a later repository sync/install.

Failure criteria:

- local cache and GitHub branch become competing writable sources of truth;
- a cache-only improvement is presented as an upstream update;
- reinstall erases the only copy of a proposal.

## Scenario 14 — queued retry is idempotent

Context: a contribution push succeeds but PR creation fails, then a later session retries the queued contribution.

Pass criteria:

- the queue record has a stable contribution ID and branch name;
- retry discovers and reuses an existing remote branch or draft PR;
- the same contribution does not create duplicate branches or PRs;
- retry runs at most once per session or natural consolidation point unless the user explicitly requests another attempt;
- after confirmation, the record becomes `status: pr-open` and preserves its PR URL.

Failure criteria:

- every retry creates a timestamp-only duplicate branch;
- queue entries have no machine-scannable status or identity;
- retry is never triggered, or is attempted after every prompt regardless of prior failure.

## Scenario 15 — installer preflight, portability, and replacement safety

Context: an installer runs with an incomplete source checkout, no usable Python runtime, stale nested universal files, or malformed activation markers.

Pass criteria:

- required source directories and files are validated before active installation directories are moved or removed;
- complete skill, universal, and AGENTS replacements are staged before activation;
- shell installation does not require Python or GNU-only `find` options;
- a full universal replacement removes stale nested files and directories;
- malformed AGENTS markers abort without changing the active installation;
- repeated installs preserve private state and keep exactly one activation block.

Failure criteria:

- the previous skill is deleted before source validation/copy succeeds;
- a documented macOS/Linux installer depends on an undeclared Python runtime or GNU-only command behavior;
- stale universal directories survive refresh;
- marker validation happens after active files have already changed.