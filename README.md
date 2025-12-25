# AfriTech Brand Health &amp; Product Risk Assessment
## Project Background
This report presents a comprehensive brand health and product performance assessment for AfriTech Electronics, a leader in the global consumer electronics industry. AfriTech has been a market fixture for over a decade, operating on a high-volume hardware sales business model across smartphones, laptops, and wearables. Currently, the company manages a database reflecting over 292 million customer engagements; however, recent metrics indicate a critical disconnect between market reach and customer retention.

## Insights and recommendations are provided on the following key areas:
- **Category 1:** Financial Risk & Product Integrity (Recall analysis and revenue impact)
- **Category 2:** Service Delivery Efficiency (Response times and resolution rates)
- **Category 3:** VIP Customer Lifecycle (Retention and service equity for high-value users)
- **Category 4:** Demographic Engagement (Revenue contribution and engagement by generation)

The SQL queries used to inspect and clean the data for this analysis can be found here [[link]].

Targeted SQL queries regarding various business questions can be found here [[link]].

An interactive Power BI dashboard used to report and explore sales trends can be found here [[link]].

## Data Structure & Initial Checks
The database structure consists of three primary tables with a total row count of approximately 200 customer-specific records and millions of engagement log entries.
- **Table 1 (Customer):** Contains demographic data, including age, income level (average $61,000), and loyalty tier.
- **Table 2 (Social Media):** Tracks 292M touchpoints including social media interactions, marketing clicks, and customer engagement metrics.
- **Table 3 (Transaction):** Records transaction history across product categories (Laptop, Smartphone, Tablet, etc.), including revenue data and product recall status.

[Entity Relationship Diagram: Primary Key CustomerID links the Customer table to the Transaction and Social Media tables.]

# Executive Summary
## Overview of Findings
The analysis reveals a brand facing a "Dual Crisis": extreme product instability and a significant breakdown in customer service operations. While AfriTech commands a 50.6% Share of Voice in the industry, 51% of total revenue ($29M) is currently tied to recalled products. Furthermore, high-value VIP customers are experiencing average response times exceeding six months, creating a substantial risk to the core revenue base.
[Visualization: A combined bar-and-line chart showing Revenue vs. Recall Rate by Product Category, highlighting the $25M Laptop revenue segment.]

## Insights Deep Dive
### Category 1: Financial Risk & Product Integrity
- **Systemic Recall Crisis.** Data indicates that 51% of all revenue ($29M out of $57.5M) is currently classified as "Recalled."
- **Laptop Vulnerability.** The Laptop line is the highest revenue generator ($25M) but also exhibits the highest failure rate with 10,000 recorded recalls.
- **Revenue Exposure.** Over half of the financial intake is currently unstable due to these quality control failures.
- **Brand Sentiment.** High engagement (292M) paired with high recalls suggests that while marketing is effective at acquisition, product quality is undermining long-term retention.
[Visualization: Treemap showing Revenue by Product Category, with a red overlay indicating the percentage of recalls.]

### Category 2: Service Delivery Efficiency
- **Critical Response Lag.** The average time to respond to a customer is 189 days (roughly 6.3 months), a duration that limits the effectiveness of any resolution attempt.
- **Low Resolution Success.** Only 48% of support tickets are successfully resolved, meaning more than half of all customer issues remain open or concluded without satisfaction.
- **Process Inefficiency.** New customers face the longest wait times (199 days), damaging the brand experience at the initial point of contact.
- **Engagement Disconnect.** Despite high engagement volumes, the lack of backend support infrastructure indicates that the brand is visible but failing to provide necessary post-purchase support.

### Category 3: VIP Customer Lifecycle
- **VIP Revenue Concentration.** A small group of 67 VIP customers generates $24.2M, representing 42.1% of total revenue.
- **Service Inequity.** There is currently no "Fast-Track" for high-value users; VIPs wait an average of 188 days for support, matching the general population.
- **High Flight Risk.** Given the high income ($61k avg) of the customer base, these users possess the means to transition to competitors if service levels do not improve.
- **Churn Probability.** Analysis suggests a high correlation between response times exceeding 100 days and a 0% return-purchase rate for the VIP segment.

### Category 4: Demographic Engagement
- **Gen X Dominance.** The 44-59 age bracket generates the highest revenue but is also the segment most impacted by Laptop recalls.
- **Millennial Volume.** Millennials (28-43) show the highest engagement volume (0.73M), primarily centered around Smartphone purchases.
- **Income Alignment.** The average customer income of $61,000 aligns with a "premium" product expectation that is currently unmet by current quality standards.
- **Market Share of Voice.** At 50.6% SOV, AfriTech is the most discussed brand in its peer group; however, sentiment is trending negative due to the product and service issues identified.

## Recommendations:
Based on the insights and findings, the following actions are recommended for the AfriTech Executive Leadership and Operations teams:
- **VIP Revenue Protection:** Immediately establish a "VIP Fast-Track" support queue. Prioritizing the 67 customers who provide 42% of revenue is a critical step to prevent a catastrophic revenue drop.
- **Laptop Quality Audit:** Launch an emergency engineering review of the Laptop production line to identify the technical root cause of the 10,000 recalls.
- **Complaint Analysis Project:** The current dataset does not track the specific reasons for customer complaints. A targeted audit of support transcripts and social media comments is recommended to categorize failure modes (e.g., battery failure vs. software bugs).
- **Service SLA Overhaul:** Implement a 48-hour response time mandate. The current 189-day average is damaging the brand and must be reduced through process automation or increased support capacity.
- **Demographic Alignment:** Adjust marketing communications for Gen X to address the Laptop issues directly, perhaps offering extended warranties to rebuild consumer trust.

## Assumptions and Caveats:
Multiple assumptions were made to manage challenges with the data during the analysis:
- **Data Gap (Complaint Reasons):** As the dataset did not include a specific "Reason for Complaint" field in the Transaction table, it was assumed that recall status was the primary driver of negative customer sentiment.
- **Revenue Attribution:** Revenue was calculated based on total sales volume; however, because 51% are recalled, "Net Revenue" may be significantly lower once refunds and logistics costs are factored in.
- **Response Time Calculation:** For tickets that are still "Open," the response time was calculated using the current date (November 2025) minus the ticket creation date.
