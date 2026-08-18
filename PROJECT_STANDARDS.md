# Contributor & Project Standards

This document establishes the definitive engineering, architectural, and stylistic guidelines for the `hr-os` Claude Code plugin repository. All collaborators (human and AI) must adhere to these structural guardrails to ensure functional integrity and a consistent operational rhythm.

---

## 1. Persona & Lexicon

All documentation, output generation, and structural naming conventions must strictly follow the core persona parameters:

*   **Language:** Australian English (e.g., `organise`, `centres_of_excellence`, `programme`).
*   **Voice:** Strictly Active Voice. Passive constructions are forbidden.
*   **Tone:** Formal, collaborative, and strategic. Avoid cliché jargon (e.g., "boiling the ocean", "synergistic paradigms").
*   **Audience:** Targeted toward Senior Leadership and Executive Committees at large enterprises.

---

## 2. Directory Taxonomy (The Ulrich Model)

The `/resources/` directory maintains a strict, functional HR taxonomy based on an enterprise-scale Dave Ulrich operating model. Do **not** place reference materials in arbitrary locations. They must fundamentally map into one of the following 6 pillars:

1.  **`business_partnering/`**: For workforce planning, ORG design, and HRBP strategy.
2.  **`centres_of_excellence/`**: For deep "hire-to-retire" specialisations (Talent Acquisition, L&D, Total Rewards, Employee Relations, DEI).
3.  **`hr_service_delivery/`**: For Shared Services/Global Business Services (Core HR, Payroll, Global Mobility).
4.  **`employee_experience/`**: For culture strategy and workplace design.
5.  **`people_analytics/`**: For workforce research and reporting.
6.  **`digital_hr_and_transformation/`**: For functional systems, AI, and strategic architecture.

---

## 3. The Parent-Child Knowledge Hierarchy

To optimise the AI's Context Window, unstructured reference material (such as full-text EPUBs) **must not** be directly parsed by the MCP dynamically. They must be ingested using a Parent-Child architecture:

*   **The Parent Node (`<title>_summary.md`):** A distilled, high-level summary resting at the root of the domain. It features an Executive Thesis, key models, and crucially, a **Context Routing Table** linking specific use-cases directly to the child files.
*   **The Child Nodes (`references/<title>/chapter_**.md`):** Verbatim, parsed markdown chunks housed discretely in a references sub-folder. The AI only traverses to these files if directed by the Parent Node.

### Schema: Parent Document (`<title>_summary.md`)
```markdown
---
title: [Book Title]
author: [Author Name]
domain: [HR Operating Model Domain]
ingested_date: [Date]
---

# Executive Thesis
[1-2 paragraphs identifying the author's core theory].

## Key Architectures & Frameworks
*   **[Framework]**: [Definition].

## Strategic Imperatives
*   [Actionable Exec Summary Point 1].

## Context Routing Table (Chapter Highlights)
### 1. [Chapter Title]
*   **Core Insight:** [Insight].
*   **Use-Case:** Retrieve this when [Specific Trigger].
*   **Reference:** [Absolute Path to Child Chapter MD file]
```

---

## 4. Operational Protocol: Executing EPUB Ingestion

When a new EPUB reference is added to the system, it must be programmatically extracted and distilled.

**Execution Workflow:**
1.  **Stage:** Place the raw EPUB file within `/ingestion_chamber/` at the repository root.
2.  **Extract:** Within the chamber, run `epub2md` to convert the package into markdown.
    ```bash
    cd ingestion_chamber
    mkdir -p tmp_extract
    cp "reference.epub" tmp_extract/pilot.epub
    cd tmp_extract
    epub2md -c pilot.epub
    ```
3.  **Consume & Distil:** Read the generated child chapters. Infer the thesis and frameworks strictly *after* scanning the output to maintain the author's intent.
4.  **Deploy:**
    *   Draft the Parent Document into the appropriate `/resources/[pillar]/[domain]` directory.
    *   Move the child markdown files into a sibling `/references/[title]/` folder.
5.  **Purge:** Permanently delete the original EPUB from the `/ingestion_chamber/` once ingestion is successfully verified.
