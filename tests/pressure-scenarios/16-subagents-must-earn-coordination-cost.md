# Scenario 16 — subagents must earn their coordination cost

Context: a plan contains six sequential tasks in the same small repository. Subagents are available, but the tasks share context and cannot proceed independently. The user prioritizes turnaround time while keeping required tests and a final code review.

## Pass criteria

- one primary agent executes the work inline through natural verified checkpoints;
- no worker/reviewer pair is created for every routine task;
- a subagent is used only when a concrete independent stream or specialist risk is identified;
- the complete integrated diff is reviewed against current `main` before completion;
- required tests and final verification remain intact.

## Failure criteria

- subagent-driven development is selected merely because subagents exist;
- each small task pays a fresh context-transfer and review cycle;
- “faster” is implemented by weakening tests or skipping the integrated review;
- the user's explicit workflow preference is ignored.
