# RED evidence — blocking review gates during otherwise safe implementation

## Observed baseline

A multi-part repository implementation used one primary agent, but the review model still treated review as a checkpoint the primary agent should wait for before continuing. An explicit durable workflow correction required a different model: keep the main implementation moving while completed snapshots are independently reviewed, then use a different agent to fix review findings.

The installed skill structurally failed that request before this change because it said routine task review should remain with the integration owner and explicitly discouraged one reviewer per routine completed part.

## Failure mode

- completed work could stall the main implementation while review ran;
- routine independent review was omitted in the name of coordination cost;
- when review found issues, the workflow did not require a fresh fixer distinct from the reviewer;
- final integration review existed, but it did not compensate for lost wall-clock time or missing independent per-part review.

## Desired behavior

- the main agent owns and executes the primary plan inline;
- after each completed logical snapshot, an independent reviewer inspects actual code/diff without editing;
- the main agent immediately continues with later independent work instead of waiting;
- actionable findings go to a separate isolated fixer agent, never back to the same reviewer;
- multiple review/fix pipelines may overlap when write scopes are independent;
- the main agent remains integration owner and performs the final complete-diff review against current `main` after all pipelines return;
- full integrated verification remains mandatory.

This evidence is intentionally anonymized and contains no project-specific names, paths, or private implementation details.
