# User taste learning contract

## Scope

UX, UI, design, color, copy, interaction, animation, information density, imagery, and visual polish.

Taste memory is personal. Write it only under `PRIVATE_LOCATION`. Never commit, push, quote, or summarize private taste in an upstream branch or PR.

## Evidence hierarchy

1. Explicit correction.
2. Explicit durable preference.
3. Independent repeated acceptance or choice.
4. Repeated implicit selection.
5. Agent inference.

A single unconfirmed inference does not become active taste memory.

## Taste record

```yaml
id: taste-NNN
preference: concise statement
scope: universal-to-user | product-type | project | medium
status: provisional | confirmed | low-relevance | superseded
confidence: low | medium | high
source: explicit-correction | explicit-preference | repeated-choice | inference
first_observed: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
```

`universal-to-user` means the preference may apply across that user's projects; it does not mean public or universal across users.

Required text fields:

```text
Apply when
Do not overgeneralize
Evidence
Conflicts
Relevance history
```

## Rules

- The latest explicit instruction wins within matching scope.
- Scoped preferences never silently broaden.
- A functional fix preserves accepted visual direction unless redesign is requested.
- Stored taste represents the user's choices, not an agent's aesthetic opinion.
- Store only the minimum evidence needed to apply the preference.
- Personal or sensitive facts are excluded when they are not necessary to express the preference.
- Old and conflicting preferences move to private history with low relevance or superseded status; they are not deleted.
- Only relevant taste categories are loaded for a visual task.
- Never use taste evidence as public support for a universal engineering pattern.

## Correction record

```text
wrong_visual_decision
source_of_decision: explicit | inferred | accidental-regression
future_observable_choice
safe_scope
```

Only the resulting durable, scoped preference is written to private active memory.

## Visibility

When a taste file actually changes, follow the compact notice in `memory-schema.md`: name the changed file and do not explain the learned preference unless asked.
