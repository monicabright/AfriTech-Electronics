CREATE TABLE Afritech (
CustomerID INT,
CustomerName TEXT,
Region TEXT,
Age INT,
Income NUMERIC,
CustomerType TEXT,
TransactionYear INT,
TransactionDate DATE,
ProductPurchased TEXT,
PurchaseAmount NUMERIC,
ProductRecalled BOOLEAN,
Competitor_x TEXT,
InteractionDate DATE,
Platform TEXT,
PostType TEXT,
EngagementLikes INT,
EngagementShares INT,
EngagementComments INT,	
UserFollowers INT,
InfluencerScore NUMERIC,
BrandMention BOOLEAN,
CompetitorMention BOOLEAN,
Sentiment TEXT,
CrisisEventTime DATE,
FirstResponseTime DATE,
ResolutionStatus BOOLEAN,
NPSResponse INT
);
 SELECT *
 FROM Afritech;

CREATE TABLE CustomerData (
CustomerID INT PRIMARY KEY,
CustomerName TEXT,
Region TEXT,
Age INT,
Income NUMERIC,
CustomerType TEXT
);

CREATE TABLE TransactionData (
Transactionid SERIAL PRIMARY KEY,
CustomerID INT,
TransactionYear INT,
TransactionDate DATE,
ProductPurchased TEXT,
PurchaseAmount NUMERIC,
ProductRecalled BOOLEAN,
FOREIGN KEY (CustomerID) REFERENCES CustomerData
);

CREATE TABLE SocialMedia (
Postid SERIAL PRIMARY KEY,
CustomerID INT,
InteractionDate DATE,
Platform TEXT,
PostType TEXT,
EngagementLikes INT,
EngagementShares INT,
EngagementComments INT,	
UserFollowers INT,
InfluencerScore NUMERIC,
BrandMention BOOLEAN,
CompetitorMention BOOLEAN,
Sentiment TEXT,
Competitor_x TEXT,
CrisisEventTime DATE,
FirstResponseTime DATE,
ResolutionStatus BOOLEAN,
NPSResponse INT,
FOREIGN KEY (CustomerID) REFERENCES CustomerData
);

SELECT *
FROM Afritech;

INSERT INTO CustomerData (CustomerID, CustomerName, Region, Age, Income, CustomerType)
SELECT DISTINCT CustomerID, CustomerName, Region, Age, Income, CustomerType
FROM Afritech;

INSERT INTO TransactionData (CustomerID, TransactionYear, TransactionDate, ProductPurchased, PurchaseAmount, ProductRecalled)
SELECT CustomerID, TransactionYear, TransactionDate, ProductPurchased, PurchaseAmount, ProductRecalled
FROM Afritech;

INSERT INTO SocialMedia (CustomerID, InteractionDate, Platform, PostType, EngagementLikes, EngagementShares, EngagementComments, UserFollowers, InfluencerScore, BrandMention, CompetitorMention, Sentiment, Competitor_x, CrisisEventTime, FirstResponseTime, ResolutionStatus, NPSResponse)
SELECT CustomerID,InteractionDate,Platform,
PostType, EngagementLikes, EngagementShares, EngagementComments, UserFollowers, InfluencerScore, BrandMention, CompetitorMention, Sentiment, Competitor_x, CrisisEventTime, FirstResponseTime, ResolutionStatus, NPSResponse
FROM Afritech;

SELECT *
FROM CustomerData;

SELECT *
FROM TransactionData;

SELECT *
FROM SocialMedia;

SELECT productpurchased, count(*) AS Purchase_quantity, SUM(purchaseamount) AS Total_sales
from transactiondata
group by productpurchased
order by Total_sales desc;

-- Replace the year column
UPDATE Transactiondata
SET transactionyear = EXTRACT(YEAR FROM transactiondate);

SELECT transactionyear, transactiondate
FROM TransactionData
WHERE transactionyear <> EXTRACT(YEAR FROM transactiondate);

-- Udate socialmedia cometitor column
UPDATE Socialmedia
SET competitor_x = 'None'
WHERE competitor_x IS NULL or competitor_x = ' ';

SELECT competitor_x
FROM SocialMedia
WHERE competitor_x = 'None';

SELECT competitor_x
FROM SocialMedia
WHERE competitor_x = IS NULL or competitor_x = ' ';

--1. (Customer EDA
-- Customer’s by region

--How many customers are in each region?

SELECT region, COUNT(CustomerID) AS Customer_regional_distribution
FROM CustomerData
GROUP BY region
ORDER BY Customer_regional_distribution;

-- Number of unique customers

SELECT COUNT (DISTINCT CustomerID) AS Unique_customers
FROM CustomerData;

--What is the highest, lowest and average age of our customers?

SELECT MAX(age) AS Highest_age, MIN(age) AS Lowest_age, ROUND(AVG(age), 0) AS Average_age
FROM CustomerData;

-- What is the customer distribution by type?

SELECT Customertype, COUNT(*) AS customer_type_distribution
FROM CustomerData
GROUP BY Customertype
ORDER BY 2 DESC;

-- Customer income distribution

--Who are our highest earning customers?

SELECT CustomerID, CustomerName, Income
FROM CustomerData
ORDER BY 3 DESC
LIMIT 10;

SELECT MAX(income) AS Highest_income,
MIN(income) AS Lowest_income,
ROUND(AVG(income), 0) AS Average_income
FROM CustomerData;

SELECT MAX(PurchaseAmount) AS Hghest_amount,
MIN(PurchaseAmount) AS Lowest_amount,
ROUND(AVG(PurchaseAmount), 0) AS Average_amount
FROM TransactionData;

-- Most Valuable product
SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
GROUP BY ProductPurchased
ORDER BY Total_sales DESC;

-- Most Recalled Product
SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
WHERE ProductRecalled = 'TRUE'
GROUP BY ProductPurchased
ORDER BY Total_sales DESC;

-- Recall Finacial Implication
SELECT ProductRecalled, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
GROUP BY ProductRecalled
ORDER BY Total_sales DESC;

-- Who are our most valuable customers?

SELECT c.CustomerID, CustomerName, SUM(PurchaseAmount)
FROM CustomerData c
LEFT JOIN TransactionData t
ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID
ORDER BY 3 DESC;

-- 2. Transaction EDA
-- Purchase amount distribution (max, min, avg)
-- Most purchased product
-- Product recall behavior 
-- count of recalled product 
-- ⁠Sum of recall revenue  ⁠

⁠-- 3. ⁠Social Media EDA
-- Behavior of Engagement_Likes per platforms 
-- Total likes 
-- ⁠Avg likes)

-- Find total sales and quantity for products that were marked as recalled.
-- Use this to see the financial size of the problem.

SELECT productpurchased, SUM(purchaseamount) AS Total_Recalled_Sales,
    COUNT(*) AS Recalled_Purchase_Quantity,
    ROUND(AVG(purchaseamount), 2) AS Average_Recalled_Purchase
FROM TransactionData
WHERE ProductRecalled = TRUE
GROUP BY productpurchased
ORDER BY Total_Recalled_Sales DESC;

-- ADDRESSING THE 4 BUSINESS PROBLEMS
-- 1.BRAND HEALTH & SENTIMENT QUESTIONS (The Problem: Negative Social Media Buzz)
-- These queries will show us how bad the situation is and where the problem is coming from so as to know what to do)

-- Check the brand's overall Health
-- What is the ratio of Positive posts versus Negative posts over the last three years?
-- Calculate the total count and ratio of Positive, Negative, and Neutral posts
-- across the entire three-year period (2021-2023).

SELECT sentiment
    FROM SocialMedia
    WHERE sentiment IS NULL;

SELECT sentiment, COUNT(sentiment) AS Total_Posts
    FROM SocialMedia
    GROUP BY sentiment;

WITH SentimentCounts AS
    (SELECT sentiment, COUNT(sentiment) AS Total_Posts
    FROM SocialMedia
    GROUP BY sentiment)
SELECT sentiment, Total_Posts,
    ROUND((Total_Posts * 100.0) / SUM(Total_Posts) OVER (), 2) AS Percentage_of_Total
FROM SentimentCounts
ORDER BY Total_Posts DESC;

-- Platform Priority
-- Which social media platform (e.g., Twitter, Facebook) has the most negative sentiment posts?
SELECT platform, COUNT(sentiment) AS Total_Sentiments, COUNT(Sentiment)
FROM socialmedia
WHERE Sentiment = 'Negative'
GROUP BY platform
ORDER BY Total_sentiments DESC;

-- Which social media platform (e.g., Twitter, Facebook) has the most positive sentiment posts?
SELECT platform, COUNT(sentiment) AS Total_Sentiments, COUNT(Sentiment)
FROM socialmedia
WHERE Sentiment = 'Positive'
GROUP BY platform
ORDER BY Total_sentiments DESC;

-- Calculate the percentage of negative posts on this platform out of ALL negative posts
SELECT platform, COUNT(platform) AS Total_Negative_Posts,
    ROUND((COUNT(platform) * 100.0)/ SUM(COUNT(platform)) OVER () -- Sum of all negative posts across platforms
    , 2) AS Percentage_of_Total_Negative
FROM SocialMedia
WHERE sentiment = 'Negative'
GROUP BY platform
ORDER BY Total_Negative_Posts DESC;

-- Calculate the percentage of positive posts on this platform out of ALL positive posts
SELECT platform, COUNT(platform) AS Total_positive_Posts,
    ROUND((COUNT(platform) * 100.0)/ SUM(COUNT(platform)) OVER () -- Sum of all negative posts across platforms
    , 2) AS Percentage_of_Total_positive
FROM SocialMedia
WHERE sentiment = 'Positive'
GROUP BY platform
ORDER BY Total_Positive_Posts DESC;

-- Post Impact: Are negative posts being shared or commented on more than positive posts? (Check average Likes/Shares/Comments by Sentiment).
SELECT sentiment,
    COUNT(*) AS Total_Posts,
    ROUND(AVG(engagementlikes), 0) AS Avg_Likes_Per_Post,
    ROUND(AVG(engagementshares), 0) AS Avg_Shares_Per_Post,
    ROUND(AVG(engagementcomments), 0) AS Avg_Comments_Per_Post,
-- Calculate a weighted total engagement score for easy comparison
    ROUND(AVG(engagementlikes + engagementshares + engagementcomments), 0) AS Avg_Total_Engagement
FROM SocialMedia
WHERE sentiment IN ('Positive', 'Negative', 'Neutral')
GROUP BY sentiment
ORDER BY Avg_Total_Engagement DESC;

-- Influencer Risk: How many negative posts come from users with a high Influencer Score?
-- This identifies high-priority, high-visibility negative posts that require immediate response.

SELECT MAX(influencerscore), MIN(influencerscore), AVG(influencerscore)
FROM SocialMedia;

SELECT
	COUNT(*) AS High_Risk_Negative_Posts,
	ROUND(AVG(userfollowers) , 0) AS Avg_Followers_of_High_Risk_Users,
	ROUND(AVG(engagementshares) , 0) AS Avg_Shares_on_High_Risk_Posts
FROM SocialMedia
WHERE sentiment = 'Negative' AND InfluencerScore > 30;

-- which product has the most negative/positive impact on brand health?
-- This query links transaction data to social media sentiment to find product-specific brand health.

 SELECT t.ProductPurchased, s.Sentiment, COUNT(s.Sentiment) AS SentimentCount
    FROM TransactionData t
    JOIN SocialMedia s ON t.CustomerID = s.CustomerID
    WHERE s.Sentiment IN ('Positive', 'Negative') -- Focus on clear sentiment
    GROUP BY t.ProductPurchased, s.Sentiment
	ORDER BY Sentiment

WITH ProductSentiment AS (
    SELECT t.ProductPurchased, s.Sentiment, COUNT(s.Sentiment) AS SentimentCount
    FROM TransactionData t
    JOIN SocialMedia s ON t.CustomerID = s.CustomerID
    WHERE s.Sentiment IN ('Positive', 'Negative') -- Focus on clear sentiment
    GROUP BY t.ProductPurchased, s.Sentiment),
	ProductTotals AS (
    SELECT ProductPurchased, SUM(SentimentCount) AS TotalSentimentPosts
    FROM ProductSentiment
    GROUP BY ProductPurchased)
SELECT ps.ProductPurchased,
    -- Calculate Net Sentiment Score: (% Positive) - (% Negative)
    ROUND(
        (CAST(SUM(CASE WHEN ps.Sentiment = 'Positive' THEN ps.SentimentCount ELSE 0 END) AS NUMERIC) * 100.0 / pt.TotalSentimentPosts)
        - (CAST(SUM(CASE WHEN ps.Sentiment = 'Negative' THEN ps.SentimentCount ELSE 0 END) AS NUMERIC) * 100.0 / pt.TotalSentimentPosts)
    , 2) AS Net_Sentiment_Score
FROM ProductSentiment ps
JOIN ProductTotals pt ON ps.ProductPurchased = pt.ProductPurchased
GROUP BY ps.ProductPurchased, pt.TotalSentimentPosts
ORDER BY Net_Sentiment_Score DESC;

-- 2. Competitive Questions (The Problem: Rivals Gaining Share)
-- These questions helps to see where rivals are winning the conversation.

-- Share of Voice (SOV): How much of the social conversation is about AfriTech versus its competitors?
-- This is a key competitive metric for market share and reputation.
-- SOV = total brandmentions/(brandmentions + Competitormentions)

SELECT brandmention, competitormention
FROM socialmedia
WHERE brandmention = 'True' AND Competitormention = 'True'

-- Use CTE

SELECT COUNT(brandmention) AS Afritech_mentions--, COUNT(competitormention) AS Competitor_mentions
FROM socialmedia
WHERE brandmention = 'True';

SELECT COUNT(*) AS Competitor_mentions
FROM socialmedia
WHERE competitormention = 'True';

SELECT brandmention, competitormention
FROM Socialmedia

SELECT competitormention
FROM Socialmedia

WITH Brandmentions AS (SELECT COUNT(*) AS Afritech_mentions
	FROM socialmedia
	WHERE brandmention = 'True'),
	Competitormentions AS (SELECT COUNT(*) AS Competitor_mentions
	FROM socialmedia
	WHERE competitormention = 'True')
SELECT Afritech_mentions, Competitor_mentions,
	ROUND((CAST(Afritech_mentions AS NUMERIC)*100)/(Afritech_mentions + Competitor_mentions), 2)
	AS SOV_percent
FROM Brandmentions
CROSS JOIN Competitormentions

-- Rival Focus: Which specific competitor is mentioned most often in social posts?

SELECT Competitor_x, COUNT(*) AS Competitor_count
FROM SocialMedia
WHERE competitormention = 'True'
GROUP BY 1
ORDER BY 2 DESC; --Most mentioned competitor is Marstech

-- Product Threat:
--what is our most valuable product?

SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
GROUP BY ProductPurchased
ORDER BY Total_sales DESC; -- Most valuable product by revenue is Laptop

-- Most Recalled Product
SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
WHERE ProductRecalled = 'TRUE'
GROUP BY ProductPurchased
ORDER BY Total_sales DESC; -- Most Recalled product is laptop

-- What is the SOV for our most valuable product (laptop) compared to competitors' mentions?
-- This measures competitive performance in the most critical product segment.

SELECT COUNT(*) AS Afritech_Laptop_mentions
FROM Socialmedia s
JOIN Transactiondata t
ON s.CustomerID = t.CustomerID
WHERE t.Productpurchased = 'Laptop' AND s.Brandmention = 'True'

SELECT COUNT(*) AS Competitor_Laptop_mentions
FROM Socialmedia s
JOIN Transactiondata t
ON s.CustomerID = t.CustomerID
WHERE t.Productpurchased = 'Laptop' AND s.competitormention = 'True'

-- Put into CTE

WITH LaptopBrandMentions AS(
		SELECT COUNT(*) AS Afritech_Laptop_mentions
		FROM Socialmedia s
		JOIN Transactiondata t
		ON s.CustomerID = t.CustomerID
		WHERE t.Productpurchased = 'Laptop' AND s.Brandmention = 'True'
		),
	LaptopCompetitorMentions AS (
		SELECT COUNT(*) AS Competitor_Laptop_mentions
		FROM Socialmedia s
		JOIN Transactiondata t
		ON s.CustomerID = t.CustomerID
		WHERE t.Productpurchased = 'Laptop' AND s.competitormention = 'True'
		)
	SELECT lbm.Afritech_Laptop_mentions, lcm.Competitor_Laptop_mentions,
		   ROUND((CAST(lbm.Afritech_Laptop_mentions AS NUMERIC)*100)/(lbm.Afritech_Laptop_mentions + lcm.Competitor_Laptop_mentions), 2)
		   AS Laptop_SOV_percent
	FROM LaptopBrandMentions lbm
	CROSS JOIN LaptopCompetitorMentions lcm
	
-- The Laptop Share of Voice is 50.78%, meaning you only slightly lead the conversation.
-- This 50/50 split is dangerously low and signals weak dominance.
-- Competitors are highly effective and capturing almost half the social attention.
-- To protect revenue and market dominance, this score needs to be boosted toward 70% or more.


-- 3. CUSTOMER SERVICE & LOYALTY QUESTIONS (THE PROBLEM: CHURN & DELAYS)

-- VIP Risk

-- What is the customer distribution by type?

SELECT Customertype, COUNT(*) AS customer_type_distribution
FROM CustomerData
GROUP BY Customertype
ORDER BY 2 DESC;

-- How many VIP customers have posted something with Negative sentiment?

SELECT C.Customertype, COUNT(DISTINCT C.CustomerID) AS Total_Sentiment_posts
FROM CustomerData C
JOIN SocialMedia S
ON C.CustomerID = S.CustomerID
WHERE S.Sentiment = 'Negative'
GROUP BY C.Customertype
ORDER BY 2 DESC;

SELECT COUNT(DISTINCT C.CustomerID) AS Total_VIP_customers
FROM Customerdata C
JOIN SocialMedia S
ON C.CustomerID = S.CustomerID
WHERE Sentiment = 'Negative' AND c.Customertype = 'VIP'; -- Total VIP Customers with Negative posts is 66

-- Details of VIP customers with negatve post details

SELECT C.Customername, C.Customertype, S.sentiment, COUNT(Sentiment) AS Total_negative_posts
FROM Customerdata C
JOIN SocialMedia S
ON C.CustomerID = S.CustomerID
WHERE Sentiment = 'Negative' AND Customertype = 'VIP'
GROUP BY C.Customername, C.Customertype, S.sentiment
ORDER BY 4 DESC;

-- Slow Response: What is the average time (in hours) it takes for AfriTech to give a First Response to a crisis event?
-- This directly addresses the 'delays in customer support' challenge by calculating the Average First Response Time (AFRT).

-- Calculate the average time difference (interval) between response and crisis time

SELECT FirstResponseTime, CrisisEventTime
FROM SocialMedia
WHERE CrisisEventTime IS NOT NULL
      AND FirstResponseTime IS NOT NULL
	  
-- Days
SELECT 
    ROUND(AVG(FirstResponseTime - CrisisEventTime), 0) AS AvgResponseTimeMonths
FROM SocialMedia
WHERE FirstResponseTime IS NOT NULL AND CrisisEventTime IS NOT NULL -- 190 days
	  
-- Months
SELECT 
    ROUND((AVG(FirstResponseTime - CrisisEventTime))/30, 0) AS AvgResponseTimeMonths
FROM SocialMedia
WHERE FirstResponseTime IS NOT NULL AND CrisisEventTime IS NOT NULL -- 6 Months

-- Service Success: What percentage of crisis events (negative posts) are successfully marked as Resolved?
-- The Resolution Rate; a KPI that measures the effectiveness of customer service in closing negative issues.

WITH NegativePostCounts AS (
    SELECT
        COUNT(*) AS Total_Negative_Posts,
        -- Count only the negative posts that have been marked as resolved (ResolutionStatus = TRUE)
        SUM(CASE WHEN ResolutionStatus = TRUE THEN 1 ELSE 0 END) AS Resolved_Negative_Posts
    FROM
        SocialMedia
    WHERE
        sentiment = 'Negative'
)
SELECT
    Total_Negative_Posts,
    Resolved_Negative_Posts,
    -- Calculate the Resolution Rate percentage
    ROUND(
        (CAST(Resolved_Negative_Posts AS NUMERIC) * 100.0) / Total_Negative_Posts
    , 2) AS Resolution_Rate_Percent
FROM
    NegativePostCounts;

SELECT COUNT(*) AS Crisis_count
FROM SocialMedia
WHERE Sentiment = 'Negative'

SELECT COUNT(*) AS Resolved_Crisis
FROM SocialMedia
WHERE Sentiment = 'Negative' AND Resolutionstatus = 'True'

-- Use CTE
WITH Crisiscount AS (SELECT COUNT(*) AS Crisis_count
                     FROM SocialMedia
                     WHERE Sentiment = 'Negative'),
	 Resolvedcrisis AS (SELECT COUNT(*) AS Resolved_Crisis
                    FROM SocialMedia
                    WHERE Sentiment = 'Negative' AND Resolutionstatus = 'True')
SELECT Crisis_count, Resolved_crisis, ROUND((CAST(Resolved_crisis AS NUMERIC) * 100/Crisis_count), 2) AS Resolution_rate
FROM Crisiscount, Resolvedcrisis -- Resolution Rate = 47.59%

-- **NPS Score
SELECT
  CASE
    WHEN npsresponse BETWEEN 9 AND 10 THEN 'Evangelist / supporter'
    WHEN npsresponse BETWEEN 7 AND 8 THEN 'Convertible / at_risk'
    WHEN npsresponse BETWEEN 0 AND 6 THEN 'Opponent / churn_risk'
    ELSE 'Unknown'
  END AS nps_segment,
  COUNT(*) AS count_of_responses
FROM SocialMedia
WHERE npsresponse IS NOT NULL
GROUP BY nps_segment
ORDER BY count_of_responses DESC;

--Loyalty: Do Returning customers show more negative sentiment than New customers?

SELECT customertype, COUNT(*) AS sentiment_count, ROUND(AVG(NPSResponse), 0) AS avg_NPS_score
FROM Customerdata  c
JOIN Socialmedia s
ON c.customerid = s.customerid
WHERE sentiment = 'Negative'
GROUP BY c.customertype
ORDER BY 3

-- This query calculates a Net Sentiment Score (NSS) proxy for NPS by customer type to identify reputation risks among loyal customers.

SELECT c.CustomerType, s.Sentiment, COUNT(*) AS SentimentCount
FROM SocialMedia s
JOIN CustomerData c ON s.CustomerID = c.CustomerID
WHERE s.Sentiment IN ('Positive', 'Negative') -- Focus on Promoters (Positive) and Detractors (Negative)
GROUP BY c.CustomerType, s.Sentiment

-- Calculate Net Sentiment Score (%Positive - %Negative)
WITH CustomerSentiment AS (
    SELECT c.CustomerType, s.Sentiment, COUNT(*) AS SentimentCount
    FROM SocialMedia s
    JOIN CustomerData c ON s.CustomerID = c.CustomerID
    WHERE s.Sentiment IN ('Positive', 'Negative') -- Focus on Promoters (Positive) and Detractors (Negative)
    GROUP BY c.CustomerType, s.Sentiment
	),
   CustomerTotals AS (
    SELECT CustomerType, SUM(SentimentCount) AS TotalSentimentPosts
    FROM CustomerSentiment
    GROUP BY CustomerType
	)
SELECT cs.CustomerType, ct.TotalSentimentPosts,
    -- Calculate Net Sentiment Score (NSS) proxy for NPS: (% Positive) - (% Negative)
    ROUND((CAST(SUM(CASE WHEN cs.Sentiment = 'Positive' THEN cs.SentimentCount ELSE 0 END) AS NUMERIC) * 100.0 / ct.TotalSentimentPosts)
        - (CAST(SUM(CASE WHEN cs.Sentiment = 'Negative' THEN cs.SentimentCount ELSE 0 END) AS NUMERIC) * 100.0 / ct.TotalSentimentPosts),
		2) AS Net_Sentiment_Score
FROM CustomerSentiment cs
JOIN CustomerTotals ct ON cs.CustomerType = ct.CustomerType
GROUP BY cs.CustomerType, ct.TotalSentimentPosts
ORDER BY Net_Sentiment_Score ASC; -- Order by ASC to bring the lowest (most negative) scores to the top.


--4. Financial & Product Impact Questions (The Problem: Recalls)
-- These questions tie the reputation damage directly to the sales and products involved.

-- Financial Damage: What is the total purchase amount of products that were later recalled?

-- Most Valuable product
SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
GROUP BY ProductPurchased
ORDER BY Total_sales DESC; -- Laptop

-- Most Recalled Product
SELECT ProductPurchased, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
WHERE ProductRecalled = 'TRUE'
GROUP BY ProductPurchased
ORDER BY Total_sales DESC; -- Latop

-- Recall Finacial Implication
SELECT ProductRecalled, COUNT(ProductPurchased) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_sales
FROM TransactionData
GROUP BY ProductRecalled
ORDER BY Total_sales DESC; -- $28,900,611.77

-- % of recalled revenue
SELECT ProductRecalled, COUNT(PurchaseAmount) AS Total_Quantity,
SUM(PurchaseAmount) AS Total_Sales, ROUND((SUM(PurchaseAmount) * 100.0)/ SUM(SUM(PurchaseAmount)) OVER (), 2) AS recall_percent
FROM TransactionData
GROUP BY ProductRecalled
ORDER BY Total_Sales DESC; -- 50.23% of total Revenue refunded
	
-- Recall Feedback: What percentage of customers who purchased a recalled product later posted a Negative review on social media?
-- This measures the severity of the possible damage from product recalls.

SELECT COUNT(DISTINCT t.customerid) AS Recalled_negative_reviews
FROM Transactiondata t
JOIN SocialMedia s
ON t.customerid = s.customerid
WHERE Productrecalled = 'True' AND Sentiment = 'Negative'

SELECT COUNT(DISTINCT t.customerid) AS Total_recalls
FROM Transactiondata t
JOIN SocialMedia s
ON t.customerid = s.customerid
WHERE Productrecalled = 'True'

-- Use CTE
WITH RN_reviews AS (SELECT COUNT(DISTINCT t.customerid) AS Recalled_negative_reviews
				FROM Transactiondata t
				JOIN SocialMedia s
				ON t.customerid = s.customerid
				WHERE Productrecalled = 'True' AND Sentiment = 'Negative'
				),
Totalrecalls AS (SELECT COUNT(DISTINCT t.customerid) AS Total_recalls
				FROM Transactiondata t
				JOIN SocialMedia s
				ON t.customerid = s.customerid
				WHERE Productrecalled = 'True')
SELECT Recalled_negative_reviews, Total_recalls, ROUND((CAST(Recalled_negative_reviews AS NUMERIC)*100/Total_recalls), 2)
	   AS Recalled_negative_percent
FROM RN_reviews, Totalrecalls -- 99% 0fcustomers whose product was recalled still gave a negative review

-- Product Vulnerability: Which product (Smartphone, Tablet, etc.) has the highest count of Negative sentiment mentions?

SELECT Productpurchased, COUNT(*) AS Total_negative_sentiments
FROM Transactiondata t
JOIN SocialMedia s
ON t.customerid = s.customerid
WHERE Sentiment = 'Negative'
GROUP BY Productpurchased, Sentiment
ORDER BY 2 DESC -- Laptop

SELECT COUNT(*) AS Total_sentiments
FROM Transactiondata t
JOIN SocialMedia s
ON t.customerid = s.customerid
WHERE Sentiment = 'Negative'
GROUP BY Sentiment
ORDER BY 1 DESC

-- Calculate percntage

WITH Negativereviewsbyproduct AS (SELECT Productpurchased, COUNT(*) AS Total_negative_sentiments
								FROM Transactiondata t
								JOIN SocialMedia s
								ON t.customerid = s.customerid
								WHERE Sentiment = 'Negative'
								GROUP BY Productpurchased, Sentiment),
	Totalnegativereviews AS (SELECT COUNT(*) AS Total_sentiments
								FROM Transactiondata t
								JOIN SocialMedia s
								ON t.customerid = s.customerid
								WHERE Sentiment = 'Negative'
								GROUP BY Sentiment)
SELECT Productpurchased, Total_negative_sentiments,
	   ROUND((CAST(Total_negative_sentiments AS NUMERIC)*100/Total_sentiments), 2)
	   AS Negative_sentiment_percent
FROM Negativereviewsbyproduct, Totalnegativereviews
ORDER BY 2 DESC -- Laptop

-- KPIs

-- Net Sentiment Score (NSS): (% Positive Posts) - (% Negative Posts); The overall health of the brand conversation.

SELECT
(SUM(CASE WHEN sentiment = 'Positive' THEN 1 ELSE 0 END))*100
FROM Socialmedia
WHERE sentiment IN ('Positive', 'Negative')


-- Share of Voice (SOV): AfriTech's presence relative to competitors in social conversation.
-- NPS by Customer Type: measures the loyalty and recommendation likelihood broken down by segment.
-- Goal is to track Net Promoter Score (NPS) specifically for VIP, Returning, and New customers to prevent churn in high-value segments.
-- Recall Feedback Ratio: measures the direct correlation between product failure and public reputation damage
-- Goal checks % of customers who bought a recalled product and posted Negative Sentiment. Quantifies the severity of product recall damage.
-- Average Purchase Value (by Sentiment): measures the revenue impact of dissatisfied customers.
-- Goal is to determine if customers who have posted negative sentiment have a lower average spend, highlighting financial risk.
-- Average First Response Time (AFRT): measures the speed of customer service intervention on social media.
-- Goal is to measure the time between a crisis event and the company's first response. Lower is better and reduces panic.
-- Resolution Rate: measures the overall success rate of resolving public complaints.
-- Goal is to track % of negative events marked as 'Resolved'. This shows operational effectiveness and closure of the customer issue loop.
-- Unresolved Backlog Volume: measures the total volume of active, unresolved reputation threats.
-- Goal: gives a simple count of open issues where ResolutionStatus is FALSE. This is the outstanding risk to the brand.