

-- QUESTION 1 --
-- What is total revenue overall for sales in the assigned territory
-- plus the start date and end date that tell you what period the data covers?

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

SELECT 
SUM(SalesTotal) 
FROM online_sales
WHERE shiptostate = "Florida"; 
-- Q1 Total Revenue for online sales '2127916.38
-- Q1 Sum of Store Sales and Online Sales = "6058103.93" 



-- QUESTION 2 --
-- What is the month by month revenue breakdown for the sales territory?

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

SELECT 
year(Date) AS "Sales Year",
Month(Date) AS "Sales Month",
SUM(SalesTotal) AS "Monthly Online Sales" 
FROM online_sales
WHERE ShiptoState = "Florida"
GROUP BY 
year(Date),
Month(Date)
Order BY
year(Date),
Month(Date);
-- Q2 Breakdown of ONLINE SALES in FLORIDA showing sales Year,Month and Total Monthly Sales



-- QUESTION 3 --
-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
Select
SUM(SS.Sale_amount) AS "Overall Sales" 
FROM store_sales AS SS 
JOIN store_locations AS SL 
ON SS.Store_ID = SL.StoreId
where SL.state IN ('Florida', 'South Carolina', 'Texas');
-- Q3 Revenue total for Southern territory '7996850.12' (STORE SALES)

Select
SUM(SS.Sale_amount) AS "Overall Sales" 
FROM store_sales AS SS 
JOIN store_locations AS SL 
ON SS.Store_ID = SL.StoreId
WHERE SL.State = "Florida";
-- Q3 Using my inital query Total Revenue for assigned territory equals to '3930187.55'
-- Q3 3930187.55 / 7996850.12 X 10 
-- Q3 My assigned territory approximately makes up 49.15% of the regions revenue (STORE SALES) 








# QUESTION 4 
-- What is the number of transactions per month and 
-- average transaction size by product category for the sales territory?
