# Friendly README and Brand Kit Design

> **Status:** Approved design direction. Implementation begins only after user review of this written specification.

## Goal

Turn the repository landing page into a friendly, memorable open-source product page that makes the value of `codex-self-improvement` immediately understandable and makes installation effortless.

The result should feel inviting rather than corporate: a cheerful learning bot, mint and sky-blue colors, approachable language, strong visual hierarchy, and enough technical detail to earn developer trust.

## Audience

Primary readers are developers and Codex users who:

- want an agent to learn from corrections instead of repeating them;
- care about keeping personal preferences private;
- want universal improvements reviewed through GitHub rather than silently merged;
- prefer a fast installation path with clear safety boundaries.

A new visitor should understand the product in under 30 seconds and reach a copyable install command without scrolling through implementation details.

## Visual identity

### Direction

**Friendly open-source tool** rather than dark enterprise AI tooling.

The visual language uses:

- mint green and sky blue as primary colors;
- white or very pale backgrounds;
- rounded cards and soft shadows inside illustrations;
- a small friendly learning bot as the recognizable character;
- notebooks, checkmarks, Git branches, shields, sparkles, and memory cards as supporting symbols;
- clean vector-like illustration with no photorealism or cyberpunk styling.

### Character

The learning bot is curious, reliable, and helpful—not childish or overly mascot-driven. It may hold a notebook or interact with a small Git branch, but it should not dominate every section.

### Brand assets

Implementation will create and commit:

```text
assets/brand/hero.png
assets/brand/bot-mark.png
assets/brand/privacy-memory.png
assets/brand/workflow.png
```

Asset roles:

- `hero.png` — wide README banner with the bot and supporting visual cards; avoid critical text inside the image so copy stays sharp, accessible, and editable in Markdown.
- `bot-mark.png` — transparent square mascot/mark usable in the README, repository social preview, and future docs.
- `privacy-memory.png` — visual split between private local memory and public universal learning.
- `workflow.png` — friendly visual flow from work to reflection, learning, verification, and draft PR.

The previously approved concept image is a style reference only. Final assets must use correctly rendered copy or preferably no embedded body copy.

All images require concise alt text. The README must remain understandable when images are unavailable.

## README information architecture

The README will follow a landing-page-first structure:

1. **Hero**
   - wide illustration;
   - project name;
   - concise one-line promise;
   - short supporting sentence;
   - restrained badges that reflect real repository state only.

2. **Quick Install**
   - placed immediately after the hero pitch;
   - two separate fenced code blocks so GitHub displays a copy button;
   - macOS/Linux first, Windows PowerShell second;
   - one compact safety sentence below the blocks.

3. **Why this exists**
   - explain the problem in human language: agents repeat mistakes, lose preferences, and often confuse project facts with reusable lessons;
   - introduce the solution without beginning with implementation jargon.

4. **Feature overview**
   - friendly visual feature cards using a Markdown/HTML table that remains readable on mobile;
   - core benefits: learns from corrections, private taste stays local, universal improvements become draft PRs, quality gates remain intact, compact update notices.

5. **How it works**
   - workflow illustration followed by a concise five-stage explanation;
   - Work → Reflect → Classify → Verify → Draft PR.

6. **Private vs universal learning**
   - privacy-memory illustration;
   - a clear two-column comparison;
   - explicitly state that project-specific facts stay project-local.

7. **Safety and control**
   - no direct push to `main`;
   - no automatic merge, approval, or ready-for-review transition;
   - private memory never enters public branches or PRs;
   - verification limitations are disclosed;
   - quality checks are never traded for token savings.

8. **Architecture**
   - concise directory map;
   - Mermaid diagram for an editable, text-backed system overview;
   - link to `CORE.md`, skill references, pressure scenarios, and verification report.

9. **Advanced installation and configuration**
   - transparent clone-based installation;
   - environment and path overrides;
   - update/reinstall behavior;
   - local storage locations;
   - optional pinned-ref install example for users who do not want to execute the moving `main` branch.

10. **Verification status**
    - accurately summarize executable shell coverage;
    - clearly list remaining Windows and authenticated GitHub end-to-end gates;
    - avoid presenting unexecuted behavior as proven.

11. **Contributing and project status**
    - explain the draft-PR contribution model;
    - invite issues and improvements;
    - do not show a license badge or claim a license until a `LICENSE` file exists.

## Hero copy direction

The hero should sell the outcome, not the internal mechanism.

Recommended positioning:

> **A self-improving Codex skill that learns from real work—without leaking what makes your setup personal.**

Supporting copy should mention:

- corrections become better future behavior;
- personal preferences stay local;
- universal improvements become reviewable draft PRs.

Avoid exaggerated claims such as “never repeats a mistake,” “fully autonomous,” or “production proven.”

## Quick Install UX

The user explicitly selected two visible one-line install blocks.

Target commands:

```bash
curl -fsSL https://raw.githubusercontent.com/DH-stream/Codex-Self-Improvement-Skill/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/DH-stream/Codex-Self-Improvement-Skill/main/install.ps1 | iex
```

### Required implementation change

The current installers are local-repository installers and cannot safely assume their companion `skills/`, `memory/`, and `install/` directories exist when streamed from `raw.githubusercontent.com`.

Implementation must add a verified remote-bootstrap mode while preserving local installation.

When invoked without a valid repository directory, each installer will:

1. use `SELF_IMPROVEMENT_BOOTSTRAP_REF` when set, otherwise default to `main`;
2. download the matching GitHub repository archive into a newly created temporary directory;
3. validate the extracted `skills/codex-self-improvement`, `memory/private-template`, and `install/AGENTS-snippet.md` paths;
4. invoke the extracted local installer with the caller's configuration preserved;
5. clean the temporary directory on success or failure;
6. leave the active installation untouched when download, extraction, or validation fails.

The shell installer must support streamed execution without relying on `BASH_SOURCE[0]` being a repository file. The PowerShell installer must support `irm | iex` without relying on `$MyInvocation.MyCommand.Path` being a real file.

For deterministic isolated tests, both installers will accept `SELF_IMPROVEMENT_BOOTSTRAP_ARCHIVE` as an optional local archive path. This is a testing and advanced-use override; the normal one-liners download the GitHub archive.

The README must not advertise the one-liners until remote-bootstrap tests pass.

A brief transparent note will say that the one-liner downloads and runs the repository installer. The advanced section will provide clone-based and commit-pinned alternatives.

## Copy style

- English throughout the main README.
- Warm, direct, and confident.
- Short paragraphs and descriptive headings.
- Explain jargon when first used.
- Prefer benefits before internals.
- Use emoji sparingly; the illustrations provide most of the personality.
- Avoid walls of badges, excessive marketing language, and unsupported metrics.

## GitHub Markdown constraints

The design must work inside standard GitHub README rendering:

- no custom JavaScript or CSS;
- images use repository-relative paths;
- copyable commands use fenced code blocks;
- HTML tables may be used only where they remain readable on narrow screens;
- Mermaid provides a text-backed architecture diagram;
- heading hierarchy supports navigation and accessibility;
- no essential information exists only inside an image.

## Implementation branch and files

README and brand work will remain on:

```text
readme/friendly-open-source-launch
```

Expected changed files:

```text
README.md
assets/brand/hero.png
assets/brand/bot-mark.png
assets/brand/privacy-memory.png
assets/brand/workflow.png
install.sh
install.ps1
tests/test-install.sh
tests/test-install-remote.sh
tests/test-install-remote.ps1
docs/superpowers/specs/2026-07-14-friendly-readme-brand-design.md
docs/superpowers/plans/2026-07-14-friendly-readme-brand-plan.md
```

`tests/test-install-remote.sh` will execute the streamed shell path against a local fixture archive and verify success, cleanup, configuration forwarding, and failure atomicity.

`tests/test-install-remote.ps1` will express the equivalent Windows contract and will be executed when a PowerShell runtime is available. Until then, its unexecuted status must remain visible in the README verification section and PR.

The remote installer behavior is a functional change and must receive RED/GREEN coverage before README copy claims it works.

## Verification

Before opening the README PR:

- render-check the README structure and relative image paths;
- verify every advertised command exactly matches tested behavior;
- run shell syntax and local/remote installer regression tests;
- statically review and, when an appropriate runtime is available, execute PowerShell local/remote installation tests;
- verify remote failures leave existing installations untouched;
- verify temporary bootstrap directories are removed on success and failure;
- review actual code and full diff against current `main`;
- check that no private memory or user-specific evidence appears in assets, copy, or metadata;
- inspect generated images for spelling errors, illegible text, unwanted logos, and cropping on desktop/mobile widths;
- confirm badges and verification claims match repository evidence.

## Success criteria

The design succeeds when:

- a new visitor understands the value and privacy model within 30 seconds;
- both platforms have immediately visible copyable one-line commands;
- those commands are genuinely supported by tested bootstrap behavior;
- the README feels friendly and memorable without hiding technical limitations;
- private and universal learning are visually unmistakable;
- all claims remain accurate against the merged implementation;
- the brand assets can be reused for the repository social preview and future documentation.

## Out of scope

- a separate documentation website;
- animated GIF demos unless a later real workflow recording adds clear value;
- automatic merging of self-improvement PRs;
- claiming a software license before one is explicitly chosen and committed;
- redesigning the skill engine beyond changes required to make the advertised install flow truthful.