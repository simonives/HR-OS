# hr-os: a gated AI orchestrator for the HR Function

**Status:** approved design, pending implementation plan
**Supersedes:** the parked `workforce-transformation` MCP server concept (never implemented beyond an empty tool/prompt scaffold)

## Purpose

hr-os is a cross-platform AI orchestrator that runs enterprise HR workflows under explicit process discipline, modelled philosophically on Superpowers (github.com/obra/superpowers) and how Simon uses it in Claude Code. Superpowers gates a software dev/CI-CD lifecycle — brainstorm before building, diagnose before fixing, define done before doing, get reviewed before merging, verify before claiming success. hr-os gates the equivalent lifecycle for mature HR practice: workforce planning before hiring, structured investigation before disciplinary action, evidence-based design before policy, proper consultation before organisational change, and verification before a case or initiative is declared closed.

It is built as a **deployable enterprise artifact** — designed for governance sign-off (audit trail from day one), not a personal tool or an open-source community project (though nothing here precludes either later).

## What carries forward from the parked project

The parked repo (`workforce_transformation`) never got past an empty MCP scaffold — `src/tools/` and `src/prompts/` are empty, no server code exists. What *does* exist and carries forward unchanged is `src/resources/`: a curated HR knowledge library organised across six domains (business partnering, centres of excellence, digital HR & transformation, employee experience, HR service delivery, people analytics), each backed by real reference material (labour law manuals, HR risk management guides, etc.). This taxonomy is a legitimate contemporary HR operating model (Ulrich-style Business Partnering / CoE / Service Delivery, layered with Digital HR, Employee Experience, and People Analytics) and is independent of MCP vs. plugin architecture — it becomes the **grounding layer** gates pull from, not something rebuilt.

`src/tools/` and `src/prompts/` (empty, MCP-primitive-shaped) are deleted — they never held content and don't fit the new architecture.

## Why not MCP

MCP ties the integration to a single protocol most model providers don't speak natively. hr-os needs to run against Anthropic, OpenAI, DeepSeek, and others — so it is built as its own orchestrator: an application that itself calls whichever model API is configured, rather than a server one host's MCP client connects to.

## Why not prompt-only cross-platform discipline

Superpowers' gate discipline works because Claude Code's harness (SessionStart hook, Skill tool, enforced invocation) forces skill-checking. OpenAI, DeepSeek, and generic agent runtimes have no equivalent enforcement layer — a model can silently skip a documented step and nothing stops it. hr-os enforces gates **in code**: the orchestrator's state machine will not advance a workflow to the next stage until that stage's exit condition is met, regardless of which model is doing the work inside the stage. The model is swappable; the discipline is not.

## The five cross-cutting gates

Every domain workflow (employee relations, workforce planning, policy design, reward, L&D, etc.) is built by composing these five gate *types* in a domain-specific sequence — exactly as Superpowers composes brainstorming → planning → TDD → review → verification into any dev task regardless of what's being built.

| Superpowers skill | hr-os gate | What it gates |
|---|---|---|
| `brainstorming` | **problem-framing** | Before any intervention (policy, org change, role creation): an explicit statement of the problem, stakeholders, and constraints, before jumping to a solution. |
| `systematic-debugging` | **structured-investigation** | Before any adverse action on a person (disciplinary, PIP, termination): root-cause fact-finding before a remedy is proposed. No sanction-first reasoning. |
| `test-driven-development` | **success-criteria-first** | Before designing an intervention (policy, role, workforce plan): success criteria defined and agreed before the design work — what "working" looks like, measured how. |
| structured code review | **calibration-and-consultation** | Before a decision lands (rating, promotion, org change, policy): review by the right second party — calibration panel, legal/compliance, works council/union consultation as applicable. |
| `verification-before-completion` | **outcome-verification** | Before a case or initiative is declared closed: evidence that the outcome matches what was found/decided and that process was actually followed. |

Each gate has an `approvalType`:
- `auto-verified` — the orchestrator checks the artifact programmatically (e.g. "does a success-criteria object exist and is it non-empty").
- `human-approval` — the orchestrator halts and waits for an explicit approve/reject from the practitioner.

## Architecture

### Engine pattern: hand-rolled state machine

Each gated domain workflow is an explicit, fixed-sequence TypeScript state machine: named stages, entry preconditions, required artifacts, an `approvalType` per stage. The orchestrator walks the machine, calls the model provider to do the work *within* a stage, checks the stage's exit condition, and refuses to advance if it isn't met. The model does not choose or reorder stages — the sequence is fixed by domain design, matching how Superpowers' skills are fixed checklists rather than model-improvised plans.

Rejected alternatives: a declarative rules-engine/DSL (more extensible but more indirection and upfront engineering than one MVP slice justifies); LLM-orchestrated with a verifier model (reintroduces the exact failure mode being gated against — the model judging its own compliance).

### Provider abstraction

A minimal `ModelClient` interface (`complete(messages, tools?) → response`) with one concrete `AnthropicClient` for the MVP. No agent framework (LangChain, etc.) — just enough abstraction that `OpenAIClient` / `DeepSeekClient` slot in later without touching state-machine or gate code.

**Native tool use.** Each provider adapter reports which native tools it exposes (Anthropic: web search, code execution, bash, file tools, etc.; other providers expose their own, different sets). A gate stage requests a *capability* (e.g. "web search would help verify this benchmark"), not a specific tool name — the orchestrator resolves the request against whatever the active provider actually supports, and gates degrade gracefully (fall back to resource-library-only grounding) on a provider that lacks it. This keeps gate definitions provider-agnostic while still using each provider's real native tools rather than reimplementing them.

### Resource grounding

Each gate stage declares which `src/resources/` paths are relevant (e.g. the workforce-plan gate points at `business_partnering/workforce_planning/`). The orchestrator reads and injects that content into the model call at that stage. Simple file-based retrieval — no vector DB — the library is curated and small enough to address by path.

### Audit trail (governance-grade from the MVP)

Append-only SQLite log, one row per gate transition: case ID, gate name, timestamp, approval type, approver (human identity or `system`), evidence/artifacts cited, model + prompt version used, decision (advance/reject/reopen). Queryable directly — sufficient for a governance committee to reconstruct exactly what happened and why, without a bespoke audit UI in the MVP.

### Interface

Core orchestrator logic lives as a library, called by a CLI first (`hr-os plan-workforce`, `hr-os status <case-id>`, `hr-os approve <case-id> <gate>`). The CLI is a thin client over the same functions an HTTP API would call later — no rearchitecture needed to add an API surface once a workflow proves out.

### Repo shape (renamed to `hr-os`)

```
src/
  orchestrator/       # state machine engine, gate type definitions
  domains/
    workforce-planning/  # the MVP workflow
  providers/
    anthropic.ts
  resources/           # unchanged, re-pointed at from gate definitions
  audit/               # SQLite append-only log
  cli/                 # thin CLI over orchestrator functions
```

`package.json` name, repo name/remote, and README all move from `workforce-transformation` to `hr-os`.

### Naming check

`hr-os` / `hros` are unclaimed on npm and PyPI. No prominent GitHub org or repo owns it (a handful of near-zero-star hobby repos exist under other owners' namespaces — irrelevant, since GitHub scopes by owner and `simonives/hr-os` is free). `hr-os.com` and `hros.com` resolve but serve blank/parked pages with no extractable branding — low risk for an internal enterprise artifact; would only matter if `hr-os.com` were wanted for a future public site.

## MVP slice: workforce planning before hiring

`hr-os plan-workforce` walks a single domain workflow through all five gate types, end to end:

1. **Demand signal capture** (problem-framing) — what workforce need is being raised, by whom, against what constraint.
2. **Workforce plan gate** (success-criteria-first, human-approval) — headcount vs. plan, build/buy/borrow decision, grounded in `business_partnering/workforce_planning/`.
3. **Role design & levelling** (auto-verified where possible) — grounded in the resource library.
4. **Budget/approval gate** (calibration-and-consultation, human-approval) — may request web-search capability to check current market/industry benchmarks if the resource library isn't current enough.
5. **Requisition released** (outcome-verification) — confirms the requisition matches the approved plan before the case closes.

Scope: one domain, five gates, full audit trail, Anthropic only (provider abstraction built for more, not implemented for more yet).

## Explicitly out of scope for MVP

- OpenAI and DeepSeek provider adapters (abstraction supports them; not built/tested yet).
- HTTP API surface (core is API-shaped; the API itself isn't built).
- Any domain workflow beyond workforce planning (employee relations investigation, policy design, etc. — same pattern, future slices).
- Vector search / semantic retrieval over `src/resources/` (file-path-based grounding is sufficient at current library size).
- A rules-engine/DSL for authoring gates without touching code.
