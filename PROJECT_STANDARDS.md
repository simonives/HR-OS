# Contributor & Project Standards

This document establishes the definitive engineering, architectural, and stylistic guidelines for the `hr-os` Claude Code plugin repository. All collaborators (human and AI) must adhere to these structural guardrails to ensure functional integrity and a consistent operational rhythm.

---

## 1. Persona & Lexicon

All documentation, output generation, and structural naming conventions must strictly follow the core persona parameters:

*   **Language:** Australian English (e.g., `organise`, `centres_of_excellence`, `programme`).
*   **Voice:** Strictly Active Voice. Passive constructions are forbidden.
*   **Tone:** Formal, collaborative, and strategic. Avoid cliché jargon (e.g., "boiling the ocean", "synergistic paradigms").
*   **Audience:** Targeted toward Senior Leadership, HR Practitioners, and People Leaders.

---

## 2. No Source-Organisation References in Shipped Content

Nothing in `skills/*.md`, `README.md`, `.claude-plugin/*.json`, or a locally-populated `resources/` (gitignored, never tracked, see §5) may name any specific organisation, or reproduce or brand-reference any specific company's proprietary operating-system or management-framework terminology. hr-os's gate model is deliberately generic, recognisable to any large enterprise HR function, tied to none.

This applies to grounding sources too. When a design decision or piece of skill content is informed by a real company's internal practice, describe the *pattern* generically (as `docs/superpowers/specs/2026-08-18-hr-os-operating-model-alignment.md` does), never the source, regardless of what other context is available to you when writing it.

This rule governs shipped content only. Contributor-facing material (this file, anything under `docs/`, and any local, gitignored notes you keep for your own workflow) isn't shipped, but stay disciplined about it anyway, since this is a public repo.

---

## 3. Directory Taxonomy (The Ulrich Model)

The `/resources/` directory maintains a strict, functional HR taxonomy based on an enterprise-scale Dave Ulrich operating model. Do **not** place reference materials in arbitrary locations. They must fundamentally map into one of the following 6 pillars:

1.  **`business_partnering/`**: For workforce planning, ORG design, and HRBP strategy.
2.  **`centres_of_excellence/`**: For deep "hire-to-retire" specialisations (Talent Acquisition, L&D, Total Rewards, Employee Relations, DEI).
3.  **`hr_service_delivery/`**: For Shared Services/Global Business Services (Core HR, Payroll, Global Mobility).
4.  **`employee_experience/`**: For culture strategy and workplace design.
5.  **`people_analytics/`**: For workforce research and reporting.
6.  **`digital_hr_and_transformation/`**: For functional systems, AI, and strategic architecture.

---

## 4. The Parent-Child Knowledge Hierarchy

To optimise the AI's Context Window, unstructured reference material (such as full-text Policies, EPUBs, PDFs, etc.) **must not** be read verbatim by a skill at runtime. They must be ingested using a Parent-Child architecture:

*   **The Parent Node (`<title>_summary.md`):** A distilled, high-level summary resting at the root of the domain. It features an Executive Thesis, key models, and crucially, a **Context Routing Table** linking specific use-cases directly to the child files.
*   **The Child Nodes (`references/<title>/chapter_**.md`):** Verbatim, parsed markdown chunks housed discretely in a references sub-folder. The AI only traverses to these files if directed by the Parent Node.

### Schema: Parent Document (`<title>_summary.md`)
```markdown
---
title: [Document Title]
author: [Author or Issuing Body]
domain: [HR Operating Model Domain]
ingested_date: [Date]
---

# Executive Thesis
[1-2 paragraphs identifying the source's core theory or intent].

## Key Architectures & Frameworks
*   **[Framework]**: [Definition].

## Strategic Imperatives
*   [Actionable Exec Summary Point 1].

## Context Routing Table (Chapter Highlights)
### 1. [Chapter or Section Title]
*   **Core Insight:** [Insight].
*   **Use-Case:** Retrieve this when [Specific Trigger].
*   **Reference:** [Absolute Path to Child Chapter MD file]
```

---

## 5. Operational Protocol: Executing Reference Ingestion

Reference material isn't limited to published books. A contributor's own enterprise policies, standards, procedures, industry guides, or any other source document all follow the same protocol: stage it, extract it, distil it, never ship the raw source.

`/ingestion_chamber/` and `/resources/` are both gitignored, local-only working areas, listed in `.gitignore` for exactly this purpose. Nothing produced by this workflow is ever committed or shipped with the plugin. This repo's history was once rewritten to remove copyrighted book content (including raw source files) that got tracked by mistake under an earlier version of this pipeline, treat that as the standing reason these two directories stay out of version control permanently, regardless of what's placed in them, who placed it, or how it was obtained.

**Execution Workflow:**
1.  **Stage:** Place the raw source document within `/ingestion_chamber/` at the repository root.
2.  **Extract:** Convert the document to markdown using whatever tool suits its format and your own environment (an EPUB or PDF converter, a direct copy for already-plain-text material, etc.). The specific tool is a local choice, not part of this protocol.
3.  **Consume & Distil:** Read the generated content. Infer the thesis and frameworks strictly *after* scanning the output, to preserve the source's actual intent rather than a paraphrase of assumptions about it.
4.  **Deploy:**
    *   Draft the Parent Document into the appropriate `/resources/[pillar]/[domain]` directory.
    *   Move the extracted child markdown into a sibling `/references/[title]/` folder.
5.  **Purge:** Permanently delete the original source file from `/ingestion_chamber/` once ingestion is verified, nothing raw stays staged longer than the ingestion pass itself.
