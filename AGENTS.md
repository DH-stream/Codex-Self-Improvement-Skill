# Repository agent instructions

1. Read `CORE.md` first.
2. For skill or procedure changes, use `superpowers:writing-skills`.
3. For multi-step changes, use `superpowers:writing-plans`.
4. Treat `tests/baseline-observations.md` as RED evidence and update relevant pressure scenarios before behavior changes.
5. For installer changes, add or update `tests/test-install.sh`, observe the relevant RED failure, then run it GREEN.
6. Keep `skills/codex-self-improvement/SKILL.md` compact; move detail to `references/`.
7. Never overwrite or delete learned evidence; append history and change relevance/status instead.
8. Public repository files may contain only universal, anonymized, quality-preserving knowledge and neutral private templates.
9. Personal taste and private evidence belong only under installed `PRIVATE_LOCATION`; never add them to this repository.
10. Treat installed `UNIVERSAL_LOCATION` as read-only. Author universal changes only in isolated upstream branches/worktrees from current remote `main`.
11. Evaluate explicit durable feedback and correction/review signals even when the prompt changes no file; technical efficiency reflection still requires a technical change.
12. Queue retries use stable contribution IDs and deterministic branches, reuse existing PR state, and run at most once per session or natural consolidation point.
13. A user correction or blocker follow-up requires the correction retrospective.
14. Never push directly to `main`, merge automatically, approve automatically, or mark an automatic self-update ready for review.
15. Do not weaken quality gates to optimize tokens.
16. Review actual files and the complete diff against `main`, not only plans, reports, or PR descriptions.
17. Update public `memory/UPDATE_LOG.md` for material engine, universal-memory, installer, or schema changes.
18. After actual memory/skill writes, report only changed filename(s) and any confirmed draft PR reference unless the user asks for the lesson.