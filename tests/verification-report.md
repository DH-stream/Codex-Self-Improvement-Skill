# Verification report — friendly README and streamed installers

Date: 2026-07-14

## Scope reviewed

- Compared branch `readme/friendly-open-source-launch` against current `main` at `228160a3da536b557e29436c539896b774b39817`.
- Reviewed the actual branch versions of `install.sh`, `install.ps1`, both installer test runners, `README.md`, the skill/invariant changes, universal memory updates, and all four brand assets.
- The implementation review was performed through branch head `a791470386c94c54f4ee3b88b99dd7fb7a25245a` before this report was added.

## RED/GREEN evidence

The streamed Bash tests were observed failing before bootstrap support existed:

```text
Installer tests: 6 passed, 2 failed
```

A later repository-retargeting test was also observed failing before origin replacement was implemented:

```text
Installer tests: 8 passed, 1 failed
```

After implementation, the complete Bash suite produced:

```text
Installer tests: 9 passed, 0 failed
```

## Fresh executable verification

Commands run in the isolated local fixture:

```bash
bash -n install.sh
bash -n tests/test-install.sh
bash tests/test-install.sh
```

Result: shell syntax passed and all nine installer regressions passed. The suite covers local preflight safety, no Python dependency, complete universal refresh, private-state preservation, malformed activation markers, streamed fresh install, failed-bootstrap preservation, streamed refresh, and repository retargeting.

## PowerShell verification

`install.ps1` and `tests/test-install.ps1` were reviewed as complete files against `main`. Lightweight lexical/static checks passed for balanced delimiters, here-strings, required bootstrap functions, persistent-checkout paths, fast-forward pulls, and repository overrides.

A PowerShell runtime was not available in the execution environment, so the PowerShell regression runner was not executed. Windows PowerShell execution remains a release gate.

## Skill and behavior verification

- `SKILL.md`: valid frontmatter, 476 words, and all 5 required references present.
- Universal execution policy: one primary agent inline by default; subagents only for justified independent parallel work or specialist risk.
- Pressure coverage: 15 original scenarios plus the dedicated Scenario 16 file for subagent coordination cost.
- Public/private separation and no-auto-merge invariants remain intact.

## README and brand verification

- Both requested one-line install commands are separate fenced code blocks.
- All repository-relative README links and four brand asset paths resolve.
- `hero.svg`, `bot-mark.svg`, `privacy-memory.svg`, and `workflow.svg` parse as valid XML/SVG.
- Local raster previews were rendered and inspected at 1600×620, 512×512, 1500×440, and 1600×420.
- Assets contain no third-party logos, private user data, or embedded metadata.
- README claims were checked against the actual installers and current branch files.

## Review findings corrected before PR

- Corrected the README test count from eight to nine.
- Used repository-local SVG assets for crisp GitHub rendering while retaining locally rendered PNG previews for visual inspection.
- Added repository-origin retargeting coverage so `UPSTREAM_REPOSITORY` does not silently keep an older managed checkout.
- Kept the single-agent default explicit in `CORE.md`, `AGENTS.md`, `SKILL.md`, universal patterns, baseline evidence, and a pressure scenario.

## Remaining external gates

- Execute `tests/test-install.ps1` in a real Windows PowerShell environment.
- Run fresh-agent pressure scenarios with and without the installed skill.
- Prove authenticated end-to-end upstream branch discovery, push, partial-failure retry, and draft-PR creation.
