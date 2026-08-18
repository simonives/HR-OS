# hr-os v1.0.0: hardening and release

**Status:** approved design, pending implementation plan
**Builds on:** `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md` (architecture), `docs/superpowers/specs/2026-08-18-hr-os-operating-model-alignment.md` (roadmap grounding)

## Purpose

The hr-os plugin MVP (four gate skills + `hr-os-workforce-planning`) is built, task-reviewed, and whole-branch-reviewed — merged to `main` as of PR #1. It has never been tested live: every walkthrough during the build was a controller-dispatched subagent writing a report, not the actual plugin installed and invoked inside a real Claude Code session. v1.0.0 is the point where that changes — the release that says "this pattern works, end to end, for real," not "the roadmap is complete." No new domain workflow is in scope for v1.0.0.

## Scope

**In scope:** hardening the existing five skills against real usage, fixing whatever live testing surfaces, tagging `v1.0.0`, and (separately, later) submitting to `claude-plugins-official`.

**Explicitly out of scope:** any new domain workflow (Managing Underperformance is the confirmed next one — see Roadmap below, not this release), any provider beyond Claude Code/Cowork, any audit/logging infrastructure (still deferred per the original design spec).

## Hardening work

### 1. Manual install and discovery verification (carried over from the original plan's outstanding Task 7 step)

In a real Claude Code session, in this repo:
```
/plugin marketplace add ./.claude-plugin/marketplace.json
/plugin install hr-os
```
Confirm all five skills (`hr-os-problem-framing`, `hr-os-success-criteria-first`, `hr-os-calibration-and-consultation`, `hr-os-outcome-verification`, `hr-os-workforce-planning`) appear in the session's available-skills listing.

### 2. Live scenario 1 — a genuinely new scenario, happy path

Every walkthrough during the build used the same scenario (two Operations Supervisor roles, FY27 budget freeze). Run `hr-os-workforce-planning` live against a **different** scenario — different demand type (e.g. variable/unpredictable rather than the build scenario's steady-state gap), different complexity rating (aim for Complex or Chaotic, not Complicated, to exercise a depth-table row never actually walked through live) — end to end, confirming both human-approval hard-gates actually stop and wait rather than merely being described as stopping.

### 3. Live scenario 2 — an explicit reject path

The final whole-branch review flagged that none of the four gate skills describe what happens when the answer is *no* — a human declines approval, a reviewer withholds sign-off outright (not just conditionally, as Amendment 2 already handles), or an outcome genuinely doesn't match the decision. Run a live scenario where you deliberately decline approval at one of the two human-approval gates (or where `hr-os-outcome-verification` finds a genuine mismatch, not just an unclosed condition) and observe what the skill actually does.

**If the skill has no sensible behaviour for this** (stalls, contradicts itself, or silently proceeds anyway), that is a real defect — fix the affected skill(s) with explicit "when this gate fails" guidance before v1.0.0, not after. If the skill already degrades sensibly (e.g. naturally stops and asks what to do next, consistent with the HARD-GATE language already present), record that as confirmed-sound and no change is needed — do not add guidance for a case testing already shows is handled.

### 4. Any other gap live testing surfaces

Testing may turn up issues neither of the above anticipated. Fix them before tagging, using judgement on scope — a real defect in the shipped skills blocks the release; a nice-to-have observation gets logged to the roadmap instead.

## Release process — two gates, both yours

This release does not auto-progress on its own. Two separate human confirmations are required, and the second does not follow automatically from the first:

**Gate A — tag `v1.0.0`.** After hardening work is complete and all tests pass (the original build-time walkthroughs, plus the two live scenarios above, plus anything else surfaced and fixed), you confirm the repo is release-ready. Only then: bump `.claude-plugin/plugin.json` and `marketplace.json` versions from `0.1.0` to `1.0.0`, tag the commit `v1.0.0`, push the tag. At this point the plugin is installable via the self-hosted marketplace for you (and anyone you point at the repo URL) across Claude Code and Cowork — this is a real release, not a placeholder.

**Gate B — submit to `claude-plugins-official`.** Separately, and only when you confirm the plugin is fit for public use and publication, prepare and submit the official marketplace listing (per the submission process: `https://clau.de/plugin-directory-submission`, consistent versioning, a security review pass). Gate B may happen well after Gate A, or not at all if you decide not to pursue official listing — that decision stays open regardless of whether Gate A has happened.

## Roadmap (post-v1.0.0)

Captured now so v1.0.0 doesn't read as a dead end, not committed to a timeline. The exhaustive, ongoing-reference version of this roadmap lives in GitHub, not in this document, so this section is a curated top-level summary, kept short deliberately so it doesn't go stale the way a long inline list would:

- **GitHub Project:** [hr-os Roadmap](https://github.com/users/simonives/projects/8), every backlog item as a board, one item per distinct capability area (drawn from the operating-model alignment analysis), labelled by hr-os domain (`domain:*`) and status (`status:shipped` / `status:next` / `status:backlog`).
- **GitHub Issues:** [simonives/hr-os issues](https://github.com/simonives/hr-os/issues), one issue per roadmap item, 34 created at v1.0.0 planning time (one already closed as shipped: strategic workforce planning, delivered as `hr-os-workforce-planning`).

Top priorities, for orientation (see the board for the full, current list):

1. **Managing Underperformance, confirmed next domain workflow** (`status:next`, issue: "Performance & conduct: structured investigation"). Per the operating-model alignment analysis, its real-world structure (establish framework, identify underperformance, determine and execute action) maps almost directly onto `problem-framing` then `structured-investigation` then `calibration-and-consultation`, and it's the only designed gate skill (`hr-os-structured-investigation`) with no workflow using it yet. Gets its own brainstorming, spec, and plan cycle when taken up, not scoped here.
2. **Governance-as-peer-domain decision** (Gap 1 in the alignment doc; issue: "Policy design & evidence-based governance"), resolve when a governance-adjacent workflow is actually taken up, not before.
3. **Employee-experience diffused-vs-standalone decision** (Gap 2 in the alignment doc; issue: "Culture & engagement programme design"), same treatment, resolve when load-bearing.
4. **Populate `resources/business_partnering/workforce_planning/` reference content**, closes the content gap flagged during the v1.0.0 build, using the Calibre-library and research-MCP grounding pipeline now documented in `CLAUDE.md`.
5. **Cross-provider port (OpenAI, DeepSeek, etc.)** stays a non-goal until there's an actual reason to port; the skill content is written to be portable in principle (per the original plugin design spec), but no port work is planned. Not tracked as a board item since it isn't a domain-workflow candidate.
6. **Official-marketplace readiness checklist** (informs Gate B, not required for Gate A): consistent versioning across releases; README and both manifest files accurate and current; no placeholder/pending content visibly shipped without intentional framing; a security review pass per the submission process's stated bar.

## Explicitly not done here

- No new domain workflow.
- No audit/logging infrastructure.
- No decision on the two flagged taxonomy gaps — deliberately deferred to roadmap items 2-3.
- No commitment to pursue Gate B at all, only a description of what it requires if pursued.
