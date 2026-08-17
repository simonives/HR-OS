# hr-os Plugin MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build hr-os as an installable Claude Code / Cowork plugin: five markdown skills (four cross-cutting gates plus the composed workforce-planning workflow) that bring the same gate discipline Superpowers applies to software development to a workforce-planning-before-hiring decision, enforced by Claude Code's own skill-discovery and hard-gate conventions — no application code.

**Architecture:** A `.claude-plugin/plugin.json` manifest plus a `skills/` directory of `SKILL.md` files, following the exact structure verified against the installed Superpowers plugin at `~/.claude/plugins/cache/claude-plugins-official/superpowers/6.3.0/`: no `commands/` directory (skills are slash-invocable by their `name` alone — confirmed by inspecting that plugin, which has none), no custom `SessionStart` hook (skill descriptions alone are enough to surface in Claude Code's per-session skill listing). The existing HR resource library moves from `src/resources/` to `resources/` at repo root. The abandoned TypeScript orchestrator scaffolding (package.json, tsconfig.json, and the two commits on the now-unused `hr-os-mvp` branch) is not part of this plan and is not touched.

**Tech Stack:** Markdown (`SKILL.md` files with YAML frontmatter), JSON (`plugin.json`, `marketplace.json`). No runtime, no build step, no dependencies.

**Spec:** `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md`

## Global Constraints

- No orchestrator code, no build step, no package.json/tsconfig.json — this repo is a plugin, not a Node project, from this plan onward.
- Every `SKILL.md` needs YAML frontmatter with exactly `name` (kebab-case, prefixed `hr-os-`) and `description` (a trigger-quality sentence stating when to use the skill), matching the convention verified in Superpowers' own `SKILL.md` files.
- No `commands/` directory — skills are invoked directly by name (verified: the installed Superpowers plugin has zero files under any `commands/` path, and `/brainstorming` invokes the skill named `brainstorming` directly).
- Every gate skill (`hr-os-problem-framing`, `hr-os-success-criteria-first`, `hr-os-calibration-and-consultation`, `hr-os-outcome-verification`) must contain a `<HARD-GATE>` block stating what it blocks, matching the convention used in Superpowers' `brainstorming/SKILL.md`.
- Terminology: no BHP/BOS-proprietary language. Generic cross-industry methodology terms (the Clear/Complicated/Complex/Chaotic complexity ladder, "WILO-style capacity instrument" as an example, not a requirement) are fine — this was explicit user guidance during design.
- Skills reference the resource library at `resources/...` (post-move), never `src/resources/...`.
- No persistent audit trail, logging infrastructure, or state-tracking mechanism — explicitly deferred per the spec's "Explicitly out of scope" section.
- No placeholders, no `TODO`s — skill content is the deliverable itself and must be complete, final-quality prose, not a stub.

---

## File Structure

```
.claude-plugin/
  plugin.json
  marketplace.json
skills/
  hr-os-problem-framing/SKILL.md
  hr-os-success-criteria-first/SKILL.md
  hr-os-calibration-and-consultation/SKILL.md
  hr-os-outcome-verification/SKILL.md
  hr-os-workforce-planning/SKILL.md
resources/                              # moved from src/resources/, content unchanged
  business_partnering/...
  centres_of_excellence/...
  digital_hr_and_transformation/...
  employee_experience/...
  hr_service_delivery/...
  people_analytics/...
scripts/
  extract_epubs.sh                       # moved from src/, historical utility, untouched otherwise
README.md                                # full rewrite, Task 7
```

`package.json`, `tsconfig.json`, and the rest of `src/` are deleted in Task 1.

---

### Task 1: Repo restructure — remove the orchestrator scaffolding, relocate resources, add the plugin manifest

**Files:**
- Delete: `package.json`, `tsconfig.json`
- Delete (local, untracked — confirm with `git ls-files` first; do not assume): `src/tools/`, `src/prompts/`, `src/lib/`, `src/.DS_Store`, `src/resources/.DS_Store`
- Move: `src/resources/` → `resources/`
- Move: `src/extract_epubs.sh` → `scripts/extract_epubs.sh`
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Modify: `.gitignore`
- Modify: `docs/superpowers/plans/2026-08-17-hr-os-mvp.md:1` (superseded marker only)

**Interfaces:**
- Produces: `resources/` as the path every later skill task grounds itself in; `.claude-plugin/plugin.json` and `marketplace.json` as the installable plugin manifest.

- [ ] **Step 1: Confirm what's actually tracked before deleting**

Run: `git ls-files src/tools src/prompts src/lib src/.DS_Store src/resources/.DS_Store package.json tsconfig.json`

Expected: `package.json` and `tsconfig.json` are tracked (they'll show in the output); `src/tools`, `src/prompts`, `src/lib`, and the `.DS_Store` files are untracked local artifacts (from earlier exploration in this project — they exist on disk but git has nothing to remove). Confirm this matches before proceeding — if any of the "untracked" paths actually show up as tracked, stop and report NEEDS_CONTEXT rather than deleting tracked content silently.

- [ ] **Step 2: Remove the Node/TypeScript project files and the empty scaffold directories**

```bash
git rm package.json tsconfig.json
rm -rf src/tools src/prompts src/lib src/.DS_Store src/resources/.DS_Store
```

- [ ] **Step 3: Relocate the resource library and the epub-extraction script**

```bash
git mv src/resources resources
mkdir -p scripts
git mv src/extract_epubs.sh scripts/extract_epubs.sh
rmdir src 2>/dev/null || true
```

(`rmdir src` will succeed once it's empty; if it fails because something unexpected remains, inspect it — don't force-remove without looking.)

- [ ] **Step 4: Create the plugin manifest**

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "hr-os",
  "description": "Gated Claude Code skills for enterprise HR practice — workforce planning, evidence-based policy design, and process discipline modelled on Superpowers, applied to how a mature HR function operates.",
  "version": "0.1.0",
  "author": {
    "name": "Simon Ives"
  },
  "homepage": "https://github.com/simonives/hr-os",
  "repository": "https://github.com/simonives/hr-os",
  "license": "ISC",
  "keywords": ["hr", "human resources", "workforce planning", "governance", "skills"]
}
```

- [ ] **Step 5: Create the self-hosted marketplace manifest**

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "hr-os-dev",
  "description": "Development marketplace for the hr-os HR Function skills plugin",
  "owner": {
    "name": "Simon Ives"
  },
  "plugins": [
    {
      "name": "hr-os",
      "description": "Gated Claude Code skills for enterprise HR practice.",
      "version": "0.1.0",
      "source": "./",
      "author": {
        "name": "Simon Ives"
      }
    }
  ]
}
```

- [ ] **Step 6: Trim .gitignore for a non-Node repo**

Edit `.gitignore` — remove the `node_modules/`, `dist/`, and `*.tsbuildinfo` lines (no longer relevant); keep everything else:

```
.env
.DS_Store
.worktrees/
.superpowers/

# Reference materials — copyrighted EPUBs/PDFs (keep README only)
references/**/*.epub
references/**/*.pdf
references/**/*.mobi
```

- [ ] **Step 7: Mark the superseded orchestrator plan**

Edit `docs/superpowers/plans/2026-08-17-hr-os-mvp.md`, insert as the very first line (before the `#` heading):

```markdown
> **Superseded:** this plan targeted the standalone-orchestrator architecture, abandoned in favour of a Claude Code plugin. See `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md` and `docs/superpowers/plans/2026-08-17-hr-os-plugin-mvp.md`. Kept for the record, not executed further.

```

- [ ] **Step 8: Verify the tree looks right**

Run: `git status` and `ls resources scripts .claude-plugin`
Expected: `resources/` contains the six original domain directories; `scripts/extract_epubs.sh` exists; `.claude-plugin/` contains both JSON files; `git status` shows the deletions, moves, and the two new/modified files, nothing unexpected.

- [ ] **Step 9: Commit**

```bash
git add -A
git commit -m "chore: restructure hr-os as a Claude Code plugin, remove orchestrator scaffolding"
```

---

### Task 2: hr-os-problem-framing skill

**Files:**
- Create: `skills/hr-os-problem-framing/SKILL.md`

**Interfaces:**
- Produces: the `hr-os-problem-framing` skill, invoked by name and referenced by `hr-os-workforce-planning` (Task 6) and by `hr-os-calibration-and-consultation` (Task 4, which reads the complexity rating this skill produces).

- [ ] **Step 1: Write the skill**

Create `skills/hr-os-problem-framing/SKILL.md`:

```markdown
---
name: hr-os-problem-framing
description: Use before any HR intervention — a policy change, an organisational change, a new or backfilled role, a hiring decision — to establish the problem, stakeholders, constraints, and complexity before a solution is proposed. Part of the hr-os plugin.
---

# HR Problem Framing

## Overview

Don't design an intervention before the problem is stated. This is the HR analogue of `superpowers:brainstorming` — the same discipline, applied to HR decisions instead of software features.

<HARD-GATE>
Do NOT propose a solution, a design, or a plan of action until the problem statement, stakeholders, constraints, and complexity rating below are captured and, where the stakes warrant it, confirmed with your human partner. This applies even when the "solution" seems obvious — obvious solutions to badly-framed problems are how HR interventions go wrong.
</HARD-GATE>

## What to capture

1. **Problem statement** — one or two sentences. What is actually happening, not what someone wants to happen instead. ("Two operations supervisor roles are unfilled and the team is running over standard hours" — not "we need to hire".)
2. **Stakeholders** — everyone whose interests or authority this touches: the requesting manager, affected employees, HRBP, finance, legal/compliance if relevant, employee representatives if relevant.
3. **Constraints** — budget, timeline, policy, legal, or organisational limits that bound any solution.
4. **Complexity rating** — classify the problem so downstream review depth (see `hr-os-calibration-and-consultation`) scales to the actual stakes, not a flat default:

| Rating | What it means | Example |
|---|---|---|
| Clear | The problem and the right response are well understood and routine | A like-for-like backfill of a role that already exists |
| Complicated | Solvable with the right expertise, but not routine | A role redesign with several dependent roles or systems |
| Complex | Cause and effect are only obvious in hindsight; needs consultation or iteration | A restructure touching multiple teams or reporting lines |
| Chaotic | Urgent and high-stakes; even the right first move isn't clear yet | A sudden critical-skills gap with safety or compliance exposure |

Justify the rating in one sentence — "Complicated because the role reports into two functions" is enough. Don't default to Clear because it's less work; an under-rated problem gets under-reviewed later.

## Red flags

| Thought | Reality |
|---|---|
| "The solution is obvious, I'll skip the framing" | Obvious solutions to unframed problems are exactly what this gate catches. |
| "This is routine, complexity rating doesn't matter here" | Rate it Clear and say so — the rating still has to exist, even when the answer is "not much." |
| "I'll capture stakeholders later once I know the answer" | Stakeholders shape what counts as a good answer. Capture them first. |

## Output

A short block covering all four items above. Hand it forward to whichever gate or workflow skill invoked this one — `hr-os-success-criteria-first` and `hr-os-calibration-and-consultation` both read from it.
```

- [ ] **Step 2: Self-review against the content checklist**

Confirm, and note the confirmation in your report:
- Frontmatter has exactly `name: hr-os-problem-framing` and a `description` starting with "Use before/when..." (trigger-quality, matches Superpowers' own convention).
- A `<HARD-GATE>` block is present and states what it blocks.
- A "Red flags" table is present with at least 3 rows.
- An "Output" section states what downstream skills receive.

- [ ] **Step 3: Walkthrough test**

Apply the skill to this scenario and write the resulting artifact in your report (this is the skill's evidence of working, in place of an executable test):

> Scenario: "Two Operations Supervisor roles have been vacant for six weeks. The Regional Ops Director wants approval to backfill both permanently, but FY27 has a budget freeze on new-to-org headcount."

Produce: a problem statement, stakeholder list, constraint list, and complexity rating with justification, following the skill's own structure. Confirm in your report that applying the skill actually produces a usable, specific artifact — not a generic restatement of the scenario.

- [ ] **Step 4: Commit**

```bash
git add skills/hr-os-problem-framing
git commit -m "feat: add hr-os-problem-framing skill"
```

---

### Task 3: hr-os-success-criteria-first skill

**Files:**
- Create: `skills/hr-os-success-criteria-first/SKILL.md`

**Interfaces:**
- Produces: the `hr-os-success-criteria-first` skill, referenced by `hr-os-workforce-planning` (Task 6) and by `hr-os-outcome-verification` (Task 5, which checks outcomes against the criteria this skill produces).

- [ ] **Step 1: Write the skill**

Create `skills/hr-os-success-criteria-first/SKILL.md`:

```markdown
---
name: hr-os-success-criteria-first
description: Use before designing any HR intervention — a policy, a role, a workforce plan — to agree success criteria and their link to an organisational purpose or target before doing the design work. Part of the hr-os plugin.
---

# Success Criteria First

## Overview

Define what "working" looks like before designing how to get there. This is the HR analogue of `superpowers:test-driven-development` — write the test (the success criteria) before writing the implementation (the policy, the role, the plan).

<HARD-GATE>
Do NOT begin designing the intervention until success criteria are stated AND traced to an organisational purpose or target. Success criteria with no stated purpose are a gate failure, not something to fix later — they mean you can't tell afterwards whether the intervention actually worked, or whether it worked at the expense of the point of doing it.
</HARD-GATE>

## What to capture

1. **Success criteria** — specific and, where possible, measurable. "Supervisor coverage restored to a 1:12 ratio within one quarter" is a success criterion. "Team feels better resourced" is not, on its own — pair it with something checkable.
2. **Decision** — the concrete choice being made (build vs. buy vs. borrow; policy A vs. policy B; this org design vs. that one).
3. **Purpose trace** — one sentence answering "which goal, target, or commitment does this serve?" A workforce plan should trace to a stated capacity or service target; a policy should trace to a named risk it manages or an outcome it improves. If you can't state the trace, the criteria aren't ready — go find the target before proceeding, don't invent one to fill the gate.

## Red flags

| Thought | Reality |
|---|---|
| "The criteria are obviously good, tracing them is busywork" | The trace is what lets `hr-os-outcome-verification` check the case later. Skipping it now makes verification unfalsifiable. |
| "I'll write the design first and back-fill criteria that fit it" | That's outcome-first reasoning wearing success-criteria clothing. Write criteria before you know the design's shape. |
| "The target is obvious, no need to state it" | If it's obvious, stating it costs one sentence. Skipping it costs the ability to verify the case later. |

## Human approval

For anything beyond a Clear-rated problem (see `hr-os-problem-framing`), success criteria and the decision they justify should be confirmed with your human partner before design work proceeds — this is usually the point where a workforce plan, policy direction, or org design gets signed off.

## Output

Success criteria, the decision, and the purpose trace. Hand forward to the design work and to `hr-os-outcome-verification`, which checks the eventual outcome against exactly this.
```

- [ ] **Step 2: Self-review against the content checklist**

Confirm, and note in your report:
- Frontmatter `name`/`description` present and correct.
- `<HARD-GATE>` block present.
- Red flags table present, 3+ rows.
- A "Human approval" section exists and references the complexity rating from `hr-os-problem-framing`.
- "Output" section states what downstream skills receive.

- [ ] **Step 3: Walkthrough test**

Apply the skill to this scenario (continuing from Task 2's) and write the resulting artifact in your report:

> Scenario: following on from the demand signal in Task 2 (two vacant Operations Supervisor roles, FY27 budget freeze on new-to-org headcount), the decision under consideration is converting two existing contractor roles to permanent Operations Supervisor positions, funded from the existing contractor budget envelope (not new-to-org headcount).

Produce: success criteria, the decision statement, and a purpose trace, following the skill's structure.

- [ ] **Step 4: Commit**

```bash
git add skills/hr-os-success-criteria-first
git commit -m "feat: add hr-os-success-criteria-first skill"
```

---

### Task 4: hr-os-calibration-and-consultation skill

**Files:**
- Create: `skills/hr-os-calibration-and-consultation/SKILL.md`

**Interfaces:**
- Consumes: the complexity rating produced by `hr-os-problem-framing` (Task 2) — reference it by name, don't redefine the complexity ladder here.
- Produces: the `hr-os-calibration-and-consultation` skill, referenced by `hr-os-workforce-planning` (Task 6).

- [ ] **Step 1: Write the skill**

Create `skills/hr-os-calibration-and-consultation/SKILL.md`:

```markdown
---
name: hr-os-calibration-and-consultation
description: Use before a decision lands — a rating, a promotion, an organisational change, a policy, a budget approval — to get it reviewed by the right second party at a depth matched to the problem's complexity. Part of the hr-os plugin.
---

# Calibration and Consultation

## Overview

A decision gets reviewed by someone other than the person who made it, before it takes effect. This is the HR analogue of code review — the same principle Superpowers applies before a merge, applied here before a decision affecting people lands.

<HARD-GATE>
Do NOT implement, communicate, or act on the decision until it has been reviewed at the depth this skill specifies. A review that exists only as a checkbox — no named reviewer, no rationale, no evidence anyone actually looked at it — does not satisfy this gate.
</HARD-GATE>

## Review depth by complexity

Read the complexity rating from `hr-os-problem-framing`. Scale review depth to it — treating a routine backfill and a restructure identically either wastes time on the former or under-reviews the latter:

| Complexity | Required review |
|---|---|
| Clear | Single reviewer sign-off (the requester's manager or HRBP) is sufficient. |
| Complicated | A named subject-matter reviewer, plus a documented rationale for the recommendation. |
| Complex | A named subject-matter reviewer, documented rationale, and confirmation that affected stakeholders (from `hr-os-problem-framing`) have had a chance to raise concerns. |
| Chaotic | Full panel review, plus legal/compliance sign-off, plus — where the case touches organisational change — explicit, documented consultation with affected employees or their representatives before the decision is finalised, not after. |

## What to capture

1. **Reviewer(s)** — who actually reviewed, by name or role.
2. **Recommendation** — what they concluded, in their own terms, not paraphrased into agreement with the original proposal.
3. **Consultation notes** — what was raised, by whom, and how it was addressed. "No consultation required" is a valid note only when the complexity table above says so.

## Red flags

| Thought | Reality |
|---|---|
| "I already know what the reviewer will say" | Then the review will be fast. Skipping it because you're confident is exactly the failure mode this gate exists to catch. |
| "This is basically the same as a case we already approved" | Precedent is an input to the reviewer's judgement, not a substitute for it. |
| "Consultation will just slow this down" | For Complex/Chaotic cases, consultation before the decision is finalised is the point, not an obstacle to it. |

## Output

Reviewer, recommendation, and consultation notes, matched to the required depth. Hand forward to `hr-os-outcome-verification`.
```

- [ ] **Step 2: Self-review against the content checklist**

Confirm, and note in your report:
- Frontmatter present and correct.
- `<HARD-GATE>` block present.
- The review-depth table has all four complexity levels and references `hr-os-problem-framing` by name rather than redefining the ladder.
- Red flags table present, 3+ rows.

- [ ] **Step 3: Walkthrough test**

Using the "Complicated" rating and the contractor-conversion decision from Task 3's walkthrough, produce a reviewer, recommendation, and consultation notes following this skill's structure and the "Complicated" row of the depth table. Write the result in your report.

- [ ] **Step 4: Commit**

```bash
git add skills/hr-os-calibration-and-consultation
git commit -m "feat: add hr-os-calibration-and-consultation skill"
```

---

### Task 5: hr-os-outcome-verification skill

**Files:**
- Create: `skills/hr-os-outcome-verification/SKILL.md`

**Interfaces:**
- Consumes: the decision and success criteria from `hr-os-success-criteria-first` (Task 3) — reference them, don't redefine.
- Produces: the `hr-os-outcome-verification` skill, referenced by `hr-os-workforce-planning` (Task 6).

- [ ] **Step 1: Write the skill**

Create `skills/hr-os-outcome-verification/SKILL.md`:

```markdown
---
name: hr-os-outcome-verification
description: Use before declaring an HR case or initiative complete — confirms the outcome actually matches what was decided and captures whether anything should change going forward. Part of the hr-os plugin.
---

# Outcome Verification

## Overview

Check that what actually happened matches what was decided, before closing the case — and ask whether anything about this case should change how future cases are handled. This is the HR analogue of `superpowers:verification-before-completion`: evidence before the claim of success, every time.

<HARD-GATE>
Do NOT declare the case or initiative complete without both (a) evidence the outcome matches the decision from `hr-os-success-criteria-first`, and (b) an explicit feed-forward statement — even "no changes needed" counts, but silence does not.
</HARD-GATE>

## What to capture

1. **Outcome matches decision** — a yes/no judgement, backed by evidence, not assumed from the fact that the process was followed. A requisition can follow every gate correctly and still not match the approved plan (wrong level, wrong headcount, wrong timing) — check the artefact itself, not just the process trail.
2. **Evidence** — what you checked to reach that judgement.
3. **Feed-forward** — does this case reveal anything that should change a template, a standard, or one of hr-os's own skills, so the same gap doesn't recur? State the answer explicitly, including when the answer is "no changes needed."

## Red flags

| Thought | Reality |
|---|---|
| "Every gate was followed, so the outcome must be right" | Process compliance and outcome correctness are different claims. Check the outcome itself. |
| "Feed-forward is optional if there's nothing to report" | "Nothing to report" is a valid answer, but it has to be stated, not implied by skipping the section. |

## Output

Outcome-matches-decision judgement, evidence, and feed-forward statement. This closes the case.
```

- [ ] **Step 2: Self-review against the content checklist**

Confirm, and note in your report:
- Frontmatter present and correct.
- `<HARD-GATE>` block present and names both required parts (evidence + feed-forward).
- Red flags table present.

- [ ] **Step 3: Walkthrough test**

Using the approved contractor-conversion plan from Task 3 and the calibration outcome from Task 4, verify a hypothetical requisition for "2x Operations Supervisor, converted from existing contractor roles, within the approved budget envelope" against the plan. Produce the outcome judgement, evidence, and feed-forward statement in your report.

- [ ] **Step 4: Commit**

```bash
git add skills/hr-os-outcome-verification
git commit -m "feat: add hr-os-outcome-verification skill"
```

---

### Task 6: hr-os-workforce-planning composed workflow skill

**Files:**
- Create: `skills/hr-os-workforce-planning/SKILL.md`

**Interfaces:**
- Consumes: all four gate skills from Tasks 2-5 by name (`hr-os-problem-framing`, `hr-os-success-criteria-first`, `hr-os-calibration-and-consultation`, `hr-os-outcome-verification`) — do not restate their content, reference and compose them.
- Produces: the `hr-os-workforce-planning` skill — the MVP's primary user-facing entry point.

- [ ] **Step 1: Write the skill**

Create `skills/hr-os-workforce-planning/SKILL.md`:

```markdown
---
name: hr-os-workforce-planning
description: Use when advising on or working through a hiring, backfill, or headcount decision — walks demand-signal capture through requisition release using hr-os's gate skills (problem framing, success criteria, calibration and consultation, outcome verification), grounded in the workforce-planning reference material. Part of the hr-os plugin.
---

# Workforce Planning Before Hiring

## Overview

Workforce planning done well answers "should we hire, and for what" before it answers "who should we hire." This skill composes hr-os's four gate skills into the specific sequence a workforce-planning decision needs — the same way `superpowers:subagent-driven-development` composes brainstorming, writing-plans, and code review into a single build process.

Reference material for this domain lives in `resources/business_partnering/workforce_planning/` — read what's relevant there at each stage below rather than relying on general knowledge of workforce planning.

## The five stages

```
1. Demand signal capture      (hr-os-problem-framing, + demand evidence)
2. Workforce plan gate        (hr-os-success-criteria-first)  <- human approval
3. Role design and levelling
4. Budget/approval gate       (hr-os-calibration-and-consultation)  <- human approval
5. Requisition released       (hr-os-outcome-verification)
```

### 1. Demand signal capture

Use `hr-os-problem-framing`. In addition to its standard requirements, capture:

- **Demand type** — predictable, variable, or unpredictable. This shapes whether build/buy/borrow (stage 2) should favour a permanent hire, a flexible arrangement, or a contingent one.
- **Capacity/demand evidence** — cite what the demand signal is actually based on: a current roster vs. plan, a demand forecast, a documented capacity baseline (a WILO-style capacity instrument, if your organisation has one, or an equivalent artefact). If no real baseline exists, say so explicitly — flag it as "asserted, no baseline available" rather than writing the demand signal as if it were backed by data it isn't. A visible gap is better than an invisible assumption.

<HARD-GATE>
Do not proceed to the workforce-plan gate on an unexamined assumption about capacity. Either cite real evidence or flag its absence — never write the demand signal in a way that reads as evidenced when it isn't.
</HARD-GATE>

### 2. Workforce plan gate

Use `hr-os-success-criteria-first`. The decision here is the build/buy/borrow call and the headcount/budget envelope it implies. The purpose trace should point at a real capacity or service target (a coverage ratio, a service-level commitment, a cost-to-serve target) — not a restated version of the demand signal.

<HARD-GATE>
This gate requires your human partner's explicit approval before role design begins. Do not proceed on an assumed or implied yes.
</HARD-GATE>

### 3. Role design and levelling

Design the role profile implied by the approved plan: title, level, and core capabilities. Ground this in `resources/business_partnering/workforce_planning/` and any relevant levelling framework it references. No separate gate skill here — this is domain design work sitting between two gates, not itself a cross-cutting gate type.

### 4. Budget/approval gate

Use `hr-os-calibration-and-consultation`. Review depth is set by the complexity rating captured in stage 1 (see that skill's depth table). Before finalising the recommendation, check whether current benchmark data would materially change it — if a connected MCP server or native tool (e.g. web search) could supply current salary benchmarking data and none of the reference material is recent enough, say so and ask your human partner whether to use it, naming the source. Proceed on the resource-library material alone if nothing suitable is available or they decline.

<HARD-GATE>
This gate requires your human partner's explicit approval before the requisition is released. Do not proceed on an assumed or implied yes.
</HARD-GATE>

### 5. Requisition released

Use `hr-os-outcome-verification`. Confirm the requisition (level, headcount, timing) matches the approved plan from stage 2 and the recommendation from stage 4 — not just that both stages happened. Capture the feed-forward statement: does anything about this case suggest a change to workforce-planning practice, a template, or this skill itself?

## Red flags

| Thought | Reality |
|---|---|
| "This is obviously a backfill, I can skip straight to role design" | Stage 1's complexity rating is what makes stage 4's review depth correct. Skipping it under-reviews the decision, even when the hire itself is routine. |
| "The manager already knows what they want to hire" | That's an input to demand-signal capture, not a substitute for it — capture it as the demand signal, don't skip the stage because the answer seems pre-decided. |
```

- [ ] **Step 2: Self-review against the content checklist**

Confirm, and note in your report:
- Frontmatter present and correct.
- All five stages present in order, each naming the gate skill it uses (or stating it has none, for stage 3).
- Both human-approval `<HARD-GATE>` blocks present (stages 2 and 4), plus the evidence `<HARD-GATE>` in stage 1.
- Resource path is `resources/business_partnering/workforce_planning/` (post-move path, not `src/resources/...`).
- Red flags table present.

- [ ] **Step 3: Walkthrough test — full scenario, all five stages**

Run this scenario end to end, producing an artifact for each stage in your report (this is the MVP's proof the composed skill actually works, not just that each piece reads well in isolation):

> Scenario: "Regional ops team understaffed for FY27 volume growth. FY27 has a budget freeze on new-to-org headcount. Current coverage is below the standard supervisor ratio."

Produce, in sequence: (1) demand signal capture with demand type and evidence citation; (2) workforce plan gate output (success criteria, decision, purpose trace) — state explicitly that this stage requires human approval; (3) a role profile; (4) budget/approval gate output (reviewer, recommendation, consultation notes) at the depth implied by whatever complexity rating you assigned in stage 1 — state explicitly that this stage requires human approval; (5) outcome verification output including the feed-forward statement.

- [ ] **Step 4: Commit**

```bash
git add skills/hr-os-workforce-planning
git commit -m "feat: add hr-os-workforce-planning composed workflow skill"
```

---

### Task 7: README rewrite and manual installation verification

**Files:**
- Modify: `README.md` (full rewrite)

**Interfaces:**
- Consumes: nothing new — documents what Tasks 1-6 built.

- [ ] **Step 1: Rewrite README.md**

Replace the full contents of `README.md`:

```markdown
# hr-os

A Claude Code / Cowork plugin that brings gate discipline to enterprise HR practice — modelled philosophically on [Superpowers](https://github.com/obra/superpowers), the same rigour Superpowers applies to a software dev/CI-CD lifecycle, applied instead to how a mature HR function actually operates: workforce planning before hiring, structured investigation before disciplinary action, evidence-based policy design, proper consultation before organisational change.

> **Status:** MVP — one composed workflow (workforce planning before hiring), built from four gate skills. See `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md` for the design and `docs/superpowers/plans/2026-08-17-hr-os-plugin-mvp.md` for how it was built.

## What this is

A set of Claude Code skills (`skills/*/SKILL.md`), installed the same way Superpowers is. No application code, no server, no database — gate discipline is enforced by Claude Code's own skill-discovery mechanism and each skill's explicit hard-gates, not by a state machine.

## The four gate skills

| Skill | What it gates |
| :--- | :--- |
| `hr-os-problem-framing` | An intervention starts from an explicit problem statement and a complexity rating, not a jump to a solution. |
| `hr-os-success-criteria-first` | A design's success criteria are agreed, and traced to an organisational purpose, before the design work. |
| `hr-os-calibration-and-consultation` | A decision is reviewed by the right second party, at a depth matched to its complexity, before it lands. |
| `hr-os-outcome-verification` | A case only closes once the outcome is shown to match what was decided, with an explicit feed-forward statement. |

## MVP: workforce planning before hiring

`hr-os-workforce-planning` composes the four gates above:

```
demand-signal-capture (hr-os-problem-framing, + demand evidence)
  -> workforce-plan-gate (hr-os-success-criteria-first)          <- human approval
  -> role-design-and-levelling
  -> budget-approval-gate (hr-os-calibration-and-consultation)   <- human approval
  -> requisition-released (hr-os-outcome-verification)
```

## Installing locally

```bash
# From inside a Claude Code session, in this repo:
/plugin marketplace add ./.claude-plugin/marketplace.json
/plugin install hr-os
```

Then either invoke a skill directly by name (e.g. `hr-os-workforce-planning`) when working through a hiring decision, or ask Claude to help with a workforce-planning decision and let the skill-discovery mechanism surface it.

## Resource library

`resources/` is a curated HR knowledge library organised across six domains (business partnering, centres of excellence, digital HR & transformation, employee experience, HR service delivery, people analytics). `hr-os-workforce-planning` grounds itself in `resources/business_partnering/workforce_planning/`.

## Extending beyond the MVP

- **New gate-typed skills:** `hr-os-structured-investigation` (structured fact-finding before adverse action on a person) is designed in the spec but not yet built — no workflow needs it until an employee-relations skill is added.
- **New domain workflows:** compose the existing four gate skills the way `hr-os-workforce-planning` does, following its pattern.
- **Audit trail / governance logging:** deferred until this plugin has proven out in real use — see the design spec's "Explicitly out of scope" section.
- **Cross-provider ports:** the skill content is written to be portable in principle; no port to another provider's instruction format exists yet.
```

- [ ] **Step 2: Commit the README**

```bash
git add README.md
git commit -m "docs: rewrite README for the hr-os plugin"
```

- [ ] **Step 3: Manual installation verification (report only — do not attempt to automate this)**

This step needs a live, interactive Claude Code session and cannot be done by a dispatched subagent. Write these instructions into your report verbatim as the final section, addressed to the controller, rather than attempting to run them:

```
Manual verification (run in an interactive Claude Code session, in this repo):
  1. /plugin marketplace add ./.claude-plugin/marketplace.json
  2. /plugin install hr-os
  3. Confirm all five hr-os skills appear in the session's available-skills listing
  4. Invoke hr-os-workforce-planning directly by name and confirm it walks the five stages
     from the README, hard-gating at the two human-approval points
```

Report status DONE_WITH_CONCERNS if you reach this step, noting that manual verification is outstanding and needs to be run by the controller or Simon directly — this is expected, not a defect.
