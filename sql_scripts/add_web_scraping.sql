-- =====================
-- Add Web Scraping Capability to AdTech Intelligence Agent
-- =====================

USE ROLE ADTECH_Intelligence_Demo;
USE DATABASE ADTECH_AI_DEMO;
USE SCHEMA DEMO_SCHEMA;

-- Create network rule for web access
CREATE OR REPLACE NETWORK RULE adtech_web_access_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('0.0.0.0:80', '0.0.0.0:443');

-- Grant usage on network rule
USE ROLE accountadmin;
GRANT USAGE ON NETWORK RULE adtech_web_access_rule TO ROLE accountadmin;

-- Create external access integration
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION adtech_external_access
  ALLOWED_NETWORK_RULES = (adtech_web_access_rule)
  ENABLED = true;

GRANT USAGE ON INTEGRATION adtech_external_access TO ROLE ADTECH_Intelligence_Demo;

-- Switch back to demo role
USE ROLE ADTECH_Intelligence_Demo;

-- Create web scraping function
CREATE OR REPLACE FUNCTION web_scrape(weburl STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.11
HANDLER = 'get_page'
EXTERNAL_ACCESS_INTEGRATIONS = (adtech_external_access)
PACKAGES = ('requests', 'beautifulsoup4')
AS
$$
import requests
from bs4 import BeautifulSoup

def get_page(weburl):
  try:
    url = f"{weburl}"
    response = requests.get(url, timeout=10)
    soup = BeautifulSoup(response.text, 'html.parser')
    return soup.get_text()
  except Exception as e:
    return f"Error scraping URL: {str(e)}"
$$;

-- Recreate the agent with web scraping capability
CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.AdTech_Quality_Agent
WITH PROFILE='{ "display_name": "AdTech Quality Agent" }'
COMMENT=$$ This agent can answer questions about ad quality, viewability, fraud, AVOC, campaign performance, and competitive AdTech landscape. $$
FROM SPECIFICATION $$
{
  "models": {
    "orchestration": ""
  },
  "instructions": {
    "response": "You are an ad quality analyst with access to impression-level data, viewability, AVOC, fraud, and brand safety metrics. You can also analyze external web content for competitive intelligence. Answer questions about campaign performance, publisher quality, optimization opportunities, and industry trends. Provide visualizations when helpful.",
    "orchestration": "Use the AdTech Quality semantic view for structured data queries, search documents for policies and guidelines, and use web scraping for competitive research or industry benchmarks. Default to year 2025 if no date range is specified. When comparing to competitors, use web scraping to gather public information.",
    "sample_questions": [
      {
        "question": "What is the viewability rate by publisher last 30 days?"
      },
      {
        "question": "Which campaigns have the highest fraud rate?"
      },
      {
        "question": "Show me AVOC and viewability trends by device type"
      },
      {
        "question": "What are our brand safety policies?"
      },
      {
        "question": "Compare our viewability rates to industry benchmarks"
      }
    ]
  },
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query AdTech Quality Data",
        "description": "Allows users to query ad quality metrics including impressions, viewability, AVOC, fraud, blocked impressions, unsafe impressions, CTR, and CPM across advertisers, campaigns, publishers, placements, devices, exchanges, and channels."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search AdTech Documents",
        "description": "Search internal documents including brand safety policies, fraud prevention guides, CTV playbooks, and quality reports."
      }
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "Web_Scraper",
        "description": "Scrape and analyze content from any web URL. Use this for competitive intelligence, industry benchmarks, or research on other AdTech vendors. Provide the full URL (including https://).",
        "input_schema": {
          "type": "object",
          "properties": {
            "weburl": {
              "description": "Full URL to scrape (must include http:// or https://). Use for competitor research, industry reports, or AdTech vendor information.",
              "type": "string"
            }
          },
          "required": [
            "weburl"
          ]
        }
      }
    }
  ],
  "tool_resources": {
    "Query AdTech Quality Data": {
      "semantic_view": "ADTECH_AI_DEMO.DEMO_SCHEMA.ADTECH_QUALITY_SEMANTIC_VIEW"
    },
    "Search AdTech Documents": {
      "id_column": "FILE_URL",
      "max_results": 5,
      "name": "ADTECH_AI_DEMO.DEMO_SCHEMA.SEARCH_ADTECH_DOCS",
      "title_column": "TITLE"
    },
    "Web_Scraper": {
      "execution_environment": {
        "query_timeout": 0,
        "type": "warehouse",
        "warehouse": "ADTECH_DEMO_WH"
      },
      "identifier": "ADTECH_AI_DEMO.DEMO_SCHEMA.WEB_SCRAPE",
      "name": "WEB_SCRAPE(VARCHAR)",
      "type": "function"
    }
  }
}
$$;

-- Verification
SELECT 'Agent updated with web scraping capability!' as status;
SHOW AGENTS IN SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS;
