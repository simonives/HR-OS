# hr-os operating-model alignment

**Status:** analysis, informing roadmap — not an implementation spec in its own right
**Grounded against:** a real enterprise HR functional operating model (internal document, not reproduced here — see below)

## Purpose

hr-os's domain taxonomy (`resources/`) and MVP gate sequence were designed against general HR-operating-model knowledge. This document checks that design against a real, detailed enterprise HR operating model — an internal accountability framework for a large global mining company's HR function, reviewed for this purpose but not reproduced or referenced by name anywhere in hr-os itself. The structure is a standard, recognisable shape for any large enterprise HR function (Ulrich-derived: strategic/CoE layer, business-partnering layer, shared-services layer, governance layer, plus a specialist employee-relations function), not something specific to one company — which is exactly why it's useful as a validation source without needing to name its origin.

## What the real model is structured like

Two layers:

1. **Accountabilities by sub-function** — eight sub-functions, each with a detailed accountability list: Employee Relations; HR Business Partnership & Consulting; Workforce Strategy & Development (leadership development, learning, organisational design, org development & analytics); Reward (including global mobility, executive remuneration); Talent & Performance (performance, EVP, talent, talent acquisition, inclusion & diversity); HR Governance (functional integrity, privacy/data ethics, digital tech & strategy, risk & governance); a payroll-improvement programme; and a shared-services delivery layer executing the transactional work all the other sub-functions generate.

2. **Accountabilities by key process** — roughly ten processes given explicit Accountable/Consulted/Informed maps, specifically because ownership collides across sub-functions on these: strategic workforce planning, enterprise bargaining, managing underperformance, employment contracts, employing entity, classification of employees, graduate management, HR operational escalation, obtaining legal advice, HR reporting.

## Domain taxonomy: sub-function → hr-os domain

| Operating-model sub-function (genericised) | hr-os domain | Fit |
|---|---|---|
| Employee Relations | `centres_of_excellence/employee_relations_and_compliance` | Clean |
| HR Business Partnership & Consulting | `business_partnering` | Clean |
| Workforce Strategy & Development | `centres_of_excellence/learning_and_development` + `business_partnering/organisational_design` + `people_analytics` | Clean, but split across three hr-os domains where the real model treats it as one sub-function |
| Reward | `centres_of_excellence/total_rewards` | Clean |
| Talent & Performance | `centres_of_excellence/talent_management` + `talent_acquisition` + `diversity_equity_inclusion` | Clean |
| HR Governance | `digital_hr_and_transformation` | **Partial — see Gap 1** |
| Payroll-improvement programme | `hr_service_delivery/payroll_services` | Clean, genericised as "payroll compliance & remediation" |
| Shared-services delivery layer | `hr_service_delivery` | Clean — this domain already models exactly this |
| *(no sub-function equivalent)* | `employee_experience` | **No clean equivalent — see Gap 2** |

## Gap 1: governance deserves peer-domain weight, not a subtopic of digital transformation

In the real model, HR Governance is a full peer sub-function — it owns risk, data ethics, policy, and functional integrity as its own remit, with digital strategy as one component among four, not the whole of it. hr-os currently folds governance into `digital_hr_and_transformation`, which under-weights it relative to how a mature operating model actually structures accountability.

**Implication for roadmap:** a future `hr-os-policy-design` domain workflow (evidence-based policy design, gated by `problem-framing` → `success-criteria-first` → `calibration-and-consultation` with mandatory legal/compliance review → `outcome-verification`) would give governance its own gated workflow rather than leaving it implicit. This was one of the three MVP candidates considered at the start of this project and not chosen — the real operating model is independent evidence it's a legitimate next domain, not just a leftover option.

## Gap 2: Employee Experience is diffused in the real model, not a standalone pillar

The real model has no Employee Experience sub-function. EVP and candidate marketing sit under Talent & Performance; culture sits under Workforce Strategy & Development's org-development work. hr-os inherited "Employee Experience" as a standalone top-level domain from a different, more contemporary HR-taxonomy tradition (the kind that treats employee experience as its own discipline alongside the CoE/business-partnering/shared-services split).

Both framings are legitimate HR practice. This is a decision to make deliberately, not an error to fix: **keep** Employee Experience as a standalone domain (bets on the contemporary framing being where practice is heading) or **fold it** into Talent & Performance and Workforce Strategy & Development (matches this real-world precedent more closely). No action taken here — flagged for a decision when it's actually load-bearing (i.e. when a domain workflow in that space gets built).

## Roadmap: what the RACI-process layer validates

The real model's second layer — explicit Accountable/Consulted/Informed maps for processes where sub-function ownership collides — is structurally identical to what `hr-os-calibration-and-consultation` exists to enforce: the right second party reviews before a decision lands, at a depth matched to the stakes. Two processes stand out when evaluated against how cleanly their real RACI structure already maps onto hr-os's gate sequence:

1. **Managing Underperformance — strongest next domain workflow.** The real model's own structure (establish the performance framework → identify underperformance → determine and execute the required action, with an explicit escalation path once informal support hasn't resolved it) maps almost directly onto `hr-os-problem-framing` → `hr-os-structured-investigation` → `hr-os-calibration-and-consultation`. This is the one gate skill in the design spec (`docs/superpowers/specs/2026-08-17-hr-os-plugin-design.md`) with no workflow exercising it yet, and it was the MVP candidate not chosen at project start (workforce planning was chosen instead, as the lower-stakes first proof). The real operating model independently validates it as the strongest second slice — not a new idea, confirmation of an existing one.

2. **Strategic Workforce Planning — validates, doesn't extend, the existing MVP.** Its RACI (framework/process ownership vs. plan ownership vs. implementation governance) maps onto `hr-os-workforce-planning`'s existing five-stage structure without suggesting any change to it. Read as confirmation the MVP's stage boundaries are realistic, not as a roadmap item.

Lower-priority future candidates surfaced by the remaining processes, roughly in order of how transactional (vs. judgement-heavy) they are — better suited to `hr_service_delivery`-style workflows than gate-heavy ones: employment contracts, employing entity determination, classification of employees, HR operational escalation. These don't need the full four-gate treatment; a lighter pattern (likely just `problem-framing` + `outcome-verification`, skipping the heavier design/consultation gates) would fit their actual stakes better once any of them gets built.

## Explicitly not done here

- No change to hr-os's shipped skills or domain taxonomy — this is analysis, not implementation. Any of the roadmap items above needs its own brainstorming → spec → plan cycle when it's actually taken up.
- No decision made on Gap 2 (Employee Experience) — deliberately left open until it's load-bearing.
- The source operating-model document is not reproduced, quoted at length, or named here or anywhere else in this repo, consistent with keeping hr-os itself free of any single organisation's internal terminology or branding.
