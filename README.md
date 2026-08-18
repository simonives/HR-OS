# HR-OS

A Claude Code / Cowork plugin that brings gate discipline to enterprise HR practice. It's modelled philosophically on [Superpowers](https://github.com/obra/superpowers): the same rigour Superpowers applies to a software dev/CI-CD lifecycle, applied instead to how a mature HR function actually operates. Workforce planning before hiring. Structured investigation before disciplinary action. Evidence-based policy design. Proper consultation before organisational change.

> **Status:** MVP. One composed workflow (workforce planning before hiring), built from four gate skills. See `docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md` for the design and `docs/superpowers/plans/2026-08-17-hr-os-plugin-mvp.md` for how it was built.

## What this is

A set of Claude Code skills (`skills/*/SKILL.md`), installed the same way Superpowers is. There's no application code, no server, no database. Claude Code's own skill-discovery mechanism and each skill's explicit hard-gates enforce gate discipline, not a state machine.

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

## Installing

HR-OS isn't on Anthropic's official `claude-plugins-official` marketplace. It's self-hosted: this repo carries its own marketplace manifest (`.claude-plugin/marketplace.json`), and adding it points Claude Code at this specific repo, not any curated directory.

### Claude Code

From any directory, no clone required:

```bash
claude plugin marketplace add simonives/HR-OS
claude plugin install hr-os@hr-os-dev
```

Or, from inside an interactive Claude Code session:

```
/plugin marketplace add simonives/HR-OS
/plugin install hr-os
```

Working from a local clone of this repo instead, point at the marketplace file directly:

```bash
claude plugin marketplace add ./.claude-plugin/marketplace.json
claude plugin install hr-os@hr-os-dev
```

Either invoke a skill directly by name (e.g. `hr-os-workforce-planning`) when working through a hiring decision, or ask Claude to help with a workforce-planning decision and let the skill-discovery mechanism surface it.

### Claude Desktop

Desktop's local installer takes a packaged file, not a repository. Download the latest `hr-os-vX.Y.Z.zip` from the [Releases page](https://github.com/simonives/HR-OS/releases), then add it through Desktop's plugin settings (browse to the file, or drag it in). Each tagged release publishes this zip automatically.

## Example prompts

Try one of these once installed:

- "One of my managers wants to backfill a role that's been vacant for two months. Can you help me think this through?"
- "Help me plan a workforce decision for a new product line launching in six months. Headcount is genuinely uncertain."
- "Use hr-os-workforce-planning to help me plan a hire."

See [`docs/example-prompts.md`](docs/example-prompts.md) for a fuller set, including prompts that show the gates holding up under pressure (someone trying to skip a step, approve their own plan, or talk the model into treating an unverified claim as fact).

## Resource library

`hr-os-workforce-planning` grounds itself in `resources/business_partnering/workforce_planning/` when that path exists locally. `resources/` is a gitignored, local-only reference corpus a maintainer can optionally populate for grounding (see `PROJECT_STANDARDS.md` for how); it doesn't ship with this repo or install with the plugin. The skill checks for it and works correctly either way. If the path is populated, it grounds the role-design stage in real reference material. If it's sparse or absent, the default for anyone installing the plugin, it says so explicitly and falls back to general HR expertise instead of inventing grounding it doesn't have.

## Extending beyond the MVP

- **New gate-typed skills:** `hr-os-structured-investigation` (structured fact-finding before adverse action on a person) is designed in the spec but not yet built. No workflow needs it until an employee-relations skill is added.
- **New domain workflows:** compose the existing four gate skills the way `hr-os-workforce-planning` does, following its pattern.
- **Audit trail / governance logging:** deferred until this plugin has proven out in real use. See the design spec's "Explicitly out of scope" section.
- **Cross-provider ports:** the skill content is written to be portable in principle. No port to another provider's instruction format exists yet.
