# Recurring mistakes

## mistake-001 — Self-authored tests treated as independent verification

- Trigger condition: tests and implementation are created in the same change.
- Failure mode: expectations repeat the implementation's assumption instead of the requirement.
- Detection rule: compare each new expectation with the stated end-to-end invariant.

## mistake-002 — Narrative reviewed instead of the complete code path

- Trigger condition: a detailed report and passing tests create high confidence.
- Failure mode: review stops at narrative or diff snippets and misses interactions with the base or complete files.
- Detection rule: include target-branch comparison and complete load-bearing files in the evidence set.

## mistake-003 — Functional correction regresses accepted visuals

- Trigger condition: behavior is broken while the existing styling is already approved.
- Failure mode: the visual layer is replaced or simplified during logic changes.
- Detection rule: preserve the accepted visual contract and compare before/after appearance.
