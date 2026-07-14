# Baseline observations (RED)

These are observed failures before this skill existed. They are the RED evidence for the first version.

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

- persisted navigation metadata was not used to verify the actual tab URL;
- successful async continuation required frozen identity and rejected legitimate forward progress;
- panel adoption had the same frozen-identity issue;
- content failure messages lacked exact reducer authority;
- launch and step destination semantics were conflated;
- a restricted surface could commit after terminal/navigation progress.

Some tests passed because they encoded the implementation's behavior rather than the intended end-to-end contract.

Desired behavior:

- compare new expectations with the requirement;
- inspect complete affected paths across await boundaries;
- ask what evidence was available during the original implementation;
- create a reusable preventive check.

## Baseline C — visual regressions during functional fixes

Repeated user feedback across UI projects showed that functional fixes sometimes removed established styling or replaced a good visual design with a technically working but visually poorer version.

Desired behavior:

- treat established visual direction as a contract;
- fix behavior without silent restyling;
- learn explicit UX corrections globally with scope.
