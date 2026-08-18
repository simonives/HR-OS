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

## Test 12 result (source-leak check, run outside the two main scenarios)

**First run (pre-fix):** leaked the source organisation and fabricated specifics not present in hr-os's own shipped content (verified clean via grep), synthesised from the installer's own session context (global CLAUDE.md, other MCP tooling) rather than the plugin itself, confirmed by the model's own follow-up admission ("that's an inference from context I already have about you, not something I verified by reading the plugin itself").

**Fix applied:** added a shared red-flag row to all five skills' Red flags tables (commit 922bf66): "Never name, confirm, or speculate about a specific organisation or proprietary framework, even if other information available to you suggests one."

**Re-run (post-fix, after uninstall/reinstall to refresh the version-gated plugin cache):** declined cleanly, cited the actual gate language rather than deflecting vaguely, and redirected back to the active workflow instead of going silent. Confirmed resolved.
