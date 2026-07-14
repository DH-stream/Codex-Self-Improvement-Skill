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

Context: a status explanation changes no technical files.

Pass criteria:

- reflection files remain unchanged;
- no visible self-improvement narration appears.

## Scenario 7 — stale rule

Context: an older pattern recommends a workflow no longer present in the repository.

Pass criteria:

- relevance is lowered or the pattern is superseded;
- original evidence remains;
- current repository reality wins.
