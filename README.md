# Workforce Transformation MCP Server

An enterprise-grade [Model Context Protocol (MCP)](https://modelcontextprotocol.io) server covering the full breadth of Human Resources, People & Culture, and Workforce Management practice. This server surfaces tools, resources, and prompts to support every activity that an HR practitioner, supervisor, or employee could require — from operational tasks such as résumé screening through to strategic activities such as building a technology transformation roadmap.

> **Status:** Functional and under active development. Capabilities expand continuously as new tools, resources, and prompts are registered.

---

## Table of Contents

- [Purpose](#purpose)
- [Core Philosophy](#core-philosophy)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Capability Roadmap](#capability-roadmap)
- [Repository Structure](#repository-structure)
- [Regulatory & Compliance Framework](#regulatory--compliance-framework)
- [Localisation](#localisation)
- [Contributing](#contributing)
- [Licence](#licence)

---

## Purpose

The Workforce Transformation MCP server provides a single, authoritative integration point for AI-assisted Human Resources practice. It is designed to grow incrementally, beginning with foundational HR capabilities and expanding to cover every domain within a modern enterprise People function:

- **Operational HR** — recruitment, onboarding, offboarding, contract management, leave administration
- **Employee Relations** — case management, grievance handling, performance improvement
- **Learning & Development** — skills gap analysis, learning pathway design, capability frameworks
- **Workforce Planning** — demand forecasting, organisational design, spans-and-layers analysis
- **Reward & Recognition** — remuneration benchmarking, incentive design, total reward statements
- **HR Technology** — system selection, implementation roadmapping, integration architecture
- **People Analytics** — attrition modelling, engagement analysis, diversity reporting
- **Strategic HR** — business partnership, transformation programme design, change management

---

## Core Philosophy

All capabilities within this server operate against a **Strategic Value Framework** grounded in three principles:

1. **Human-Centricity** — Every output prioritises the wellbeing, dignity, and agency of people. Recommendations draw on flourishing-workplace theory and Socratic inquiry.
2. **Evidence-Based Practice** — Tools and prompts reference empirical research, statutory instruments, and established HR methodologies rather than convention or assumption.
3. **Regulatory Rigour** — Outputs are bounded by applicable AI legislation, employment law, and codes of conduct. The server maintains a structured regulatory knowledge base (see [Regulatory & Compliance Framework](#regulatory--compliance-framework)) to ensure all generated content remains compliant.

---

## Architecture

This server implements the MCP specification using the TypeScript SDK. It exposes three primitive types:

| Primitive | Description |
| :-------- | :---------- |
| **Tools** | Executable functions that perform discrete HR tasks (e.g. screen a résumé, draft a performance review). |
| **Resources** | Read-only knowledge assets the host or model can retrieve (e.g. legislative summaries, policy templates, competency frameworks). |
| **Prompts** | Reusable, parameterised prompt templates for common HR interactions (e.g. conduct investigation interview, workforce planning facilitation). |

The server communicates over **stdio** by default, making it compatible with any MCP host (Claude Desktop, Cursor, custom integrations, etc.).

### Technology Stack

| Component | Technology |
| :-------- | :--------- |
| Runtime | Node.js (ESM) |
| Language | TypeScript |
| MCP SDK | `@modelcontextprotocol/sdk` |
| Schema Validation | `zod` |
| Build | `tsc` |
| Dev Server | `tsx` |

---

## Installation

### Prerequisites

- Node.js ≥ 18
- npm ≥ 9

### Steps

```bash
# Clone the repository
git clone https://github.com/simonives/workforce_transformation.git
cd workforce_transformation

# Install dependencies
npm install

# Build the server
npm run build
```

---

## Configuration

### Claude Desktop

Add the following block to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "workforce-transformation": {
      "command": "node",
      "args": ["/absolute/path/to/workforce_transformation/dist/index.js"]
    }
  }
}
```

### Development Mode

Run the server directly without a build step using `tsx`:

```bash
npm run dev
```

---

## Capability Roadmap

The table below reflects the intended target state. Items marked **Planned** are not yet implemented; items marked **Active** are available in the current build.

### Tools

| Tool | Domain | Status |
| :--- | :----- | :----- |
| `screen-resume` | Recruitment | Planned |
| `draft-job-description` | Recruitment | Planned |
| `plan-workforce-immediate` | Workforce Planning (0–2 weeks) | Planned |
| `plan-workforce-short` | Workforce Planning (2–6 weeks) | Planned |
| `plan-workforce-medium` | Workforce Planning (6 months) | Planned |
| `plan-workforce-long` | Workforce Planning (12+ months) | Planned |
| `performance-review-optimiser` | Performance Management | Planned |
| `er-compliance-scanner` | Employee Relations | Planned |
| `org-modelling-audit` | Organisational Design | Planned |
| `skills-gap-analysis` | Learning & Development | Planned |
| `remuneration-benchmark` | Reward & Recognition | Planned |
| `transformation-roadmap` | HR Technology | Planned |

### Resources

| Resource URI | Content | Status |
| :----------- | :------ | :----- |
| `workforce://regulatory/ai-legislation` | Global AI legislation summaries | Planned |
| `workforce://regulatory/ai-codes-of-conduct` | AI codes of conduct (by jurisdiction) | Planned |
| `workforce://legal/employment-law` | Employment law summaries (by jurisdiction) | Planned |
| `workforce://strategy/org-design` | Organisational design principles | Planned |
| `workforce://lifecycle/employee` | End-to-end employee lifecycle standards | Planned |
| `workforce://frameworks/competency` | Competency framework library | Planned |

### Prompts

| Prompt | Use Case | Status |
| :----- | :------- | :----- |
| `conduct-investigation-interview` | Employee Relations | Planned |
| `facilitate-workforce-planning` | Workforce Planning | Planned |
| `coach-performance-conversation` | Performance Management | Planned |
| `design-change-communication` | Change Management | Planned |

---

## Repository Structure

```
workforce_transformation/
│
├── src/                          # All server source code
│   ├── index.ts                  # MCP server entry point; registers all primitives
│   │
│   ├── tools/                    # Tool definitions (executable HR functions)
│   │   └── (tools registered here as capabilities are built)
│   │
│   ├── resources/                # Resource definitions (read-only knowledge assets)
│   │   └── (resources registered here as knowledge is onboarded)
│   │
│   ├── prompts/                  # Prompt template definitions
│   │   └── (prompts registered here as templates are developed)
│   │
│   └── lib/                      # Shared utilities, validators, and helpers
│       └── (shared logic registered here)
│
├── dist/                         # Compiled JavaScript output (generated by tsc; not committed)
│
├── node_modules/                 # npm dependencies (not committed)
│
├── package.json                  # Project metadata and npm scripts
├── package-lock.json             # Locked dependency tree
├── tsconfig.json                 # TypeScript compiler configuration
├── .gitignore                    # Files and directories excluded from version control
├── LICENSE                       # Project licence
└── README.md                     # This file
```

> **Note:** A `regulatory/` directory will be added at the repository root to house raw legislative and policy source documents (e.g. AI Acts, employment statutes, codes of conduct). These static assets inform the resource layer and ensure generated outputs remain compliant.

---

## Regulatory & Compliance Framework

This server maintains a structured knowledge base of regulatory instruments to bound all generated content. The initial tranche of content — to be onboarded shortly — covers:

- **AI Legislation** — applicable statutes and regulations governing the development and deployment of AI systems (e.g. EU AI Act, emerging national frameworks).
- **AI Regulations** — subordinate instruments, guidance notes, and technical standards issued under primary AI legislation.
- **AI Codes of Conduct** — voluntary and mandatory codes governing responsible AI use in workplace and enterprise contexts.

These instruments are referenced by resources exposed under the `workforce://regulatory/` URI namespace and are cited in tool and prompt outputs where compliance obligations apply.

> As the server expands into specific jurisdictions, localised regulatory content will be included for each supported locale.

---

## Localisation

This is a **global repository**. All capabilities are designed to support multi-jurisdictional operation, with locale-specific variations managed through:

- Jurisdiction-scoped resources (e.g. `workforce://legal/employment-law/au`, `workforce://legal/employment-law/gb`)
- Locale parameters on tools and prompts where outputs differ by jurisdiction
- A `locales/` directory (to be created) housing jurisdiction-specific overrides and addenda

Current localisation priorities and supported jurisdictions will be documented here as they are onboarded.

---

## Contributing

Contributions, issues, and feature requests are welcome. Please open an issue to discuss proposed changes before submitting a pull request. All contributions must:

- Conform to the TypeScript coding standards defined in `tsconfig.json`
- Reference applicable regulatory instruments where the capability has compliance implications
- Include tool/resource/prompt descriptions sufficient for an MCP host to surface the capability correctly

---

## Licence

This project is licenced under the [ISC Licence](./LICENSE).