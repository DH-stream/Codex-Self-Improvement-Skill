# Baseline observations (RED)

These are observed failures before this skill existed, plus structural gaps found while evolving the initial version.

## Baseline A — unbounded agent work

A SOL implementation ran for roughly four hours and consumed two usage resets before reaching an independent review checkpoint.

Observed failure:

- too much work was bundled into one run;
- no cheap review boundary protected the remaining usage budget;
- the final state arrived too late for incremental correction.

Desired behavior:

- identify independently reviewable stages;
- finish, verify, commit, and stop at a stage boundary;
- retain full final verification after all stages.

## Baseline B — green tests around wrong runtime contracts

An implementation added canonical lifecycle state and many tests. A later independent review found several blockers:

- persisted state was not used to verify real runtime state;
- asynchronous success handling rejected legitimate forward progress;
- destructive messages lacked exact authority;
- launch and step semantics were conflated;
- a stale surface could commit after terminal or navigation progress.

Some tests passed because they encoded the implementation's behavior rather than the intended end-to-end contract.

Desired behavior:

- compare new expectations with the requirement;
- inspect complete affected paths across asynchronous boundaries;
- ask what evidence was available during the original implementation;
- create a reusable preventive check.

## Baseline C — visual regressions during functional fixes

Repeated user feedback across UI projects showed that functional fixes sometimes removed established styling or replaced a good visual design with a technically working but visually poorer version.

Desired behavior:

- treat established visual direction as a contract;
- fix behavior without silent restyling;
- learn explicit UX corrections privately with scope.

## Baseline D — initial public/private storage gap

Inspection of the first skill version showed that public seed memory contained actual user-specific UX preferences and that the engine had no contract for proposing universal improvements back to its GitHub repository.

Observed failure:

- private taste and universal engine data shared one storage concept;
- a universal improvement could update local memory but had no automatic upstream contribution path;
- the visibility contract was either silent or lesson-heavy rather than a fixed, token-bounded file notice.

Desired behavior:

- keep personal taste and private evidence exclusively local;
- keep the GitHub repository limited to universal engine, schema, tests, and universal patterns;
- allow one qualified universal improvement to open a verified draft PR automatically;
- report only changed filenames and the draft PR reference unless more detail is requested.

## Baseline E — pending upstream work stored in refreshable cache

Review of the split-storage installer found that upstream failure initially fell back to universal `CANDIDATES.md`, while reinstall intentionally replaced universal cache files from the repository.

Observed failure:

- a sanitized but not-yet-pushed contribution could be erased by reinstall;
- the fallback location did not match its required persistence lifetime.

Desired behavior:

- store pending upstream contributions in local `UPSTREAM_QUEUE.md`;
- preserve that queue across reinstall and universal refresh;
- retry it when upstream access becomes available.

## Baseline F — no-change gate discarded durable feedback

Review of the automatic trigger showed that it checked technical file changes first and stopped immediately when none existed.

Observed failure:

- an explicit durable UX preference could be lost when the response changed no code;
- a review-only blocker prompt could not create correction evidence until implementation happened;
- the skill description promised feedback learning that the trigger could bypass.

Desired behavior:

- evaluate explicit preference and correction signals independently of file changes;
- keep technical efficiency reflection gated by actual technical changes;
- preserve the no-noise behavior for ordinary conversation.

## Baseline G — two writable universal sources

The first split-storage contract allowed a universal improvement to be written under installed `UNIVERSAL_LOCATION` and also proposed through a separate upstream branch.

Observed failure:

- the installed snapshot and GitHub branch could diverge;
- reinstall could overwrite a cache-only improvement before merge;
- a local cache write could be mistaken for a successful upstream update.

Desired behavior:

- treat the public repository branch as the only writable universal source;
- treat installed universal state as a read-only snapshot of upstream `main`;
- queue a sanitized proposal locally when upstream contribution is blocked.

## Baseline H — retry identity was underspecified

The retry contract said to update an existing draft when possible, but queue records had no stable identity, branch, or retry metadata.

Observed failure:

- timestamp-only branch names could create duplicates after partial failure;
- a pushed branch with failed PR creation could be recreated instead of reused;
- “retry later” had no bounded automatic trigger.

Desired behavior:

- assign a stable contribution ID and deterministic branch name;
- record status, base SHA, branch, attempts, and last retry;
- retry once per session or natural consolidation point and reuse existing remote state.

## Baseline I — installer changed active state before proving replacement

Executable RED tests against the shell installer exposed three failures:

```text
missing source preserves existing install: FAIL
shell installer has no Python runtime dependency: FAIL
universal refresh removes stale directories: FAIL
```

Observed failure:

- the active skill directory was deleted before source validation and copy completed;
- the documented macOS/Linux path depended on `python3` without declaring it;
- universal refresh deleted only top-level files and left stale nested directories.

Desired behavior:

- validate all source inputs and stage complete replacements first;
- use shell tools available in the documented environment without an undeclared Python dependency;
- replace the universal snapshot as a complete directory;
- reject malformed activation markers before changing active installation files.

## Baseline J — subagent orchestration added avoidable latency

Repeated plan execution through one worker subagent plus one reviewer per routine task made straightforward sequential repository work take substantially longer than inline execution.

Observed failure:

- each small task paid a fresh context-transfer cost;
- review happened repeatedly before an integrated diff existed;
- the orchestration method became the default even when no work could run independently;
- the user's explicit preference for a faster workflow was not represented in the skill.

Desired behavior:

- keep one primary agent working inline when no safe parallel width exists;
- use natural tested checkpoints rather than a new agent boundary for every task;
- dispatch specialist reviewers only when risk or independent judgment justifies them;
- perform integrated review against the current base.

## Baseline K — task numbering caused avoidable serial execution

A multi-task implementation plan contained a contract task followed by two independent implementation domains, then later integration tasks. The execution workflow treated the numbered list as a strict sequence and ran one coding agent at a time without first classifying dependencies or file ownership.

Observed failure:

- no task dependency graph or shared-file analysis was produced;
- independent generator and runtime work waited for each other unnecessarily;
- isolated worktrees and bounded parallel waves were not considered;
- the correction for excessive subagent overhead had overfit toward serial execution;
- wall-clock efficiency depended on the plan author manually requesting parallelism.

Desired behavior:

- review the complete plan topology before implementation;
- distinguish true dependencies from task numbering;
- run ready tasks with disjoint write ownership concurrently in isolated worktrees;
- keep one integration owner for the feature branch and shared files;
- integrate in dependency order and verify each combined wave;
- retain inline execution when parallel width is absent or coordination cost exceeds the ready work.
