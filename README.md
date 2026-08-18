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

`resources/` is a curated HR knowledge library organised across six domains (business partnering, centres of excellence, digital HR & transformation, employee experience, HR service delivery, people analytics). `hr-os-workforce-planning` grounds itself in `resources/business_partnering/workforce_planning/` — though that domain does not yet have populated reference material, unlike the other five; the skill is written to work without it, but grounding quality will improve once real content is added.

## Extending beyond the MVP

- **New gate-typed skills:** `hr-os-structured-investigation` (structured fact-finding before adverse action on a person) is designed in the spec but not yet built — no workflow needs it until an employee-relations skill is added.
- **New domain workflows:** compose the existing four gate skills the way `hr-os-workforce-planning` does, following its pattern.
- **Audit trail / governance logging:** deferred until this plugin has proven out in real use — see the design spec's "Explicitly out of scope" section.
- **Cross-provider ports:** the skill content is written to be portable in principle; no port to another provider's instruction format exists yet.
