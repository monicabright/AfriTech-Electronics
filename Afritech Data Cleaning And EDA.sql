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
FROM CustomerData
JOIN transactiondat
WHERE Age >= 60;

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

select sentiment, count (customerid)
from socialmedia
group by sentiment

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