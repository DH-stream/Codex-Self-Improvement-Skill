# Post-prompt reflection contract

## Independent entry signals

Evaluate these signals separately:

```text
explicit_durable_feedback
current_prompt_reviews_or_corrects_prior_work
technical_files_changed
```

A prompt may trigger more than one signal. No technical file change disables only the technical efficiency retrospective; it must not discard explicit taste or correction evidence.

Technical files include code, tests, configuration, scripts, migrations, CI, agent instructions, and skills. Ordinary prose documentation counts only when it changes technical workflow.

## Inputs

```text
head_before
head_after
changed_files_before
changed_files_after
verification_evidence
explicit_feedback_evidence
correction_or_review_evidence
```

Do not run extra commands solely to manufacture reflection evidence.

## Feedback path

When `explicit_durable_feedback = true`, evaluate it through `taste-learning.md` or the applicable private workflow-preference schema. A durable explicit statement may update private memory even when no repository file changed.

When `current_prompt_reviews_or_corrects_prior_work = true`, run `correction-retrospective.md` even when implementation is deferred. The result still passes the normal write and privacy gates.

## Technical-change path

Run these questions only when `technical_files_changed = true`:

1. What materially changed?
2. Which action produced real evidence?
3. Which repeated action produced no new information?
4. Which smaller or earlier check could preserve the same quality?
5. Which memory class fits: universal pattern, private evidence, recurring mistake, engine gap, project fact, or no lesson?

## Classification

| Class | Storage action |
|---|---|
| Project fact | Keep project-local; no global write |
| One-off event | No write |
| Private observation | Write only under `PRIVATE_LOCATION` when durable |
| User taste | Apply the private taste-learning contract |
| Universal candidate/pattern | Author public-safe changes in an isolated upstream branch |
| Recurring universal mistake | Add public-safe evidence/check in the upstream branch |
| Engine gap | Add a pressure scenario and engine change in the upstream branch |
| Blocked universal contribution | Write a sanitized record to private `UPSTREAM_QUEUE.md` |

`UNIVERSAL_LOCATION` is a read-only installed snapshot. Do not write proposals there.

## Write gate

Any write must be concrete, reusable, correctly scoped, evidence-backed, behavior-changing, and quality-preserving.

A universal contribution additionally requires cross-repository applicability, safe anonymization without losing the action, and no personal, proprietary, secret, or project-specific dependency.

Otherwise the result is `no_write` or private-only storage.

## Upstream threshold and queue retry

One qualified universal improvement is enough; confirmation controls confidence, not eligibility for a draft PR. Follow `upstream-contribution.md`.

At session start or a natural consolidation point, inspect `UPSTREAM_QUEUE.md`. Retry pending entries at most once per session unless the user explicitly requests another attempt. Reuse their stable contribution ID and branch.

## Visibility

Routine reasoning remains silent. No write means no notice. Actual memory/skill writes use one compact line from `memory-schema.md`, naming changed files and any confirmed draft PR without explaining the lesson.