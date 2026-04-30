
-- =========================================================
-- Capstone 1: Florida In-Store Sales Analysis
-- Analyst: Victoria Ordonez
-- Database: sample_sales
-- Assigned Territory: Florida in-store sales
--
-- Purpose:
-- This script analyzes Florida in-store sales performance for EmporiUm.
-- The results answer the sales manager's required questions about revenue,
-- monthly trends, region comparison, product category performance,
-- store rankings, and next-quarter sales focus.
-- =========================================================

USE sample_sales;

-- =========================================================
-- QUESTION 1
-- What is total revenue overall for sales in the assigned territory, plus the start date and end date
-- that tell you what period the data covers?
--
-- Logic:
-- Join Store_Sales to Store_Locations so each sale can be matched to a state.
-- Filter to Florida because that is the assigned sales territory.
-- Use SUM to calculate total revenue.
-- Use MIN and MAX to find the first and last transaction dates.
-- =========================================================
SELECT
    SUM(ss.Sale_Amount) AS `OVERALL SALES`,
    MIN(ss.Transaction_Date) AS `Start`,
    MAX(ss.Transaction_Date) AS `End`
FROM Store_Sales AS ss
JOIN Store_Locations AS sl
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Florida';

-- Answer:
-- Florida in-store sales had total revenue of $3,930,187.55.
-- The data covers sales from 2022-01-01 to 2025-12-31.


-- =========================================================
-- QUESTION 2
-- What is the month by month revenue breakdown for the sales territory?
--
-- Logic:
-- Join sales to store locations to filter only Florida stores.
-- Break each transaction date into year and month.
-- Group by year and month so each row shows one month of revenue.
-- Sort the results in date order to make the trend easy to read.
-- =========================================================
SELECT
	YEAR(ss.Transaction_Date) AS sales_year,
	MONTH(ss.Transaction_Date) AS sales_month,
	SUM(ss.Sale_Amount) AS monthly_revenue
FROM Store_Sales AS ss
JOIN Store_Locations AS sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Florida'
GROUP BY
	YEAR(ss.Transaction_Date),
	MONTH(ss.Transaction_Date)
ORDER BY
	sales_year,
	sales_month;

-- Answer:
-- This query shows Florida's in-store revenue month by month.
-- The highest monthly revenue was October 2025 with $188,215.96.
-- The lowest monthly revenue was September 2022 with $42,839.10.

-- =========================================================
-- QUESTION 3
-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
--
-- Logic:
-- Join Store_Sales to Store_Locations to connect each sale to a state.
-- Join Store_Locations to Management to identify each state's region.
-- Filter to the South region.
-- Use CASE WHEN to separate Florida revenue from the full South region total.
-- Divide Florida revenue by South region revenue to calculate Florida's
-- percentage of the region.
-- =========================================================
SELECT
    'Florida' AS territory,
    m.Region AS region,
    SUM(CASE
            WHEN sl.State = 'Florida' THEN ss.Sale_Amount
            ELSE 0
        END) AS territory_revenue,
    SUM(ss.Sale_Amount) AS region_revenue,
    ROUND(
        SUM(CASE
                WHEN sl.State = 'Florida' THEN ss.Sale_Amount
                ELSE 0
            END) / SUM(ss.Sale_Amount) * 100,
        2
    ) AS territory_percent_of_region
FROM Store_Sales AS ss
JOIN Store_Locations AS sl
    ON ss.Store_ID = sl.StoreId
JOIN Management AS m
    ON sl.State = m.State
WHERE m.Region = 'South'
GROUP BY m.Region;

-- Answer:
-- Florida in-store revenue was $3,930,187.55.
-- The total South region in-store revenue was $7,996,850.12.
-- Florida made up 49.15% of the South region's in-store revenue.

-- =========================================================
-- QUESTION 4
-- What is the number of transactions per month and average transaction size by product category
-- for the sales territory?
--
-- Logic:
-- Join Store_Sales to Products to connect each sale to a product.
-- Join Products to Inventory_Categories to identify the product category.
-- Join Store_Sales to Store_Locations to filter only Florida stores.
-- Group by year, month, and category so each row shows one category's
-- performance for one month.
-- Use COUNT to count transactions.
-- Use AVG to calculate the average transaction amount.
-- =========================================================
SELECT
    YEAR(ss.Transaction_Date) AS sales_year,
    MONTH(ss.Transaction_Date) AS sales_month,
    ic.Category AS product_category,
    COUNT(*) AS transaction_count,
    ROUND(AVG(ss.Sale_Amount), 2) AS average_transaction_amount
FROM Store_Sales AS ss
JOIN Products AS p
    ON p.ProdNum = ss.Prod_Num
JOIN Inventory_Categories AS ic
    ON ic.CategoryId = p.CategoryId
JOIN Store_Locations AS sl
    ON sl.StoreId = ss.Store_ID
WHERE sl.State = 'Florida'
GROUP BY
    YEAR(ss.Transaction_Date),
    MONTH(ss.Transaction_Date),
    ic.Category
ORDER BY
    sales_year,
    sales_month,
    product_category;

-- Answer:
-- This query shows monthly transaction counts and average transaction amounts by product category.
-- Technology & Accessories had the highest average transaction amount.
-- This category may be important for the final recommendation because it brings in larger sales amounts.

-- =========================================================
-- QUESTION 5
-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?
--
-- Logic:
-- Assigned territory is Florida in-store sales, so this query ranks stores.
-- Join Store_Locations to Store_Sales so each store can be matched to its sales.
-- Filter to Florida because this is the assigned territory.
-- Group by store so each row shows one store's total revenue.
-- Sort by total revenue from highest to lowest to create the ranking.
-- =========================================================

SELECT
    sl.StoreLocation AS store_location,
    sl.StoreId AS store_id,
    sl.State AS state,
    SUM(ss.Sale_Amount) AS total_revenue
FROM Store_Locations AS sl
JOIN Store_Sales AS ss
    ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Florida'
GROUP BY
    sl.StoreLocation,
    sl.StoreId,
    sl.State
ORDER BY
    total_revenue DESC;
    
-- Answer:
-- This query ranks Florida in-store locations by total sales performance.
-- The top 2 Florida stores were:
-- 1. Miami with $618,846.25
-- 2. Tallahassee with $541,670.66
--
-- The bottom 2 Florida stores were:
-- 1. Naples with $259,602.83
-- 2. Lakeland with $273,835.24
--
-- Miami was the highest-performing Florida store.
-- Naples was the lowest-performing Florida store.



-- =========================================================
-- QUESTION 6
-- What is your recommendation for where to focus sales attention in the next quarter?
--
-- Recommendation:
-- I recommend focusing sales attention next quarter on Miami and Tallahassee.
-- These were the top two Florida stores based on total revenue.
--
-- Why:
-- Miami had the highest revenue at $618,846.25.
-- Tallahassee had the second-highest revenue at $541,670.66.
-- Since these stores are already performing well, extra sales attention may
-- help increase revenue even more.
--
-- I also recommend reviewing Naples because it had the lowest revenue at
-- $259,602.83.
--
-- Why:
-- Naples may need extra support because it is bringing in less revenue than
-- the other Florida stores. The business could review inventory, promotions,
-- product mix, staffing, or customer traffic to look for improvement areas.
--
-- Final takeaway:
-- The business should grow what is already working in the top stores and
-- investigate how to help the lowest-performing store improve.
-- =========================================================