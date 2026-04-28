

-- QUESTION 1 --
-- What is total revenue overall for sales in the assigned territory--
-- plus the start date and end date that tell you what period the data covers?--

-- Used JOIN in query to get information from Store sales and Store location 
-- Showing Overall In-Store sales in FL Territory with Start and End period. 
SELECT 
Sum(ss.sale_Amount) AS "OVERALL SALES",
MIN(ss.Transaction_Date) AS Start,
MAX(ss.Transaction_Date) AS End
From Store_sales SS
JOIN store_locations AS SL 
ON SS.Store_ID = SL.StoreId
WHERE SL.State = "Florida";
-- Q1 Total Revenue for store sales '3930187.55'
-- Q1 Start Date '2022-01-01' End Date '2025-12-31'


-- QUESTION 2 --
-- What is the month by month revenue breakdown for the sales territory? --

-- Query formats Date to show Year and Month while calculating the SUM of monthly 
-- In-Store sales by using store ID # for FL territory
SELECT
Year(transaction_date) AS Sales_Year, 
Month(Transaction_date) AS Sales_Month, 
SUM(Sale_Amount) AS Monthly_Sales 
FROM store_sales 
WHERE Store_ID BETWEEN 719 AND 729 
GROUP BY  
Year(transaction_date), 
Month(Transaction_date) 
ORDER BY  Sales_Year, Sales_Month;
-- Q2 Breakdown of STORE SALES in FLORIDA showing sales Year,Month and Total Monthly Sales


-- QUESTION 3 --
-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

-- Subquery created to find the SUM of sales amount for In-Store Southern Region
SELECT 
SUM(ss.Sale_Amount) AS "Overall Southern Region Sales"
FROM store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State IN ('Florida', 'South Carolina', 'Texas');
-- Q3 Overall Southern region sales total '7996850.12'


-- Subquery created to find the SUM of sales amount for In-Store FL territory 
SELECT
sum(ss.Sale_Amount)
From Store_sales ss
JOIN store_locations sl
ON ss.Store_ID = sl.StoreID
WHERE sl.State IN ('Florida');
-- Q3 Overall FL territory total '3930187.55'
-- Q3 The FL territory is generating approximately 49.15% of all sales in the Southern Region

-- QUESTION 4 -- 
-- What is the number of transactions per month 
-- and average transaction size by product category for the sales territory?

-- Query created with multiple joins Count func to count all transactions
-- Avg to find average size of transactions 
SELECT
Month(ss.Transaction_Date) AS Month,
Year(ss.Transaction_Date) AS Year,
IC.Category,
COUNT(*) AS "Transaction Count",
AVG(ss.Sale_Amount) AS "Transaction Average" 
FROM Store_sales AS SS 
JOIN Products AS P
ON P.ProdNum = ss.Prod_Num
JOIN inventory_categories AS IC
ON Ic.CategoryID = P.CategoryID
JOIN store_locations AS SL 
ON sl.StoreID = ss.Store_ID
WHERE sl.state IN ('Florida')
GROUP BY 
Year(ss.Transaction_Date),
Month(ss.transaction_Date),
ic.Category
ORDER BY 
Ic.Category,
Year(ss.Transaction_Date),
Month(ss.transaction_Date); 
-- Q4 Breakdown of Category by month showing the transaction count and transaction average



-- QUESTION 5 -- 
-- Can you provide a ranking of in-store sales performance by each store in the sales territory
-- or a ranking of online sales performance by state within an online sales territory?

-- Query using SUM func for total sales amount - Ordered by sales performance desc to rank based on highest performing
SELECT
sl.StoreLocation AS Location,
sl.StoreID,
SUM(ss.Sale_Amount) AS Sales_Performance
FROM store_locations sl
JOIN store_sales ss
ON ss.Store_ID = sl.StoreID
WHERE sl.StoreID BETWEEN 719 AND 729
GROUP BY
sl.StoreLocation,
sl.StoreID
ORDER BY
Sales_Performance DESC;
-- Q5 Rankin FL territory locations on Sales performance with highest ranking being 'Miami', '724', '618846.25'



-- QUESTION 6 -- 
-- What is your recommendation for where to focus sales attention in the next quarter?
