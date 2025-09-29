-- ========================================================================
-- AdTech Snowflake Intelligence Demo - Ad Quality Focus
-- Creates DB, schema, tables, loads data from GitHub-like structure
-- ========================================================================

USE ROLE accountadmin;

CREATE OR REPLACE ROLE ADTECH_Intelligence_Demo;
SET current_user_name = CURRENT_USER();
GRANT ROLE ADTECH_Intelligence_Demo TO USER IDENTIFIER($current_user_name);
GRANT CREATE DATABASE ON ACCOUNT TO ROLE ADTECH_Intelligence_Demo;

CREATE OR REPLACE WAREHOUSE ADTECH_demo_wh WITH WAREHOUSE_SIZE='XSMALL' AUTO_SUSPEND=300 AUTO_RESUME=TRUE;
GRANT USAGE ON WAREHOUSE ADTECH_DEMO_WH TO ROLE ADTECH_Intelligence_Demo;

ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_ROLE = ADTECH_Intelligence_Demo;
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_WAREHOUSE = ADTECH_demo_wh;

USE ROLE ADTECH_Intelligence_Demo;
CREATE OR REPLACE DATABASE ADTECH_AI_DEMO;
USE DATABASE ADTECH_AI_DEMO;
CREATE SCHEMA IF NOT EXISTS DEMO_SCHEMA;
USE SCHEMA DEMO_SCHEMA;

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
  TYPE=CSV FIELD_DELIMITER=',' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"' TRIM_SPACE=TRUE
  ERROR_ON_COLUMN_COUNT_MISMATCH=FALSE ESCAPE='NONE' ESCAPE_UNENCLOSED_FIELD='\\134'
  DATE_FORMAT='YYYY-MM-DD' TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SS' NULL_IF=('NULL','null','','N/A','n/a');

-- Stage and optional Git integration (adjust ORIGIN if mirroring to GitLab)
USE ROLE accountadmin;
CREATE OR REPLACE API INTEGRATION adtech_git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://gitlab.com/','https://github.com/')
  ENABLED = TRUE;
GRANT USAGE ON INTEGRATION ADTECH_GIT_API_INTEGRATION TO ROLE ADTECH_Intelligence_Demo;

USE ROLE ADTECH_Intelligence_Demo;
-- If you mirror this repo to GitLab, update the ORIGIN accordingly
CREATE OR REPLACE GIT REPOSITORY ADTECH_DEMO_REPO
  API_INTEGRATION = adtech_git_api_integration
  ORIGIN = 'https://gitlab.com/your-group/adtech_sf_demo.git';

CREATE OR REPLACE STAGE INTERNAL_DATA_STAGE FILE_FORMAT=CSV_FORMAT DIRECTORY=(ENABLE=TRUE) ENCRYPTION=(TYPE='SNOWFLAKE_SSE');

-- Pull repo and copy files (assumes same folder structure)
ALTER GIT REPOSITORY ADTECH_DEMO_REPO FETCH;
COPY FILES INTO @INTERNAL_DATA_STAGE/demo_data/ FROM @ADTECH_DEMO_REPO/branches/main/demo_data/;
COPY FILES INTO @INTERNAL_DATA_STAGE/unstructured_docs/ FROM @ADTECH_DEMO_REPO/branches/main/unstructured_docs/;
ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- =====================
-- Dimensions
-- =====================
CREATE OR REPLACE TABLE advertiser_dim (
  advertiser_key INT PRIMARY KEY,
  advertiser_name VARCHAR(200) NOT NULL,
  industry VARCHAR(100)
);

CREATE OR REPLACE TABLE campaign_dim (
  campaign_key INT PRIMARY KEY,
  advertiser_key INT,
  campaign_name VARCHAR(300),
  objective VARCHAR(100),
  start_date DATE,
  end_date DATE
);

CREATE OR REPLACE TABLE publisher_dim (
  publisher_key INT PRIMARY KEY,
  publisher_name VARCHAR(200),
  domain VARCHAR(200),
  app_bundle VARCHAR(200),
  inventory_type VARCHAR(50)
);

CREATE OR REPLACE TABLE placement_dim (
  placement_key INT PRIMARY KEY,
  placement_name VARCHAR(200),
  ad_format VARCHAR(100),
  placement_type VARCHAR(100)
);

CREATE OR REPLACE TABLE creative_dim (
  creative_key INT PRIMARY KEY,
  creative_id VARCHAR(100),
  size VARCHAR(50),
  duration_seconds INT
);

CREATE OR REPLACE TABLE device_dim (
  device_key INT PRIMARY KEY,
  device_type VARCHAR(50),
  os VARCHAR(50)
);

CREATE OR REPLACE TABLE geo_dim (
  geo_key INT PRIMARY KEY,
  country VARCHAR(50),
  region VARCHAR(50),
  dma VARCHAR(20)
);

CREATE OR REPLACE TABLE exchange_dim (
  exchange_key INT PRIMARY KEY,
  exchange_name VARCHAR(100)
);

CREATE OR REPLACE TABLE channel_dim (
  channel_key INT PRIMARY KEY,
  channel_name VARCHAR(50)
);

CREATE OR REPLACE TABLE quality_segment_dim (
  segment_key INT PRIMARY KEY,
  segment_name VARCHAR(200),
  category VARCHAR(100)
);

-- =====================
-- Facts
-- =====================
CREATE OR REPLACE TABLE ad_impressions_fact (
  record_id INT PRIMARY KEY,
  date DATE,
  advertiser_key INT,
  campaign_key INT,
  placement_key INT,
  creative_key INT,
  publisher_key INT,
  exchange_key INT,
  device_key INT,
  geo_key INT,
  channel_key INT,
  impressions INT,
  clicks INT,
  measured_impressions INT,
  viewable_impressions INT,
  avoc_impressions INT,
  blocked_impressions INT,
  fraud_impressions INT,
  unsafe_impressions INT,
  media_cost DECIMAL(12,2)
);

CREATE OR REPLACE TABLE verification_fact (
  verification_id INT PRIMARY KEY,
  date DATE,
  campaign_key INT,
  placement_key INT,
  segment_key INT,
  measured_impressions INT,
  risky_impressions INT,
  blocked_impressions INT
);

-- =====================
-- Load Data
-- =====================
COPY INTO advertiser_dim FROM @INTERNAL_DATA_STAGE/demo_data/advertiser_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO campaign_dim FROM @INTERNAL_DATA_STAGE/demo_data/campaign_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO publisher_dim FROM @INTERNAL_DATA_STAGE/demo_data/publisher_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO placement_dim FROM @INTERNAL_DATA_STAGE/demo_data/placement_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO creative_dim FROM @INTERNAL_DATA_STAGE/demo_data/creative_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO device_dim FROM @INTERNAL_DATA_STAGE/demo_data/device_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO geo_dim FROM @INTERNAL_DATA_STAGE/demo_data/geo_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO exchange_dim FROM @INTERNAL_DATA_STAGE/demo_data/exchange_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO channel_dim FROM @INTERNAL_DATA_STAGE/demo_data/channel_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO quality_segment_dim FROM @INTERNAL_DATA_STAGE/demo_data/quality_segment_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO ad_impressions_fact FROM @INTERNAL_DATA_STAGE/demo_data/ad_impressions_fact.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO verification_fact FROM @INTERNAL_DATA_STAGE/demo_data/verification_fact.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';

-- =====================
-- Semantic View: ADTECH Verification & Quality
-- =====================
create or replace semantic view ADTECH_AI_DEMO.DEMO_SCHEMA.ADTECH_QUALITY_SEMANTIC_VIEW
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
    DV_SEGMENTS as QUALITY_SEGMENT_DIM primary key (SEGMENT_KEY) with synonyms=('quality segments','safety segments','fraud segments'),
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
    VER_TO_SEG as VERIFICATION(SEGMENT_KEY) references DV_SEGMENTS(SEGMENT_KEY),
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
    DV_SEGMENTS.SEGMENT_NAME as segment_name,
    DV_SEGMENTS.CATEGORY as segment_category
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

-- =====================
-- Unstructured docs parse and search services
-- =====================
create or replace table parsed_content as
select
  relative_path,
  BUILD_STAGE_FILE_URL('@ADTECH_AI_DEMO.DEMO_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
  TO_FILE(BUILD_STAGE_FILE_URL('@ADTECH_AI_DEMO.DEMO_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
  SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @ADTECH_AI_DEMO.DEMO_SCHEMA.INTERNAL_DATA_STAGE,
    relative_path,
    {'mode':'LAYOUT'}
  ):content::string as content
from directory(@ADTECH_AI_DEMO.DEMO_SCHEMA.INTERNAL_DATA_STAGE)
where relative_path ilike 'unstructured_docs/%.md';

USE ROLE ADTECH_Intelligence_Demo;
CREATE OR REPLACE CORTEX SEARCH SERVICE Search_adtech_docs
  ON content
  ATTRIBUTES relative_path, file_url, title
  WAREHOUSE = ADTECH_DEMO_WH
  TARGET_LAG = '30 day'
  EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
AS (
  SELECT relative_path, file_url, REGEXP_SUBSTR(relative_path, '[^/]+$') as title, content
  FROM parsed_content
);

-- Note: Add an Intelligence Agent similarly if needed, mirroring the retail demo

-- =====================
-- Verification
-- =====================
SHOW TABLES;
SHOW SEMANTIC VIEWS;
SHOW CORTEX SEARCH SERVICES;
