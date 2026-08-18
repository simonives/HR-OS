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
