# AdTech Demo - Technical Documentation

## Table of Contents
- [Overview](#overview)
- [Dimension Tables](#dimension-tables)
- [Fact Tables](#fact-tables)
- [Semantic View](#semantic-view)
- [Data Relationships](#data-relationships)
- [Metrics & Calculations](#metrics--calculations)
- [Search Services](#search-services)

---

## Overview

This demo uses a **star schema** design with:
- **10 dimension tables** (descriptive attributes)
- **2 fact tables** (measurable events/metrics)
- **1 semantic view** (natural language query layer)
- **1 search service** (unstructured document search)

### Database Structure
```
ADTECH_AI_DEMO
  └── DEMO_SCHEMA
      ├── Dimension Tables (10)
      ├── Fact Tables (2)
      ├── Semantic View (1)
      ├── Search Service (1)
      └── Functions (1 - web scraping)
```

---

## Dimension Tables

Dimension tables contain descriptive attributes that provide context to the facts. They are relatively static and typically have fewer rows.

### 1. `advertiser_dim`
**Purpose**: Brands/clients running ad campaigns

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `advertiser_key` | INT | Primary key | 1 |
| `advertiser_name` | VARCHAR(200) | Brand name | "Acme Retail" |
| `industry` | VARCHAR(100) | Business vertical | "Retail" |

**Sample Data**: 6 advertisers (Acme Retail, Globex Media, Initech Software, etc.)

---

### 2. `campaign_dim`
**Purpose**: Marketing campaigns run by advertisers

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `campaign_key` | INT | Primary key | 101 |
| `advertiser_key` | INT | Foreign key to advertiser | 1 |
| `campaign_name` | VARCHAR(300) | Campaign identifier | "Q4 Brand Safety Blitz" |
| `objective` | VARCHAR(100) | Campaign goal | "Brand Awareness" |
| `start_date` | DATE | Campaign start | 2025-01-01 |
| `end_date` | DATE | Campaign end | 2025-12-31 |

**Sample Data**: 6 campaigns across all advertisers

---

### 3. `publisher_dim`
**Purpose**: Websites/apps where ads appear

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `publisher_key` | INT | Primary key | 201 |
| `publisher_name` | VARCHAR(200) | Publisher name | "NewsNow.com" |
| `domain` | VARCHAR(200) | Website domain | "newsnow.com" |
| `app_bundle` | VARCHAR(200) | Mobile app ID | "com.streamzone.app" |
| `inventory_type` | VARCHAR(50) | Channel type | "Web", "App", "CTV" |

**Sample Data**: 6 publishers (mix of web, app, and CTV)

---

### 4. `placement_dim`
**Purpose**: Specific ad positions/formats

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `placement_key` | INT | Primary key | 301 |
| `placement_name` | VARCHAR(200) | Placement identifier | "Homepage Billboard" |
| `ad_format` | VARCHAR(100) | Format type | "Display", "Video", "Native" |
| `placement_type` | VARCHAR(100) | Buying method | "Direct", "Programmatic" |

**Sample Data**: 6 placements (mix of display, video, native)

---

### 5. `creative_dim`
**Purpose**: Ad creative assets

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `creative_key` | INT | Primary key | 401 |
| `creative_id` | VARCHAR(100) | Creative identifier | "CR-300x250-A" |
| `size` | VARCHAR(50) | Ad dimensions | "300x250" |
| `duration_seconds` | INT | Video length (null for display) | 15 |

**Sample Data**: 5 creatives (display + video formats)

---

### 6. `device_dim`
**Purpose**: User device types

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `device_key` | INT | Primary key | 501 |
| `device_type` | VARCHAR(50) | Device category | "Desktop", "Mobile", "CTV", "Tablet" |
| `os` | VARCHAR(50) | Operating system | "Windows", "iOS", "Android", "tvOS" |

**Sample Data**: 6 device/OS combinations

---

### 7. `geo_dim`
**Purpose**: Geographic targeting

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `geo_key` | INT | Primary key | 601 |
| `country` | VARCHAR(50) | Country code | "US", "CA", "UK" |
| `region` | VARCHAR(50) | State/province | "CA", "NY", "ON" |
| `dma` | VARCHAR(20) | Designated Market Area | "807", "501" |

**Sample Data**: 6 geographic regions

---

### 8. `exchange_dim`
**Purpose**: Programmatic ad exchanges

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `exchange_key` | INT | Primary key | 701 |
| `exchange_name` | VARCHAR(100) | SSP/Exchange name | "OpenX", "Magnite", "Index Exchange" |

**Sample Data**: 5 major exchanges

---

### 9. `channel_dim`
**Purpose**: High-level inventory channels

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `channel_key` | INT | Primary key | 801 |
| `channel_name` | VARCHAR(50) | Channel type | "Web", "App", "CTV" |

**Sample Data**: 3 channels

---

### 10. `quality_segment_dim`
**Purpose**: Ad quality/safety categories

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `segment_key` | INT | Primary key | 901 |
| `segment_name` | VARCHAR(200) | Quality issue type | "Brand Safety: Hate Speech" |
| `category` | VARCHAR(100) | High-level category | "Brand Safety", "Fraud" |

**Sample Data**: 5 quality segments (brand safety + fraud types)

---

## Fact Tables

Fact tables contain measurable events and foreign keys to dimensions. They have many rows and support aggregation.

### 1. `ad_impressions_fact`
**Purpose**: Core impression delivery and quality metrics

**Size**: 10,852 records (full year 2025)

| Column | Type | Description | Typical Range |
|--------|------|-------------|---------------|
| `record_id` | INT | Primary key | 1-10852 |
| `date` | DATE | Impression date | 2025-01-01 to 2025-12-31 |
| `advertiser_key` | INT | FK to advertiser_dim | 1-6 |
| `campaign_key` | INT | FK to campaign_dim | 101-106 |
| `placement_key` | INT | FK to placement_dim | 301-306 |
| `creative_key` | INT | FK to creative_dim | 401-405 |
| `publisher_key` | INT | FK to publisher_dim | 201-206 |
| `exchange_key` | INT | FK to exchange_dim | 701-705 |
| `device_key` | INT | FK to device_dim | 501-506 |
| `geo_key` | INT | FK to geo_dim | 601-606 |
| `channel_key` | INT | FK to channel_dim | 801-803 |
| `impressions` | INT | Total impressions served | 10,000-100,000 |
| `clicks` | INT | User clicks | 10-1,000 |
| `measured_impressions` | INT | Impressions measured for quality | 92-99% of impressions |
| `viewable_impressions` | INT | Met viewability standard (MRC) | 60-85% of measured |
| `avoc_impressions` | INT | Audible & Viewable On Completion | 35-60% of measured |
| `blocked_impressions` | INT | Blocked pre-bid or post-bid | 0.5-1.5% of measured |
| `fraud_impressions` | INT | Detected as invalid traffic | 0.1-0.8% of measured |
| `unsafe_impressions` | INT | Brand safety violations | 0.2-1.0% of measured |
| `media_cost` | DECIMAL(12,2) | Cost in dollars | $100-$5,000 |

**Grain**: One row per day per advertiser/campaign/publisher/placement combination

---

### 2. `verification_fact`
**Purpose**: Granular quality checks by segment type

**Size**: 21,684 records (1-3 per impression record)

| Column | Type | Description | Typical Range |
|--------|------|-------------|---------------|
| `verification_id` | INT | Primary key | 1-21684 |
| `date` | DATE | Verification date | 2025-01-01 to 2025-12-31 |
| `campaign_key` | INT | FK to campaign_dim | 101-106 |
| `placement_key` | INT | FK to placement_dim | 301-306 |
| `segment_key` | INT | FK to quality_segment_dim | 901-905 |
| `measured_impressions` | INT | Impressions checked for this segment | 80-100% of fact measured |
| `risky_impressions` | INT | Flagged as risky | 1-5% of measured |
| `blocked_impressions` | INT | Actually blocked | 30-70% of risky |

**Grain**: One row per day per campaign/placement per quality segment

---

## Semantic View

The semantic view (`ADTECH_QUALITY_SEMANTIC_VIEW`) provides a natural language query layer over the star schema.

### Structure

```
SEMANTIC VIEW
├── Tables (aliases for physical tables)
├── Relationships (foreign key mappings)
├── Facts (measurable columns)
├── Dimensions (descriptive attributes)
└── Metrics (calculated KPIs)
```

### Tables Section
Maps physical table names to semantic aliases:

```sql
ADVERTISERS as ADVERTISER_DIM
CAMPAIGNS as CAMPAIGN_DIM
PUBLISHERS as PUBLISHER_DIM
PLACEMENTS as PLACEMENT_DIM
CREATIVES as CREATIVE_DIM
DEVICES as DEVICE_DIM
GEO as GEO_DIM
EXCHANGES as EXCHANGE_DIM
CHANNELS as CHANNEL_DIM
IMPRESSIONS as AD_IMPRESSIONS_FACT
```

**Synonyms** help the AI understand alternate names:
- `ADVERTISERS` has synonyms: 'brands', 'clients', 'advertisers'
- `IMPRESSIONS` has synonyms: 'impressions', 'delivery'

---

### Relationships Section
Defines how tables join (star schema):

```
AD_IMPRESSIONS_FACT (center)
  ├── → ADVERTISER_DIM (advertiser_key)
  ├── → CAMPAIGN_DIM (campaign_key)
  ├── → PUBLISHER_DIM (publisher_key)
  ├── → PLACEMENT_DIM (placement_key)
  ├── → CREATIVE_DIM (creative_key)
  ├── → DEVICE_DIM (device_key)
  ├── → GEO_DIM (geo_key)
  ├── → EXCHANGE_DIM (exchange_key)
  └── → CHANNEL_DIM (channel_key)
```

All relationships are **many-to-one** from fact → dimension.

---

### Facts Section
Raw measurable columns from the fact table:

| Fact Alias | Physical Column | Unit | Aggregatable |
|------------|----------------|------|--------------|
| `impressions` | IMPRESSIONS | Count | Yes (SUM) |
| `clicks` | CLICKS | Count | Yes (SUM) |
| `measured_impressions` | MEASURED_IMPRESSIONS | Count | Yes (SUM) |
| `viewable_impressions` | VIEWABLE_IMPRESSIONS | Count | Yes (SUM) |
| `avoc_impressions` | AVOC_IMPRESSIONS | Count | Yes (SUM) |
| `blocked_impressions` | BLOCKED_IMPRESSIONS | Count | Yes (SUM) |
| `fraud_impressions` | FRAUD_IMPRESSIONS | Count | Yes (SUM) |
| `unsafe_impressions` | UNSAFE_IMPRESSIONS | Count | Yes (SUM) |
| `media_cost` | MEDIA_COST | Currency | Yes (SUM) |

---

### Dimensions Section
Descriptive attributes for slicing/filtering:

**From IMPRESSIONS (fact)**:
- `record_id`: Unique identifier
- `date`: Impression date
- `record_month`: Month extracted from date
- `record_year`: Year extracted from date

**From ADVERTISERS**:
- `advertiser_name`: Brand name

**From CAMPAIGNS**:
- `campaign_name`: Campaign identifier
- `objective`: Campaign goal

**From PUBLISHERS**:
- `publisher_name`: Publisher name
- `domain`: Website domain
- `app_bundle`: Mobile app ID

**From PLACEMENTS**:
- `placement_name`: Placement identifier
- `ad_format`: Display/Video/Native

**From DEVICES**:
- `device_type`: Desktop/Mobile/CTV/Tablet
- `os`: Operating system

**From GEO**:
- `country`: Country code
- `region`: State/province
- `dma`: Designated Market Area

**From EXCHANGES**:
- `exchange_name`: SSP/Exchange name

**From CHANNELS**:
- `channel_name`: Web/App/CTV

---

### Metrics Section
Pre-calculated KPIs that Cortex Analyst can reference:

| Metric | Formula | Unit | Description |
|--------|---------|------|-------------|
| `CTR` | clicks / impressions | Percentage | Click-through rate |
| `VIEWABILITY_RATE` | viewable_impressions / measured_impressions | Percentage | % of ads that were viewable |
| `AVOC_RATE` | avoc_impressions / measured_impressions | Percentage | % audible & viewable on completion |
| `BLOCK_RATE` | blocked_impressions / measured_impressions | Percentage | % of ads blocked |
| `FRAUD_RATE` | fraud_impressions / measured_impressions | Percentage | % detected as fraud |
| `UNSAFE_RATE` | unsafe_impressions / measured_impressions | Percentage | % with brand safety issues |
| `CPM` | 1000 * (media_cost / impressions) | Currency | Cost per thousand impressions |

**Null Safety**: All divisions use `NULLIF(denominator, 0)` to prevent divide-by-zero errors.

---

## Data Relationships

### Star Schema Diagram

```
                    ADVERTISER_DIM
                           |
                    CAMPAIGN_DIM
                           |
      PUBLISHER_DIM ───────┼─────── PLACEMENT_DIM
              |            |            |
              |     AD_IMPRESSIONS_FACT |
              |            |            |
      EXCHANGE_DIM ────────┼─────── CREATIVE_DIM
                           |
                    DEVICE_DIM
                           |
          GEO_DIM ─────────┼─────── CHANNEL_DIM
```

### Join Example

To get campaign performance by publisher:

```sql
SELECT 
  c.campaign_name,
  p.publisher_name,
  SUM(f.impressions) as total_impressions,
  SUM(f.viewable_impressions) / NULLIF(SUM(f.measured_impressions), 0) as viewability_rate
FROM ad_impressions_fact f
  JOIN campaign_dim c ON f.campaign_key = c.campaign_key
  JOIN publisher_dim p ON f.publisher_key = p.publisher_key
WHERE f.date >= '2025-01-01'
GROUP BY c.campaign_name, p.publisher_name;
```

**But with Semantic View**, you just ask:
> "Show viewability rate by campaign and publisher"

---

## Metrics & Calculations

### Industry Standard Definitions

#### Viewability (MRC Standard)
- **Display**: 50% of pixels visible for ≥1 continuous second
- **Video**: 50% of pixels visible for ≥2 continuous seconds

#### AVOC (Audible & Viewable On Completion)
- Video ad played to completion
- With sound on
- Meeting viewability standard

#### Fraud/IVT
- **GIVT** (General Invalid Traffic): Bots, spiders, crawlers
- **SIVT** (Sophisticated Invalid Traffic): Advanced fraud schemes

#### Brand Safety
- Content categories advertisers want to avoid
- Examples: hate speech, violence, adult content

---

### Calculation Examples

**Viewability Rate**:
```
viewable_impressions / measured_impressions
Example: 36,000 / 48,000 = 75%
```

**CPM**:
```
(media_cost / impressions) * 1000
Example: ($750 / 50,000) * 1000 = $15 CPM
```

**Block Rate**:
```
blocked_impressions / measured_impressions
Example: 500 / 48,000 = 1.04%
```

---

## Search Services

### `Search_adtech_docs`

**Type**: Cortex Search Service  
**Content**: Unstructured markdown documents  
**Embedding Model**: snowflake-arctic-embed-l-v2.0

#### Indexed Documents

| Category | Files | Purpose |
|----------|-------|---------|
| **Policies** | Brand_Safety_Policy_2025.md<br>Fraud_Prevention_Guide.md | Corporate guidelines and thresholds |
| **Playbooks** | CTV_Brand_Safety_Playbook.md<br>Programmatic_QA_Checklist.md | Operational best practices |
| **Reports** | Monthly_Quality_Report_Sample.md | Performance benchmarks |

#### Search Behavior

**User Query**: "What are our brand safety policies?"

**Behind the Scenes**:
1. Query → embedding (vector)
2. Search parsed_content table
3. Return top 5 most similar documents
4. Agent synthesizes answer from document chunks

**Example Result**: Returns content from `Brand_Safety_Policy_2025.md` with coverage areas, KPI thresholds, and escalation procedures.

---

## Cortex Analyst Integration

### How Natural Language Queries Work

**User asks**: "What's the fraud rate by exchange last month?"

**Cortex Analyst**:
1. Parses intent: metric = fraud_rate, dimension = exchange, time = last month
2. Maps to semantic view: FRAUD_RATE metric, EXCHANGE_NAME dimension
3. Generates SQL:
   ```sql
   SELECT 
     exchange_name,
     SUM(fraud_impressions) / NULLIF(SUM(measured_impressions), 0) as fraud_rate
   FROM ADTECH_QUALITY_SEMANTIC_VIEW
   WHERE date >= DATEADD(month, -1, CURRENT_DATE())
   GROUP BY exchange_name
   ```
4. Executes and returns results

---

## Best Practices

### Querying Data

✅ **Do**:
- Use metric names from semantic view (e.g., "viewability rate")
- Filter by dimension attributes (e.g., "by publisher", "for Mobile devices")
- Specify time ranges when needed
- Ask for visualizations when comparing categories

❌ **Don't**:
- Reference physical table names directly
- Use SQL syntax in natural language
- Expect real-time data (data is daily grain)

### Adding New Data

**To extend the demo**:
1. Add rows to dimension CSVs
2. Generate new fact records with valid foreign keys
3. Run `/sql_scripts/refresh_data.sql`
4. Semantic view automatically includes new data

---

## Performance Considerations

### Table Sizes
- **Dimensions**: Small (5-6 rows each) → fully cached
- **Facts**: Medium (10K-20K rows) → indexed on date + foreign keys
- **Parsed Content**: Small (5-10 documents) → vector-indexed

### Query Optimization
- Date filters are highly selective (use them!)
- Dimension joins are fast (small tables)
- Aggregations leverage warehouse size (XSMALL = 1 node)

---

## Summary

| Component | Count | Purpose |
|-----------|-------|---------|
| **Dimension Tables** | 10 | Descriptive attributes |
| **Fact Tables** | 2 | Measurable events |
| **Semantic View** | 1 | Natural language interface |
| **Search Service** | 1 | Document search |
| **Intelligence Agent** | 1 | Multi-tool orchestration |
| **Total Data** | 10,852 impression records<br>21,684 verification records | Full year 2025 |

**Data Model**: Star schema with ad_impressions_fact at the center  
**Query Interface**: Semantic view → Cortex Analyst  
**Document Search**: Parsed markdown → Cortex Search  
**Competitive Intel**: Web scraping function → External research
