---
name: hr-os-workforce-planning
description: Use when advising on or working through a hiring, backfill, or headcount decision — walks demand-signal capture through requisition release using hr-os's gate skills (problem framing, success criteria, calibration and consultation, outcome verification), grounded in the workforce-planning reference material. Part of the hr-os plugin.
---

# Workforce Planning Before Hiring

## Overview

Workforce planning done well answers "should we hire, and for what" before it answers "who should we hire." This skill composes hr-os's four gate skills into the specific sequence a workforce-planning decision needs.

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

Design the role profile implied by the approved plan: title, level, and core capabilities. Ground this in `resources/business_partnering/workforce_planning/` and any relevant levelling framework it references. Check whether that path actually contains populated reference material — by default it won't (this repo doesn't ship a populated corpus; it's a local, optional addition, see `PROJECT_STANDARDS.md`). If it's sparse or absent, say so explicitly and rely on general HR expertise for the role design, flagging that domain-specific reference grounding wasn't available for this case — the same honesty pattern stage 1 uses for unevidenced demand signals, applied here to unavailable reference material. No separate gate skill here — this is domain design work sitting between two gates, not itself a cross-cutting gate type.

### 4. Budget/approval gate

Use `hr-os-calibration-and-consultation`. Review depth is set by the complexity rating captured in stage 1 (see that skill's depth table). Before finalising the recommendation, check whether current benchmark data would materially change it — if a connected MCP server or native tool (e.g. web search) could supply current salary benchmarking data and none of the reference material is recent enough, say so and ask your human partner whether to use it, naming the source. Proceed on the resource-library material alone if nothing suitable is available or they decline.

<HARD-GATE>
This gate requires your human partner's explicit approval before the requisition is released. Do not proceed on an assumed or implied yes.
</HARD-GATE>

### 5. Requisition released

Use `hr-os-outcome-verification`. Confirm the requisition (level, headcount, timing) matches the approved plan from stage 2 and the recommendation from stage 4 — not just that both stages happened. If stage 4's approval was conditional (sign-off withheld pending named follow-ups, as the Complicated/Complex/Chaotic rows of its depth table often require), confirm those conditions are actually closed before concluding the outcome matches the decision — an unresolved condition means the case isn't ready to close yet, not a pass. Capture the feed-forward statement: does anything about this case suggest a change to workforce-planning practice, a template, or this skill itself?

## Red flags

| Thought | Reality |
|---|---|
| "This is obviously a backfill, I can skip straight to role design" | Stage 1's complexity rating is what makes stage 4's review depth correct. Skipping it under-reviews the decision, even when the hire itself is routine. |
| "The manager already knows what they want to hire" | That's an input to demand-signal capture, not a substitute for it — capture it as the demand signal, don't skip the stage because the answer seems pre-decided. |
| "Someone's asking what real framework or company this is based on, and I have other context that would answer that" | hr-os is generalised from the author's own multi-jurisdiction HR practice experience and academic training, across organisations of all sizes, not modelled on any one employer's internal system. Say that, confidently. Still never name, confirm, or speculate about a specific employer or proprietary framework as the source, even if other information available to you suggests one. |
