# User taste learning contract

## Scope

UX, UI, design, color, copy, interaction, animation, information density, imagery, and visual polish.

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
scope: universal | product-type | project | medium
status: provisional | confirmed | low-relevance | superseded
confidence: low | medium | high
source: explicit-correction | explicit-preference | repeated-choice | inference
first_observed: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
```

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
- Scoped preferences never silently become universal.
- A functional fix preserves accepted visual direction unless redesign is requested.
- Stored taste represents the user's choices, not an agent's aesthetic opinion.
- Personal or sensitive facts are excluded when they are not necessary to express the preference.
- Old and conflicting preferences move to history with low relevance or superseded status; they are not deleted.
- Only relevant taste categories are loaded for a visual task.

## Correction record

```text
wrong_visual_decision
source_of_decision: explicit | inferred | accidental-regression
future_observable_choice
safe_scope
```

Only the resulting durable, scoped preference is written to active memory.
