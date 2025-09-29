-- =====================
-- Refresh AdTech Data from GitHub
-- Run this to reload the latest data without recreating everything
-- =====================

USE ROLE ADTECH_Intelligence_Demo;
USE DATABASE ADTECH_AI_DEMO;
USE SCHEMA DEMO_SCHEMA;

-- Fetch latest from GitHub
ALTER GIT REPOSITORY ADTECH_DEMO_REPO FETCH;
COPY FILES INTO @INTERNAL_DATA_STAGE/demo_data/ FROM @ADTECH_DEMO_REPO/branches/main/demo_data/;
ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- Truncate and reload fact tables
TRUNCATE TABLE ad_impressions_fact;
TRUNCATE TABLE verification_fact;

COPY INTO ad_impressions_fact FROM @INTERNAL_DATA_STAGE/demo_data/ad_impressions_fact.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO verification_fact FROM @INTERNAL_DATA_STAGE/demo_data/verification_fact.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';

-- Truncate and reload dimension tables
TRUNCATE TABLE advertiser_dim;
TRUNCATE TABLE campaign_dim;
TRUNCATE TABLE publisher_dim;
TRUNCATE TABLE placement_dim;
TRUNCATE TABLE creative_dim;
TRUNCATE TABLE device_dim;
TRUNCATE TABLE geo_dim;
TRUNCATE TABLE exchange_dim;
TRUNCATE TABLE quality_segment_dim;

COPY INTO advertiser_dim FROM @INTERNAL_DATA_STAGE/demo_data/advertiser_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO campaign_dim FROM @INTERNAL_DATA_STAGE/demo_data/campaign_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO publisher_dim FROM @INTERNAL_DATA_STAGE/demo_data/publisher_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO placement_dim FROM @INTERNAL_DATA_STAGE/demo_data/placement_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO creative_dim FROM @INTERNAL_DATA_STAGE/demo_data/creative_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO device_dim FROM @INTERNAL_DATA_STAGE/demo_data/device_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO geo_dim FROM @INTERNAL_DATA_STAGE/demo_data/geo_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO exchange_dim FROM @INTERNAL_DATA_STAGE/demo_data/exchange_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';
COPY INTO quality_segment_dim FROM @INTERNAL_DATA_STAGE/demo_data/quality_segment_dim.csv FILE_FORMAT=CSV_FORMAT ON_ERROR='CONTINUE';

-- Verification
SELECT 'Data refresh complete!' as status;
SELECT 'ad_impressions_fact' as table_name, COUNT(*) as row_count FROM ad_impressions_fact
UNION ALL
SELECT 'verification_fact', COUNT(*) FROM verification_fact
UNION ALL
SELECT 'advertiser_dim', COUNT(*) FROM advertiser_dim
UNION ALL
SELECT 'campaign_dim', COUNT(*) FROM campaign_dim
UNION ALL
SELECT 'publisher_dim', COUNT(*) FROM publisher_dim;
