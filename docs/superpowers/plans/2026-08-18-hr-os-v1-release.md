# hr-os v1.0.0 Hardening and Release Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to work through this plan. Steps use checkbox (`- [ ]`) syntax for tracking. Unlike a typical implementation plan, several steps in this plan are executed by Simon directly in an interactive Claude Code session, not by a dispatched subagent, since no tool in this harness can run `/plugin` slash commands or install a Claude Code plugin. Those steps are marked **[HUMAN]** and the plan stops at each one for Simon's results before continuing.

**Goal:** Take hr-os from "merged and reviewed" to "proven live and tagged v1.0.0". Install it for real, run it against two scenarios the build-time walkthroughs never exercised, fix whatever that surfaces, then tag and (separately, later) submit to the official marketplace.

**Architecture:** No code changes to the skill files unless live testing finds a real defect. This plan prepares test materials, hands off execution to Simon (who has the only interactive Claude Code session that can install and invoke the plugin), then reacts to what testing finds.

**Tech Stack:** N/A, this is a testing and release plan, not a build plan.

**Spec:** `docs/superpowers/specs/2026-08-18-hr-os-v1-release.md`

## Global Constraints

- No new domain workflow in this plan (Managing Underperformance is next, tracked separately on the GitHub Project board, not scoped here).
- No audit/logging infrastructure.
- Version bump (`0.1.0` to `1.0.0` in `.claude-plugin/plugin.json` and `marketplace.json`) and git tag `v1.0.0` happen only after Simon's explicit Gate A confirmation (spec's "Release process" section), never before, never assumed.
- Official-marketplace submission (Gate B) is a separate future decision, entirely out of scope for this plan.
- Any fix made during hardening follows the same standard as the original build: no placeholders, matches the existing skills' HARD-GATE / red-flags-table / Output conventions, genericised (no source-organisation references).

---

## File Structure

No new files unless hardening finds a defect. If a defect is found, the fix lands in the affected file(s) under `skills/`, following the existing structure documented in `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md`.

---

### Task 1: Prepare the two live test scenario briefs

**Files:**
- Create: `docs/superpowers/plans/2026-08-18-hr-os-v1-test-scenarios.md`

**Interfaces:**
- Produces: a self-contained scenario document Simon reads directly when running Task 2 and Task 3 below. No other task consumes this file programmatically.

- [ ] **Step 1: Write the two scenario briefs**

Create `docs/superpowers/plans/2026-08-18-hr-os-v1-test-scenarios.md`:

```markdown
# hr-os v1.0.0 live test scenarios

Run these against the actual installed plugin, in order. Both use `hr-os-workforce-planning`. Neither scenario was used during the build (every build-time walkthrough used the same "two Operations Supervisor roles, budget freeze on new-to-org headcount" scenario), that repetition is exactly what these are checking for.

## Scenario A, new scenario, happy path, different demand type and complexity

Present this to Claude after installing hr-os and confirm the skill invokes:

> "A new product line launches in six months. Customer support needs additional capacity to handle it, but there's no dedicated team lead for this product line today, it would be new headcount, not a backfill. Demand is genuinely uncertain: could need anywhere from 2 to 8 additional support staff depending on adoption, and there's no existing capacity baseline for a product that doesn't exist yet. Multiple stakeholders have a stake in the sizing call: Product (adoption forecast), Finance (budget), and the support function's own leadership."

**What to check, stage by stage:**
1. Demand-signal capture: does it correctly classify demand type as unpredictable (not predictable/variable, given the explicit "2 to 8 depending on adoption" framing)? Does it flag the absence of a capacity baseline honestly (per its evidence hard-gate) rather than inventing one?
2. Complexity rating: does it land on Complex or Chaotic (multiple stakeholders, genuine uncertainty, no precedent) rather than defaulting to Clear or Complicated the way the build-time scenario did? This is the main thing this scenario is designed to test, the depth table's heavier rows were never exercised live during the build.
3. Workforce-plan gate: does it actually stop and wait for your explicit approval before proceeding (not just narrate that it would)?
4. Role design: does it check `resources/business_partnering/workforce_planning/` and correctly report that domain has no populated reference content yet (per Amendment 1), rather than fabricating grounding?
5. Budget/approval gate: given the Complex/Chaotic rating from step 2, does the review depth actually scale up (named reviewer plus documented rationale at minimum, full panel plus legal/compliance if it lands Chaotic) rather than applying the same depth as a Clear/Complicated case?
6. Requisition released: does it correctly check whether stage 4's approval was conditional (per Amendment 2) before declaring the outcome verified?

**Approve both gates when prompted**, to reach a complete run.

## Scenario B, explicit reject path

Run `hr-os-workforce-planning` again (a fresh case), any reasonable scenario is fine for this one, the point isn't the scenario content. When the workflow reaches the **workforce-plan gate** (stage 2, `hr-os-success-criteria-first`) and asks for your approval, **explicitly decline it** ("No, I don't approve this plan" or similar, not silence and not a conditional response).

**What to check:**
1. Does the skill have any sensible behaviour for this, or does it stall, contradict itself, or (worst case) proceed to role design anyway as if you'd approved?
2. Does it correctly stop the case rather than trying to route around the rejection?
3. Is there any guidance in the skill for what happens next (revise and resubmit? case closed? escalate?), or is this genuinely undescribed, as the final whole-branch review flagged?

**Do not approve this gate**, the point of this scenario is observing the decline path, not reaching completion.

## Reporting back

For each scenario, report: what stage you reached, what the skill actually did at each checkpoint above, and specifically call out anything that stalled, contradicted the skill's own stated behaviour, or proceeded when it shouldn't have. Plain description is enough, no specific format required.
```

- [ ] **Step 2: Commit**

```bash
git add docs/superpowers/plans/2026-08-18-hr-os-v1-test-scenarios.md
git commit -m "docs: add hr-os v1.0.0 live test scenario briefs"
```

---

### Task 2: [HUMAN] Manual install and discovery verification

**Not dispatchable.** Requires Simon's interactive Claude Code session.

- [ ] In a real Claude Code session, in this repo, run:
  ```
  /plugin marketplace add ./.claude-plugin/marketplace.json
  /plugin install hr-os
  ```
- [ ] Confirm all five skills (`hr-os-problem-framing`, `hr-os-success-criteria-first`, `hr-os-calibration-and-consultation`, `hr-os-outcome-verification`, `hr-os-workforce-planning`) appear in that session's available-skills listing.
- [ ] Report back: did installation succeed cleanly, and did all five skills appear? Any errors or unexpected behaviour during install itself (not workflow behaviour, that belongs to Task 3) belongs here.

**STOP.** Do not proceed to Task 3 until Simon confirms installation succeeded and reports the skill listing.

---

### Task 3: [HUMAN] Run both live test scenarios

**Not dispatchable.** Requires Simon's interactive Claude Code session, using the scenario briefs from Task 1.

- [ ] Run Scenario A from `docs/superpowers/plans/2026-08-18-hr-os-v1-test-scenarios.md` and report results against its six checkpoints.
- [ ] Run Scenario B from the same file and report results against its three checkpoints.

**STOP.** Do not proceed to Task 4 until Simon's results for both scenarios are in.

---

### Task 4: Triage and fix findings from live testing

**Files:** Depends entirely on what Task 3 finds. Likely candidates, based on what the scenarios are designed to probe: `skills/hr-os-problem-framing/SKILL.md` (complexity-rating guidance), `skills/hr-os-calibration-and-consultation/SKILL.md` (depth-table application, and possibly a "when the reviewer withholds sign-off outright" addition), `skills/hr-os-success-criteria-first/SKILL.md` (a "when approval is declined" addition, if Scenario B shows the gap is real).

**Interfaces:** N/A. This task's shape depends on Task 3's findings, not on anything defined in advance.

- [ ] **Step 1: Read Task 3's results and classify each finding**

For each thing Simon reported as wrong or missing:
- **Real defect** (the skill did something incorrect, contradictory, or silently wrong): must be fixed before Gate A.
- **Confirmed-sound** (the skill handled it correctly, e.g. it naturally stopped and asked what to do next on the Scenario B decline): record as confirmed, no change needed. Do not add guidance for a case testing already shows is handled, this was explicit in the spec.
- **Nice-to-have** (works correctly but could be clearer): log to the GitHub Project board as a new backlog issue (`gh issue create`), not a blocker for this release.

- [ ] **Step 2: Fix each real defect**

Follow the same discipline as every prior skill edit in this project: exact insertion points, no restating what other skills own, `<HARD-GATE>` / red-flags-table / Output-section conventions preserved, no source-organisation references. If Scenario B genuinely shows no "gate fails" guidance exists and that's a real gap (not just an omission Simon can live with), add it to the relevant gate skill(s), following the same pattern Amendment 2 used during the original build: a targeted sentence at the right point in the existing structure, not a rewrite.

- [ ] **Step 3: Commit each fix**

One commit per skill file touched, e.g.:
```bash
git add skills/hr-os-calibration-and-consultation/SKILL.md
git commit -m "fix: <specific finding from v1.0.0 live testing>"
```

- [ ] **Step 4: Report back to Simon**

Summarise: what was found, what was fixed (with commit references), what was confirmed-sound and needed no change, and what got logged as a future backlog item instead of fixed now.

**STOP.** Do not proceed to Task 5 until Simon reviews the fixes (if any) and confirms readiness for Gate A.

---

### Task 5: Gate A, version bump and tag v1.0.0

**Only proceed once Simon has explicitly confirmed Gate A** (per the spec: "you confirm the repo is release-ready", a separate, explicit statement, not inferred from silence or from Task 4's report alone).

**Files:**
- Modify: `.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Bump both manifest versions**

Edit `.claude-plugin/plugin.json`, change `"version": "0.1.0"` to `"version": "1.0.0"`.

Edit `.claude-plugin/marketplace.json`, change the plugin entry's `"version": "0.1.0"` to `"version": "1.0.0"`.

- [ ] **Step 2: Verify both files are still valid JSON**

Run: `python3 -m json.tool .claude-plugin/plugin.json && python3 -m json.tool .claude-plugin/marketplace.json`
Expected: both print without error.

- [ ] **Step 3: Commit the version bump**

```bash
git add .claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "chore: bump hr-os to v1.0.0"
```

- [ ] **Step 4: Tag and push**

```bash
git tag -a v1.0.0 -m "hr-os v1.0.0, first hardened release, workforce-planning MVP proven live"
git push origin main
git push origin v1.0.0
```

- [ ] **Step 5: Report back**

Confirm the tag is live on GitHub (`gh release view v1.0.0` or the tags page), and that the plugin is installable via the self-hosted marketplace for anyone pointed at the repo URL. Note explicitly that Gate B (official marketplace submission) is a separate, later decision, not triggered by this task.

---

## Explicitly not covered by this plan

Gate B (official `claude-plugins-official` submission), a separate future decision per the spec, not scoped here. Any new domain workflow, tracked on the GitHub Project board (`https://github.com/users/simonives/projects/8`), not this plan. Populating `resources/business_partnering/workforce_planning/` reference content, also a tracked backlog item, not required for v1.0.0.
