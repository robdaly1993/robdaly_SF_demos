-- ========================================================================
-- Migration: Make AdTech demo vendor-agnostic (rename DV -> generic)
-- Run this ONLY if you previously created DV-specific objects
-- ========================================================================

USE ROLE ADTECH_Intelligence_Demo;
USE DATABASE ADTECH_AI_DEMO;
USE SCHEMA DEMO_SCHEMA;

-- Tables: rename DV tables to generic
ALTER TABLE IF EXISTS DV_VERIFICATION_FACT RENAME TO VERIFICATION_FACT;
ALTER TABLE IF EXISTS DV_SEGMENT_DIM RENAME TO QUALITY_SEGMENT_DIM;

-- Columns: rename DV_* columns in AD_IMPRESSIONS_FACT
ALTER TABLE IF EXISTS AD_IMPRESSIONS_FACT RENAME COLUMN IF EXISTS DV_BLOCKED_IMPRESSIONS TO BLOCKED_IMPRESSIONS;
ALTER TABLE IF EXISTS AD_IMPRESSIONS_FACT RENAME COLUMN IF EXISTS DV_FRAUD_IMPRESSIONS TO FRAUD_IMPRESSIONS;
ALTER TABLE IF EXISTS AD_IMPRESSIONS_FACT RENAME COLUMN IF EXISTS DV_UNSAFE_IMPRESSIONS TO UNSAFE_IMPRESSIONS;

-- Recreate semantic view with generic names
CREATE OR REPLACE SEMANTIC VIEW ADTECH_AI_DEMO.DEMO_SCHEMA.ADTECH_QUALITY_SEMANTIC_VIEW
  tables (
    ADVERTISERS as ADVERTISER_DIM primary key (ADVERTISER_KEY) with synonyms=('brands','clients','advertisers'),
    CAMPAIGNS as CAMPAIGN_DIM primary key (CAMPAIGN_KEY) with synonyms=('campaigns'),
    PUBLISHERS as PUBLISHER_DIM primary key (PUBLISHER_KEY) with synonyms=('sites','apps','publishers'),
    PLACEMENTS as PLACEMENT_DIM primary key (PLACEMENT_KEY) with synonyms=('placements','inventory'),
    CREATIVES as CREATIVE_DIM primary key (CREATIVE_KEY) with synonyms=('creatives','ads'),
    DEVICES as DEVICE_DIM primary key (DEVICE_KEY) with synonyms=('devices'),
    GEO as GEO_DIM primary key (GEO_KEY) with synonyms=('geo','location'),
    EXCHANGES as EXCHANGE_DIM primary key (EXCHANGE_KEY) with synonyms=('exchanges','supply'),
    CHANNELS as CHANNEL_DIM primary key (CHANNEL_KEY) with synonyms=('channels'),
    QUALITY_SEGMENTS as QUALITY_SEGMENT_DIM primary key (SEGMENT_KEY) with synonyms=('quality segments','safety segments','fraud segments'),
    IMPRESSIONS as AD_IMPRESSIONS_FACT primary key (RECORD_ID) with synonyms=('impressions','delivery'),
    VERIFICATION as VERIFICATION_FACT primary key (VERIFICATION_ID) with synonyms=('verification','quality')
  )
  relationships (
    IMP_TO_ADV as IMPRESSIONS(ADVERTISER_KEY) references ADVERTISERS(ADVERTISER_KEY),
    IMP_TO_CAMP as IMPRESSIONS(CAMPAIGN_KEY) references CAMPAIGNS(CAMPAIGN_KEY),
    IMP_TO_PUB as IMPRESSIONS(PUBLISHER_KEY) references PUBLISHERS(PUBLISHER_KEY),
    IMP_TO_PLACE as IMPRESSIONS(PLACEMENT_KEY) references PLACEMENTS(PLACEMENT_KEY),
    IMP_TO_CRE as IMPRESSIONS(CREATIVE_KEY) references CREATIVES(CREATIVE_KEY),
    IMP_TO_DEV as IMPRESSIONS(DEVICE_KEY) references DEVICES(DEVICE_KEY),
    IMP_TO_GEO as IMPRESSIONS(GEO_KEY) references GEO(GEO_KEY),
    IMP_TO_EX as IMPRESSIONS(EXCHANGE_KEY) references EXCHANGES(EXCHANGE_KEY),
    IMP_TO_CH as IMPRESSIONS(CHANNEL_KEY) references CHANNELS(CHANNEL_KEY),
    VER_TO_SEG as VERIFICATION(SEGMENT_KEY) references QUALITY_SEGMENTS(SEGMENT_KEY),
    VER_TO_PLACE as VERIFICATION(PLACEMENT_KEY) references PLACEMENTS(PLACEMENT_KEY),
    VER_TO_CAMP as VERIFICATION(CAMPAIGN_KEY) references CAMPAIGNS(CAMPAIGN_KEY)
  )
  facts (
    IMPRESSIONS.IMPRESSIONS as impressions,
    IMPRESSIONS.CLICKS as clicks,
    IMPRESSIONS.MEASURED_IMPRESSIONS as measured_impressions,
    IMPRESSIONS.VIEWABLE_IMPRESSIONS as viewable_impressions,
    IMPRESSIONS.AVOC_IMPRESSIONS as avoc_impressions,
    IMPRESSIONS.BLOCKED_IMPRESSIONS as blocked,
    IMPRESSIONS.FRAUD_IMPRESSIONS as fraud,
    IMPRESSIONS.UNSAFE_IMPRESSIONS as unsafe,
    IMPRESSIONS.MEDIA_COST as media_cost,
    VERIFICATION.MEASURED_IMPRESSIONS as ver_measured,
    VERIFICATION.RISKY_IMPRESSIONS as ver_risky,
    VERIFICATION.BLOCKED_IMPRESSIONS as ver_blocked
  )
  dimensions (
    IMPRESSIONS.RECORD_ID as RECORD_ID,
    IMPRESSIONS.DATE as date,
    IMPRESSIONS.MONTH as MONTH(date),
    IMPRESSIONS.YEAR as YEAR(date),
    ADVERTISERS.ADVERTISER_NAME as advertiser_name,
    CAMPAIGNS.CAMPAIGN_NAME as campaign_name,
    CAMPAIGNS.OBJECTIVE as objective,
    PUBLISHERS.PUBLISHER_NAME as publisher_name,
    PUBLISHERS.DOMAIN as domain,
    PUBLISHERS.APP_BUNDLE as app_bundle,
    PLACEMENTS.PLACEMENT_NAME as placement_name,
    PLACEMENTS.AD_FORMAT as ad_format,
    DEVICES.DEVICE_TYPE as device_type,
    DEVICES.OS as os,
    GEO.COUNTRY as country,
    GEO.REGION as region,
    GEO.DMA as dma,
    EXCHANGES.EXCHANGE_NAME as exchange_name,
    CHANNELS.CHANNEL_NAME as channel,
    QUALITY_SEGMENTS.SEGMENT_NAME as segment_name,
    QUALITY_SEGMENTS.CATEGORY as segment_category
  )
  metrics (
    IMPRESSIONS.CTR as SAFE_DIVIDE(SUM(IMPRESSIONS.clicks), NULLIF(SUM(IMPRESSIONS.impressions),0)),
    IMPRESSIONS.VIEWABILITY_RATE as SAFE_DIVIDE(SUM(IMPRESSIONS.viewable_impressions), NULLIF(SUM(IMPRESSIONS.measured_impressions),0)),
    IMPRESSIONS.AVOC_RATE as SAFE_DIVIDE(SUM(IMPRESSIONS.avoc_impressions), NULLIF(SUM(IMPRESSIONS.measured_impressions),0)),
    IMPRESSIONS.BLOCK_RATE as SAFE_DIVIDE(SUM(IMPRESSIONS.blocked), NULLIF(SUM(IMPRESSIONS.measured_impressions),0)),
    IMPRESSIONS.FRAUD_RATE as SAFE_DIVIDE(SUM(IMPRESSIONS.fraud), NULLIF(SUM(IMPRESSIONS.measured_impressions),0)),
    IMPRESSIONS.UNSAFE_RATE as SAFE_DIVIDE(SUM(IMPRESSIONS.unsafe), NULLIF(SUM(IMPRESSIONS.measured_impressions),0)),
    IMPRESSIONS.CPM as 1000 * SAFE_DIVIDE(SUM(IMPRESSIONS.media_cost), NULLIF(SUM(IMPRESSIONS.impressions),0))
  )
  comment='Semantic view for ad quality, viewability, AVOC, and cost KPIs';

-- Verification
SHOW SEMANTIC VIEWS;
SHOW TABLES LIKE '%VERIFICATION%';
