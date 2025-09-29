# AdTech Intelligence Demo - User Guide 🚀

## Quick Start (5 Minutes)

### Step 1: Setup in Snowflake
1. Open Snowflake in your browser
2. Create a new SQL worksheet
3. Paste and run the entire setup script:
   ```sql
   -- Copy/paste from: sql_scripts/adtech_setup.sql
   ```
4. Wait ~2-3 minutes for completion
5. Run the web scraping add-on:
   ```sql
   -- Copy/paste from: sql_scripts/add_web_scraping.sql
   ```

### Step 2: Access the Agent
1. In Snowflake UI, click **AI/ML** in left navigation
2. Click **Snowflake Intelligence**
3. At the bottom-left, select: **AdTech Quality Agent**
4. Start asking questions! 💬

---

## 📊 Demo Script (Follow This Order - 30 Minutes)

### Part 1: Performance Overview (5 min)

**Goal**: Show basic metrics and trends

**1. "What is our viewability rate for 2025?"**
- Simple metric calculation
- Should return ~70-75%
- Shows agent can compute percentages

**2. "Show me monthly impressions trend for 2025 with a chart"**
- Tests time-series visualization
- Should show steady delivery across 12 months
- Ask for line chart specifically

**3. "What's our CTR by ad format?"**
- Compares Display vs Video vs Native
- Typical: Video > Native > Display
- Shows dimensional slicing

### Part 2: Quality Analysis (5 min)

**Goal**: Demonstrate quality metrics

**4. "Which publishers have the highest viewability rate?"**
- Ranks publishers by quality
- Shows comparative analysis
- Great for identifying premium inventory

**5. "Show me fraud rate by exchange over time"**
- Trend analysis with quality metric
- Should show most exchanges <0.5% fraud
- Highlights verification capabilities

**6. "What's our AVOC rate by device type?"**
- CTV should be highest (40-50%)
- Mobile typically lowest (30-40%)
- Desktop in middle

### Part 3: Cost Efficiency (5 min)

**Goal**: Show ROI and optimization insights

**7. "Compare CPM by channel and exchange"**
- Cross-dimensional analysis
- Typically: CTV > Web > App
- Shows cost variance

**8. "Which campaigns have the best viewability for the lowest CPM?"**
- Efficiency analysis
- Identifies optimization opportunities
- Complex multi-metric query

**9. "Show blocked impression rate by publisher and quality segment"**
- Safety verification details
- Identifies problematic inventory
- Demonstrates granular reporting

### Part 4: Document Search (3 min)

**Goal**: Show unstructured data capabilities

**10. "What are our brand safety policies?"**
- Retrieves policy document
- Shows semantic search working
- Agent summarizes key points

**11. "What does the CTV playbook say about AVOC requirements?"**
- Specific document + section retrieval
- Tests precise information extraction

**12. "Show me the fraud prevention checklist"**
- Returns operational guidance
- Demonstrates policy compliance

### Part 5: Competitive Intelligence with Web Scraping (7 min) 🌐

**Goal**: Show web scraping for market research

**13. "Scrape https://www.iab.com/guidelines/digital-video-ad-format-guidelines/ and summarize the viewability standards"**
- Gets external benchmarks
- Compares to your data
- Real-world research

**14. "Go to https://www.doubleverify.com/solutions/brand-safety/ and tell me what brand safety categories they mention. How do these compare to our quality segments?"**
- Competitive analysis
- Feature comparison
- Shows strategic insights

**15. "Look up https://www.mediaradar.com/blog/ctv-advertising-benchmarks/ and compare the CTV benchmarks to our performance"**
- Industry benchmark research
- Performance gap analysis
- Data-driven recommendations

### Part 6: Advanced Multi-Tool Queries (5 min)

**Goal**: Show agent orchestrating multiple tools

**16. "What's our fraud rate compared to industry standards? Use web search to find benchmarks if needed"**
- Agent decides to scrape industry report
- Compares internal vs external data
- Synthesizes answer

**17. "Check our brand safety policy document, then show me our unsafe rate by publisher to see if we're meeting policy thresholds"**
- Reads policy (search)
- Queries data (analyst)
- Validates compliance

**18. "Research what AVOC rates are considered premium for CTV, then show me which of our publishers meet that standard"**
- External benchmark (web scrape)
- Internal analysis (query)
- Actionable recommendation

---

## 🎯 Question Templates (Mix & Match)

### Metrics
```
"What is our [metric] for [time period]?"
"Show [metric] by [dimension]"
"Compare [metric] across [dimension1] and [dimension2]"
```

**Examples**:
- "What is our viewability rate for Q1 2025?"
- "Show fraud rate by publisher"
- "Compare CPM across exchanges and channels"

### Trends
```
"Show [metric] trend over time"
"How has [metric] changed month over month?"
"Plot [metric] by [dimension] with a chart"
```

**Examples**:
- "Show viewability trend over 2025"
- "How has fraud rate changed quarter over quarter?"
- "Plot AVOC by device type with a bar chart"

### Rankings
```
"Which [dimension] has the highest/lowest [metric]?"
"Rank [dimension] by [metric]"
"Show top 5 [dimension] for [metric]"
```

**Examples**:
- "Which publisher has the highest viewability?"
- "Rank campaigns by CTR"
- "Show top 5 exchanges for lowest fraud rate"

### Filters
```
"Show [metric] for [dimension value]"
"What's [metric] for [device/channel] in [time period]?"
"Filter by [dimension] = [value] and show [metric]"
```

**Examples**:
- "Show viewability for Mobile devices"
- "What's CPM for CTV in Q4 2025?"
- "Filter by campaign 'Brand Safety Blitz' and show all metrics"

### Combinations
```
"[Metric1] and [Metric2] by [Dimension]"
"Compare [Metric] across [Dim1] and [Dim2] where [Dim3] = [Value]"
```

**Examples**:
- "Viewability and fraud rate by publisher"
- "Compare CPM across exchanges and channels where device = CTV"

---

## 🌐 Web Scraping - Cool Use Cases

### 1. Industry Benchmarks
**Purpose**: Compare your performance to industry standards

**Question Templates**:
```
"Scrape [industry report URL] and compare their [metric] benchmarks to ours"
"Get the latest [metric] standards from [source] and tell me how we perform"
```

**Good Sources**:
- **IAB.com**: Standards and guidelines
  - https://www.iab.com/guidelines/digital-video-ad-format-guidelines/
  - https://www.iab.com/guidelines/viewability-measurement/
- **eMarketer.com**: Industry reports
- **MediaRadar.com**: Benchmarks and trends
  - https://www.mediaradar.com/blog/ctv-advertising-benchmarks/
- **TradeDesk blog**: CTV and programmatic insights

**Example Questions**:
- "Scrape IAB viewability guidelines and tell me if our measurement aligns"
- "Get CTV AVOC benchmarks from MediaRadar and compare to our performance"
- "Look up industry fraud rate standards and show how we compare"

### 2. Competitive Analysis
**Purpose**: Understand competitor capabilities and positioning

**Question Templates**:
```
"Go to [competitor website] and summarize their [feature] capabilities. How do we compare?"
"Scrape [vendor product page] and list their key features vs ours"
```

**Target Sites**:
- **DoubleVerify.com**: Verification leader
  - https://www.doubleverify.com/solutions/brand-safety/
  - https://www.doubleverify.com/solutions/fraud-detection/
- **IAS.com** (Integral Ad Science)
  - https://integralads.com/solutions/brand-safety/
- **MOAT.com** (Oracle Data Cloud)
- **Pixalate.com**: Fraud detection
  - https://www.pixalate.com/products/invalid-traffic

**Example Questions**:
- "Go to DoubleVerify's brand safety page and compare their categories to our quality segments"
- "Scrape IAS fraud detection page and tell me what methods they use vs our approach"
- "Look up Pixalate's IVT detection and compare to our fraud metrics"
- "What does MOAT say about viewability measurement? Do we measure the same way?"

### 3. Product & Technology Research
**Purpose**: Learn about new technologies and solutions

**Question Templates**:
```
"Look up [vendor product page] and list their key features"
"Research [technology] from [source] and explain how it works"
```

**Example Questions**:
- "Scrape DoubleVerify's Authentic Ad page and explain their fraud detection approach"
- "Go to TAG's website and summarize their certified against fraud program"
- "Look up MRC accreditation standards and tell me what's required"

### 4. Market Intelligence & Trends
**Purpose**: Stay updated on industry developments

**Question Templates**:
```
"Find the latest [topic] trends from [trade publication]"
"Scrape [news site] for recent [topic] articles and summarize"
```

**Trade Sites**:
- **AdExchanger.com**: Programmatic news
- **Digiday.com**: Digital advertising trends
- **AdAge.com**: Industry news
- **MarketingDive.com**: Marketing insights

**Example Questions**:
- "Go to AdExchanger and find recent CTV fraud articles. Summarize key points"
- "Scrape Digiday for latest viewability trends and compare to our data"
- "Look up recent AdAge articles on brand safety and tell me what's changing"

### 5. Standards & Guidelines
**Purpose**: Ensure compliance with industry standards

**Question Templates**:
```
"Get the [standard name] from [standards body] and confirm we're compliant"
"Look up [guideline] and tell me what we need to do"
```

**Standards Bodies**:
- **MRC** (Media Rating Council): Measurement standards
- **IAB Tech Lab**: Technical specifications
- **TAG** (Trustworthy Accountability Group): Fraud prevention

**Example Questions**:
- "Get the MRC viewability standard and confirm our measurement methodology"
- "Look up TAG's Certified Against Fraud requirements and tell me if we meet them"
- "Scrape IAB Tech Lab's ads.txt spec and explain how it prevents fraud"

### 6. Competitive Pricing & Market Rates
**Purpose**: Understand market pricing

**Example Questions**:
- "Research typical CTV CPMs in 2025 and compare to our rates"
- "Find average programmatic fees and tell me if our costs are competitive"
- "Look up premium publisher CPM ranges and show how we compare"

---

## 🎨 Visualization Tips

### Request Charts Explicitly
Always ask for visualizations when comparing data:
- "Show this as a bar chart"
- "Plot this as a line chart"
- "Create a trend line"
- "Visualize this comparison"

### Best Chart Types by Question

| Question Type | Best Chart | Example |
|---------------|------------|---------|
| Trend over time | Line chart | "Monthly viewability trend" |
| Compare categories | Bar chart | "Viewability by publisher" |
| Part of whole | Pie chart | "Impressions by channel" |
| Two metric comparison | Scatter plot | "CPM vs Viewability" |
| Distribution | Histogram | "Distribution of fraud rates" |

**Pro Tip**: Add "with a chart" to any question to get a visualization!

---

## 🎭 Demo Scenarios by Audience

### For **Marketing Leaders**
**Focus**: Performance, ROI, efficiency

**Questions to Ask**:
1. "Show campaign performance trends over time"
2. "What's our cost per viewable impression by channel?"
3. "Rank publishers by viewability and CPM efficiency"
4. "Compare our CTR to industry benchmarks from IAB"

### For **Operations/Ad Ops Teams**
**Focus**: Quality metrics, inventory management

**Questions to Ask**:
1. "Show fraud and IVT rates by exchange"
2. "Which publishers don't meet our brand safety thresholds?"
3. "Trend blocked impressions by quality segment"
4. "Compare our fraud detection to what DoubleVerify offers"

### For **Data/Analytics Teams**
**Focus**: Complex queries, multi-dimensional analysis

**Questions to Ask**:
1. "Show correlation between viewability and AVOC rates"
2. "Analyze seasonal trends in fraud rates"
3. "Compare performance across device, channel, and exchange combinations"
4. "Calculate custom efficiency score: viewability divided by CPM"

### For **Executives/C-Suite**
**Focus**: High-level KPIs, competitive positioning

**Questions to Ask**:
1. "Give me an overall quality scorecard for 2025"
2. "How do we compare to industry benchmarks? Research them if needed"
3. "Show year-over-year quality improvement trends"
4. "What are the top 3 opportunities for optimization?"

---

## ⚡ Pro Tips

### 1. Be Specific with Time Ranges
✅ **Good**: "Show viewability for Q1 2025"  
❌ **Vague**: "Show viewability" (defaults to all data)

### 2. Request Visualizations
✅ **Good**: "Plot this as a chart"  
✅ **Good**: "Show me a bar chart visualization"

### 3. Combine Multiple Metrics
✅ **Good**: "Show viewability AND fraud rate by publisher"  
✅ **Good**: "Compare CPM, CTR, and viewability rate"

### 4. Use Natural Language
✅ **Good**: "Which publishers are the worst for fraud?"  
✅ **Good**: "What's our best performing campaign?"  
❌ **Bad**: Don't use SQL syntax!

### 5. Iterate on Responses
- **Start broad**: "Show campaign performance"
- **Then drill down**: "Now show that just for Mobile"
- **Refine further**: "And filter to Q4 only"

### 6. Use Web Scraping Strategically
✅ When you need external benchmarks  
✅ To research competitor features  
✅ For industry standards/definitions  
❌ Don't scrape data you already have internally

### 7. Check Your Documents First
Before web scraping, try: "What do our policies say about [topic]?"

---

## 🔥 Most Impressive Demo Moments

### 1. Real-Time Competitive Intelligence
```
You: "Go to IAS website and compare their fraud detection claims to our actual fraud rates"

Agent: *Scrapes site, analyzes data, compares metrics*

Result: "IAS claims 0.1% fraud detection capability. Our current fraud rate 
is 0.18%, slightly higher but within acceptable range per our internal policy 
which sets threshold at 0.3%..."
```

### 2. Policy Compliance Validation
```
You: "Check our brand safety policy for acceptable thresholds, then show me 
which publishers exceed those limits"

Agent: *Searches policy docs, queries data, cross-references*

Result: "Your brand safety policy sets 0.5% unsafe threshold. Analysis shows:
- NewsNow.com: 0.7% (EXCEEDS by 0.2%)
- SportDaily.com: 0.9% (EXCEEDS by 0.4%)
Recommendation: Review contracts or implement blocking..."
```

### 3. Industry Benchmarking Analysis
```
You: "Find CTV AVOC benchmarks online and tell me if we're above or below 
industry standard"

Agent: *Scrapes industry report, compares to internal data*

Result: "Industry benchmark for premium CTV is 55% AVOC (source: MediaRadar 
Q4 2024). Your CTV AVOC rate is 48%, approximately 7 points below premium 
threshold. Top performing CTV publisher: CTVNetwork at 52% AVOC..."
```

### 4. Multi-Source Analysis
```
You: "Research typical programmatic fraud rates, check our policy thresholds, 
then show which exchanges exceed both benchmarks"

Agent: *Web scrape → doc search → data query*

Result: "Industry fraud benchmark: 0.2% (TAG standards). Your policy threshold: 
0.3%. Exchange analysis:
- All exchanges meet your policy
- 4 of 5 meet industry benchmark
- Index Exchange at 0.25% slightly above industry average..."
```

---

## 🚨 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| **"No data found"** | Add time range: "for 2025" or "last 30 days" |
| **Agent seems confused** | Rephrase more simply. Break into smaller questions. |
| **Web scraping fails** | Some sites block scrapers. Try different source. |
| **Wrong metric calculated** | Be explicit: "viewability rate" not just "viewability" |
| **No visualization shown** | Ask: "show this as a chart" or "create a bar chart" |
| **Slow response** | Complex queries take longer. Be patient! |
| **Generic answer** | Add more context: dimensions, time periods, filters |

---

## 📋 Pre-Demo Checklist

- [ ] Setup script completed successfully
- [ ] Web scraping enabled (ran add_web_scraping.sql)
- [ ] Agent appears in Intelligence dropdown
- [ ] Test query works: "What is our viewability rate?"
- [ ] Have 2-3 external URLs ready for web scraping demo
- [ ] Reviewed audience-appropriate questions
- [ ] Tested visualization requests
- [ ] Know your key talking points

---

## 🎬 30-Second Elevator Pitch

> *"This is an AdTech quality dashboard powered by Snowflake Intelligence. I can ask it questions in plain English like 'Which publishers have the best viewability?' and it instantly analyzes 10,000+ impression records across a full year. It can also search our policy documents and even scrape competitor websites for benchmarking. Watch this..."*

Then demo one impressive query from each category!

---

## 💡 After the Demo - Next Steps

### Immediate Actions
1. **Customize with your data**: Replace CSVs with actual impression data
2. **Add your policies**: Upload real brand safety and fraud policies
3. **Test with your team**: Have stakeholders try their own questions

### Expand the Demo
1. **Add more dimensions**: Deal types, advertiser segments, creative categories
2. **Expand documents**: Add more playbooks, reports, SOPs
3. **Custom metrics**: Add DSP-specific or client-specific KPIs to semantic view
4. **Real-time data**: Set up daily/hourly data refreshes

### Scale to Production
1. **Connect live data sources**: Integrate with your ad server/DSP
2. **Add alerting**: Set up notifications for policy violations
3. **Build dashboards**: Create executive summary views
4. **Training**: Educate team on how to ask effective questions

---

## 📞 Support & Resources

- **Technical Documentation**: `TECHNICAL_README.md` (detailed table specs)
- **Main README**: `README.md` (setup and overview)
- **Setup Scripts**: `sql_scripts/` folder
- **Snowflake Docs**: [Snowflake Intelligence Guide](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst)
- **Sample Data**: `demo_data/` folder
- **GitHub Repo**: https://github.com/robdaly1993/robdaly_SF_demos

---

## 🎯 Quick Reference Card

### Top 10 Must-Try Questions

1. "What is our viewability rate for 2025?"
2. "Show monthly impressions trend with a chart"
3. "Which publishers have the highest viewability?"
4. "Compare CPM by channel and exchange"
5. "Show fraud rate by exchange over time"
6. "What are our brand safety policies?"
7. "Which campaigns have best viewability for lowest CPM?"
8. "Go to IAB.com and compare viewability standards to ours"
9. "Check our policy thresholds then show which publishers exceed them"
10. "Research CTV benchmarks and tell me how we compare"

### Key Metrics to Demo
- Viewability Rate
- AVOC Rate (CTV focus)
- Fraud Rate
- CPM
- CTR
- Block Rate

### Best Web Scraping Targets
- IAB.com (standards)
- DoubleVerify.com (competitive)
- MediaRadar.com (benchmarks)
- AdExchanger.com (trends)

---

**Ready to wow your audience? Follow the demo script and have fun! 🎉**

*Pro tip: Practice the web scraping demos beforehand to ensure URLs are accessible!*
