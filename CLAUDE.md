# hr-os: Contributor Guidance (Claude Code)

This file guides *development and maintenance* of hr-os. It is not shipped as part of the plugin, an end user installing hr-os never sees this file. See `PROJECT_STANDARDS.md` for the detailed engineering/content standards this file assumes.

## The standing rule: no source-organisation references in shipped content

Nothing in `skills/*.md`, `README.md`, `.claude-plugin/*.json`, or `resources/` may name any specific organisation, or reproduce or brand-reference any specific company's proprietary operating-system/management-framework terminology. hr-os's gate model is deliberately generic, recognisable to any large enterprise HR function, tied to none. This applies to grounding sources too: when a design decision or piece of skill content is informed by a real company's internal practice, describe the *pattern* generically (as `docs/superpowers/specs/2026-08-18-hr-os-operating-model-alignment.md` does), never the source.

This rule governs shipped content only. This file itself, `PROJECT_STANDARDS.md`, and anything under `docs/` are contributor-facing, not shipped, but stay disciplined about it anyway, since this is a public repo.

## Grounding new or revised skill content

When designing, extending, or reviewing a gate skill or domain workflow, three kinds of input are available to sanity-check the work. Draw on whichever are configured in your session:

**1. Structured operational-management tooling, if configured locally.** If your session exposes an MCP server providing structured problem-solving, maturity-assessment, or golden-thread/traceability tools grounded in a real large-enterprise operating system, use it to check a gate's design against how mature operational practice actually structures the work (this is how the workforce-planning MVP's complexity-routing, evidence-backed demand signals, purpose traceability, and feed-forward requirements were validated during design; see the operating-model alignment spec). Never name the specific framework, vendor, or source organisation in anything that ships, translate the finding into hr-os's own generic terms, the way the four gate skills already do.

**2. The `mcp__research__` literature toolset**, for grounding a gate or domain workflow in actual HR research and evidence-based practice rather than assumption: `search-literature`, `appraise-evidence`, `appraise-source`, `synthesise-evidence`, `translate-to-practice`, `extract-from-pdf`, `people-analytics-preset`, `workforce-survey-template`. Useful for checking a proposed gate's requirements against what the literature actually says works, not just what seems reasonable.

**3. The local Calibre HR library** at `~/ebooks/` (metadata at `~/ebooks/metadata.db`), roughly 875 books including deep, specifically HR-relevant literature: people analytics, total rewards, workforce planning, HR service delivery, talent acquisition, organisational design, HR technology transformation, and classics like Ulrich's *HR From the Outside In*. Query the catalogue directly before assuming a topic isn't covered:

```bash
sqlite3 ~/ebooks/metadata.db "
  SELECT b.title, a.name
  FROM books b
  JOIN books_authors_link bal ON b.id = bal.book
  JOIN authors a ON bal.author = a.id
  WHERE lower(b.title) LIKE '%<topic>%';
"
```

Then extract and read the relevant text with the `pdf` skill (or equivalent for other formats) before drafting or revising skill content. This is the same ingestion pattern `PROJECT_STANDARDS.md` §4 already defines (Parent summary + Child verbatim chapters under `resources/[pillar]/[domain]`), the Calibre catalogue is an additional source for that pipeline, alongside one-off drops in `/ingestion_chamber/`.

**Known gap this closes:** `resources/business_partnering/workforce_planning/` currently has no populated reference content (see its own README), a strong first candidate for this pipeline, since the Calibre library includes at least one title on strategic workforce planning frameworks directly.
