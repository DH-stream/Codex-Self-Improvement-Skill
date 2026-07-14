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
