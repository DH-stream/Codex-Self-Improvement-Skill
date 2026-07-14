# Friendly README and Brand Kit Design

> **Status:** Approved.

## Goal

Turn the repository README into a friendly open-source landing page that explains the value in under 30 seconds and makes installation effortless.

## Visual direction

- Bright mint and sky-blue palette.
- Friendly learning-bot mascot with a notebook or subtle Git branch.
- Clean vector-like illustrations; no cyberpunk or enterprise styling.
- Rounded cards, soft shadows, and plenty of white space.
- English copy throughout.
- Images support the story, but all essential information remains readable as text.

## Brand kit

Create and commit:

```text
assets/brand/hero.png
assets/brand/bot-mark.png
assets/brand/privacy-memory.png
assets/brand/workflow.png
```

The approved concept image is only a style reference. Final graphics should avoid embedded body copy so text stays sharp and accessible in Markdown.

## README structure

1. Hero illustration, project name, one-line promise, short pitch, and truthful badges.
2. Quick Install with two visible fenced code blocks: macOS/Linux and Windows PowerShell.
3. Why this exists.
4. Friendly feature overview.
5. Work → Reflect → Classify → Verify → Draft PR.
6. Private vs universal learning.
7. Safety and control.
8. Architecture and repository map.
9. Advanced installation and configuration.
10. Verification status, contributing, and project status.

Recommended hero line:

> **A self-improving Codex skill that learns from real work—without leaking what makes your setup personal.**

Avoid claims such as “never repeats a mistake,” “fully autonomous,” or “production proven.”

## Quick Install

The README must show two immediately copyable one-liners:

```bash
curl -fsSL https://raw.githubusercontent.com/DH-stream/Codex-Self-Improvement-Skill/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/DH-stream/Codex-Self-Improvement-Skill/main/install.ps1 | iex
```

The current installers expect a local checkout, so implementation must add a safe streamed bootstrap before advertising these commands:

- use a supplied valid `UPSTREAM_LOCATION`, or create/reuse a persistent Git checkout under the Codex state directory;
- clone fresh checkouts into a temporary path, validate required files, then move them into place;
- update existing managed checkouts with a fast-forward-only pull;
- invoke the bundled local installer only after bootstrap validation succeeds;
- preserve the active installation when download, Git, or validation fails;
- keep local clone-based installation working unchanged;
- cover streamed success and failure paths with isolated regression tests.

A note near the commands must state:

> Your personal preferences stay local. Universal improvements are proposed as draft PRs. Nothing is merged automatically.

## Safety and truthfulness

- No direct push to `main`.
- No automatic merge, approval, or ready-for-review transition.
- Private memory never enters public branches or PRs.
- Quality and verification are never traded for token savings.
- Disclose unexecuted PowerShell and authenticated GitHub end-to-end gates.
- Do not show a license badge until a `LICENSE` file exists.

## GitHub constraints

- Standard GitHub Markdown only; no JavaScript or custom CSS.
- Repository-relative images with concise alt text.
- Fenced code blocks for copy buttons.
- Mermaid only for editable text-backed diagrams.
- Mobile-readable tables and heading hierarchy.

## Delivery

Work stays on `readme/friendly-open-source-launch` and may update:

```text
README.md
assets/brand/*
install.sh
install.ps1
tests/test-install.sh
tests/test-install.ps1
docs/superpowers/plans/*
```

Before opening a PR, test every advertised command, inspect the full diff against current `main`, verify image paths and cropping, and confirm no private/user-specific data appears in copy, assets, or metadata.
