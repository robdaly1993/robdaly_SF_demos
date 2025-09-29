# AdTech Snowflake Intelligence Demo

This demo mirrors the structure of the original Snowflake Intelligence Demo but targets AdTech quality and verification analytics using vendor-agnostic ad quality concepts (brand safety, fraud/IVT, viewability, AVOC).

## Setup

1) Push this folder to your Git provider (GitHub/GitLab).
2) In Snowflake, run the single setup script:

```sql
-- In a Snowflake SQL worksheet
/sql_scripts/adtech_setup.sql
```

The script will:
- Create role and warehouse (`ADTECH_Intelligence_Demo`, `ADTECH_demo_wh`)
- Create database and schema (`ADTECH_AI_DEMO.DEMO_SCHEMA`)
- Create Git integration and repo pointer (update ORIGIN to your Git URL)
- Create stage, copy demo CSVs and unstructured docs
- Create all AdTech dimension/fact tables and load data
- Create semantic view `ADTECH_QUALITY_SEMANTIC_VIEW`
- Parse unstructured docs and create a single search service `Search_adtech_docs`

## Data Model

- Dimensions: advertisers, campaigns, publishers, placements, creatives, devices, geo, exchanges, channels, quality segments
- Facts:
  - `ad_impressions_fact`: delivery, measured, viewable, AVOC, blocked/fraud/unsafe, cost
  - `verification_fact`: segment-level measured, risky, blocked

## Key Metrics

- CTR, Viewability Rate, AVOC Rate
- Blocked/Fraud/Unsafe Rates
- eCPM (media cost based)

## Unstructured Documents

Located under `unstructured_docs/` and include policies, CTV playbooks, and a sample quality report. These are parsed into a search index for semantic Q&A.

## Example Questions

- "Show AVOC and Viewability by campaign last 7 days"
- "Which publishers have the highest unsafe rate?"
- "Trend blocked rate by device type and exchange"
- "What’s our CPM and fraud rate by channel?"

## Notes

- If you also want an Intelligence Agent, mirror the pattern used in the retail demo and point text-to-SQL to `ADTECH_QUALITY_SEMANTIC_VIEW` and search to `Search_adtech_docs`.
- Update the Git repo `ORIGIN` in `sql_scripts/adtech_setup.sql` to your target repository before running.
