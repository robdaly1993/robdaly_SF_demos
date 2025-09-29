# AdTech Snowflake Intelligence Demo

This demo showcases Snowflake Intelligence capabilities for AdTech quality and verification analytics using vendor-agnostic ad quality concepts (brand safety, fraud/IVT, viewability, AVOC).

## Features

- **Full Year of Data**: 10,852+ impression records across 365 days (2025)
- **Comprehensive Metrics**: Viewability, AVOC, fraud, blocked impressions, brand safety, CTR, CPM
- **Semantic View**: Natural language queries via Cortex Analyst
- **Document Search**: Cortex Search over policies and playbooks
- **Web Scraping**: Competitive intelligence and industry benchmarking
- **Intelligence Agent**: Multi-tool AI orchestration

## Quick Setup

### 1. Initial Setup (One-Time)
Run in Snowflake SQL worksheet:
```sql
/sql_scripts/adtech_setup.sql
```

Creates:
- Role: `ADTECH_Intelligence_Demo`
- Warehouse: `ADTECH_demo_wh`
- Database: `ADTECH_AI_DEMO.DEMO_SCHEMA`
- Git integration pointing to this repo
- All tables with full year of data
- Semantic view: `ADTECH_QUALITY_SEMANTIC_VIEW`
- Search service: `Search_adtech_docs`
- Intelligence Agent: `AdTech_Quality_Agent`

### 2. Add Web Scraping (Optional but Recommended)
```sql
/sql_scripts/add_web_scraping.sql
```

Enables competitive analysis and industry benchmark research.

### 3. Refresh Data (After Updates)
```sql
/sql_scripts/refresh_data.sql
```

Pulls latest data from GitHub without recreating everything.

## Data Model

### Dimensions (10 tables)
- `advertiser_dim` (6 advertisers)
- `campaign_dim` (6 campaigns)
- `publisher_dim` (6 publishers)
- `placement_dim` (6 placements)
- `creative_dim` (5 creatives)
- `device_dim` (6 device types)
- `geo_dim` (6 regions)
- `exchange_dim` (5 exchanges)
- `channel_dim` (3 channels)
- `quality_segment_dim` (5 quality segments)

### Facts (2 tables)
- `ad_impressions_fact`: 10,852 records (full year 2025)
  - Impressions, clicks, measured, viewable, AVOC
  - Blocked, fraud, unsafe impressions
  - Media cost
- `verification_fact`: 21,684 records
  - Segment-level quality checks
  - Risky and blocked impressions by category

### Key Metrics
- **CTR**: Click-through rate
- **Viewability Rate**: Viewable/measured impressions
- **AVOC Rate**: Audible & viewable on completion
- **Block Rate**: Blocked/measured impressions
- **Fraud Rate**: Fraud/measured impressions
- **Unsafe Rate**: Unsafe/measured impressions
- **CPM**: Cost per thousand impressions

## Using the Intelligence Agent

### Access
1. Go to **AI/ML** → **Snowflake Intelligence** in Snowflake UI
2. Select **AdTech Quality Agent** from the dropdown

### Example Questions

#### Performance Analysis
- "What is the viewability rate by publisher last 30 days?"
- "Show me AVOC and viewability trends by device type over time"
- "Which campaigns have the highest fraud rate?"
- "Compare CPM by exchange and channel for Q1 2025"
- "What's our click-through rate by ad format?"

#### Quality & Safety
- "Show blocked impression trends by quality segment"
- "Which publishers have the highest unsafe rate?"
- "Trend fraud rate by exchange over the last 90 days"
- "What percentage of impressions are blocked for brand safety?"

#### Policy & Documentation
- "What are our brand safety policies?"
- "Show me the CTV brand safety playbook guidelines"
- "What's our fraud prevention strategy?"

#### Competitive Intelligence (with web scraping)
- "Get viewability benchmarks from [industry report URL] and compare to our performance"
- "Look up DoubleVerify's fraud detection capabilities and compare to our fraud rates"
- "What does IAS say about AVOC benchmarks? How do we compare?"
- "Research current industry standards for brand safety and summarize"

## Unstructured Documents

Located in `unstructured_docs/`:
- **Policies**: Brand safety policy, fraud prevention guide
- **Playbooks**: CTV brand safety playbook, programmatic QA checklist
- **Reports**: Monthly quality report sample

All documents are parsed and searchable via Cortex Search.

## Architecture

```
GitHub Repo (robdaly1993/robdaly_SF_demos)
  ↓
Git Integration (ADTECH_DEMO_REPO)
  ↓
Internal Stage (INTERNAL_DATA_STAGE)
  ↓
Tables (10 dims + 2 facts) → Semantic View → Cortex Analyst
                           ↓
Unstructured Docs → Parsed Content → Cortex Search
                                   ↓
                            Intelligence Agent ← Web Scraping Function
                                   ↓
                              User Queries
```

## Files

- `sql_scripts/adtech_setup.sql`: Complete initial setup
- `sql_scripts/add_web_scraping.sql`: Add web scraping capability
- `sql_scripts/refresh_data.sql`: Reload data from GitHub
- `demo_data/*.csv`: Full year of sample data
- `unstructured_docs/`: Policies, playbooks, reports

## Notes

- Data covers entire year 2025 (Jan 1 - Dec 31)
- Metrics include realistic variance and seasonality
- Web scraping respects robots.txt and rate limits
- Git integration auto-pulls from `main` branch

## Support

For issues or questions, refer to the Snowflake Intelligence documentation or modify the semantic view and agent specifications as needed.
