# hr-os: a Claude Code / Cowork plugin for the HR Function

**Status:** approved design, pending implementation plan
**Supersedes:** `docs/superpowers/specs/2026-08-17-hr-os-design.md` (the standalone-orchestrator architecture). That spec's five-gate mapping and MVP domain choice (workforce planning before hiring) carry forward; its delivery mechanism (a hand-rolled TypeScript state machine, SQLite audit log, own CLI, cross-provider `ModelClient` abstraction) does not. Kept in place as the record of that decision and why it changed, not deleted.

## Why this changed

The orchestrator spec optimised for governance-grade, code-enforced gates running identically across Anthropic, OpenAI, and DeepSeek. Two tasks into implementation, the actual near-term need surfaced: hr-os needs to be usable directly inside Claude Code and Cowork via slash commands, the same way Superpowers is. A custom orchestrator application is the wrong shape for that — it's a separate program you'd have to run and wire up, not something Claude Code discovers and invokes on its own.

hr-os is now a **Claude Code plugin**: markdown skills with hard-gates, composed the way Superpowers composes `brainstorming` → `writing-plans` → `subagent-driven-development` → `requesting-code-review` → `finishing-a-development-branch` — a pattern this project's own build process has been running inside all session. Gate discipline is enforced by Claude Code's own harness (the skill-discovery mechanism plus each skill's own hard-gate language), not by application code.

**What this trades away, deliberately:** no code-level enforcement (a gate can be skipped if the model chooses not to invoke the skill — the same trust model Superpowers itself relies on), no persistent audit trail in the MVP, and no cross-provider execution (OpenAI/DeepSeek would need the skill content ported into their own instruction formats, not this plugin running unmodified). Cross-platform reach stays a longer-term goal, secondary to shipping this. Audit/governance infrastructure is deferred until the plugin has proven out in actual use — building it now would be governance infrastructure for a shape that might still change.

## Purpose (unchanged from the original brief)

hr-os brings the same gate discipline Superpowers applies to a software dev/CI-CD lifecycle to how a mature HR function actually operates: workforce planning before hiring, structured investigation before disciplinary action, evidence-based policy design, proper consultation before organisational change, verification before a case closes.

## Plugin structure

```
hr-os/
  .claude-plugin/plugin.json
  skills/
    hr-os-problem-framing/SKILL.md
    hr-os-success-criteria-first/SKILL.md
    hr-os-calibration-and-consultation/SKILL.md
    hr-os-outcome-verification/SKILL.md
    hr-os-workforce-planning/SKILL.md    # composes the four gates above
  commands/
    plan-workforce.md                     # /hr-os:plan-workforce
  resources/                              # relocated from src/resources/, content unchanged
    business_partnering/...
    centres_of_excellence/...
    digital_hr_and_transformation/...
    employee_experience/...
    hr_service_delivery/...
    people_analytics/...
```

No orchestrator code, no database, no CLI, no provider abstraction. `src/` (the TypeScript project scaffolding from the abandoned orchestrator attempt) is removed entirely; the resource library moves to `resources/` at repo root, matching how a Claude Code plugin's own content is laid out (mirroring Superpowers' `skills/`, `references/` convention).

## Discovery and invocation

No custom `SessionStart` hook. Claude Code already surfaces every installed plugin skill with its description each session (this session's own skill listing includes plugins like `writing-standards:generate` and `cloudflare:build-agent` with no hook forcing them). hr-os's skills need triggering descriptions strong enough to fire under `using-superpowers`'s "if a skill might apply, you must invoke it" rule, same as any other installed skill. `/hr-os:plan-workforce` gives an explicit, discoverable entry point on top of that — matching how `/brainstorming` and `/code-review` work today.

## The five gate-type skills, updated after BOS-practice review

The original four cross-cutting gate types (the MVP doesn't use `structured-investigation` — no workflow needs it yet) each got a concrete gap-fix from a BOS-practice review of the design (see "BOS review findings" below).

| Gate | What it gates | Update from BOS review |
|---|---|---|
| `hr-os-problem-framing` | Explicit problem statement, stakeholders, constraints, before jumping to a solution. | **+ complexity rating.** Every use of this gate now classifies the problem as Clear / Complicated / Complex / Chaotic (a standard problem-complexity ladder, not vendor-specific language). This rating is threaded forward and scales how much consultation depth `calibration-and-consultation` demands later — a routine backfill and a restructure should not get identical process weight. |
| `hr-os-success-criteria-first` | Success criteria and a decision, agreed before design work starts. | **+ purpose trace.** Success criteria must state which organisational purpose or target they serve — a one-line answer to "which goal does this serve," not a free-floating list. Criteria with no traceable purpose are a gate failure, not an omission to fix later. |
| `hr-os-calibration-and-consultation` | Review by the right second party before a decision lands. | **+ complexity-scaled depth.** The reviewing party and consultation depth required is read from the complexity rating captured at `problem-framing`: Clear → single reviewer sign-off is sufficient; Complicated/Complex → named subject-matter reviewer plus documented rationale; Chaotic → full panel, plus legal/compliance, plus (where the case is organisational-change-adjacent) explicit consultation with affected employees or their representatives. |
| `hr-os-outcome-verification` | Evidence the outcome matches what was decided, before a case closes. | **+ feed-forward.** Closing a case now requires stating whether anything about it should change a template, a standard, or a future gate's guidance — even "no changes needed" is a required, explicit answer, not silence. This turns verification from a one-off pass/fail into input for the next case, instead of a dead end. |

## MVP domain workflow: workforce planning before hiring (updated)

`hr-os-workforce-planning` composes the four gates above into one sequence, invoked via `/hr-os:plan-workforce` or discovered directly when a practitioner is working through a hiring/backfill decision:

1. **Demand signal capture** (`problem-framing`) — captures the problem, stakeholders, constraints, and complexity rating. **New:** must also classify the demand type (predictable / variable / unpredictable) and cite the capacity/demand evidence behind the signal — a current roster vs. plan, a demand forecast, or a documented capacity baseline (e.g. a WILO-style capacity instrument, a generic and portable methodology term, not BHP-specific usage). Where genuine data doesn't exist, the gate permits an explicit "asserted, no baseline available" flag rather than silently treating narrative as if it were evidence — the gap must be visible, not hidden.
2. **Workforce plan gate** (`success-criteria-first`, human-approval) — headcount vs. plan, build/buy/borrow, with the required purpose trace (which target this workforce plan serves).
3. **Role design and levelling** — grounded in `resources/business_partnering/workforce_planning/`.
4. **Budget/approval gate** (`calibration-and-consultation`, human-approval) — consultation depth scaled to the complexity rating from stage 1; may draw on native model tools (e.g. web search) or connected MCP servers/connectors for current benchmark data if available and the practitioner opts in — see "Capability awareness" below.
5. **Requisition released** (`outcome-verification`) — confirms the requisition matches the approved plan and budget recommendation, and states explicitly whether anything about this case should update the workforce-planning skill's own guidance going forward.

## Capability awareness (carried forward from the orchestrator spec, adapted)

The original spec's idea of a gate requesting external capabilities (native model tools, connected MCP servers, platform connectors) still applies, but the mechanism changes: there's no code-level registry to resolve against. Instead, the relevant skill's markdown instructs Claude to check what's actually available in the current session (installed MCP servers, native tools) at the point a capability would help, surface it to the practitioner as an explicit choice ("a SharePoint MCP server may have current salary benchmarks — use it?"), and proceed on resource-library grounding alone if nothing relevant is available or the practitioner declines. This is a prompt-level instruction, not a resolvable registry — consistent with the rest of the plugin's enforcement model.

## BOS review findings (informing this design)

A BOS-MCP review of the original four-gate MVP design (before this update) found genuine alignment — `problem-framing` tracks BOS's SMART-problem-before-root-cause discipline, `success-criteria-first` echoes target-setting before design, `outcome-verification` maps onto verify-the-standard practice — but flagged four gaps, all addressed above: no complexity routing before applying process weight; `demand-signal-capture` treating capacity as asserted rather than evidenced; no traceability from success criteria back to organisational purpose; and verification as a terminal check rather than feeding forward into future cases.

## Explicitly out of scope for this MVP

- Any gate beyond the four the workforce-planning workflow uses (`structured-investigation` is designed but not built until a workflow needs it — e.g. a future employee-relations skill).
- Persistent audit trail or logging infrastructure — deferred until the plugin has proven out in real use.
- Cross-provider execution (OpenAI, DeepSeek) — the skill content is written to be portable in principle, but no port exists yet.
- Publishing to `claude-plugins-official` or any marketplace — self-hosted on GitHub is sufficient for now; marketplace submission (with its immutable-name constraint) is a later, separate decision.
- Any domain workflow beyond workforce planning.
