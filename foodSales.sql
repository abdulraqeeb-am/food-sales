
use dea;
/* sales trend 
 This query analyzes sales trends by product category over time, which can help 
the business understand which product categories are performing well in each month of the year.
*/ 
SELECT DISTINCT
    Product_Category,
    EXTRACT(YEAR FROM Order_Date) AS year,
    EXTRACT(MONTH FROM Order_Date) AS month,
    CEILING(SUM(Revenue)) AS Total_revenue_Generated
FROM
    food_sales
GROUP BY year , month , Product_Category
ORDER BY year , month;


-- total revenue 
-- This is a key performance indicator for the business.
SELECT 
    CEILING(SUM(revenue)) AS Total_revenue_generated
FROM
    food_sales;

    
-- total order
SELECT 
    COUNT(Sub_Category) AS TotalOrder
FROM
    food_sales;

-- profit for CY
-- This query calculates the profit for the current year (2016). 
-- It's important for the business to track profitability over time.
-- The profit was not added because it gave a negative value for this year and PY
SELECT 
    SUM(Revenue) - SUM(Cost_of_Product) - SUM(OPEX) AS ProfitPercentageCY
FROM
    food_sales
WHERE
    EXTRACT(YEAR FROM Order_Date) = 2016;

-- customer demographics
-- This query analyzes customer demographics by product and sub-category, 
-- which can help the business understand their customer base and tailor marketing efforts.
SELECT DISTINCT
    age,
    gender,
    state,
    Product_Category,
    Sub_Category,
    cost_of_Product
FROM
    food_sales
ORDER BY Cost_of_Product DESC , age DESC , gender;

-- Geographical Trends for most active branch 
-- This query identifies the branches with the most orders in each state, which can help 
-- the business understand geographic trends and allocate resources accordingly.
WITH RankedBranches AS (
    SELECT 
        state,
       branch,
        COUNT(*) AS num_orders,
     DENSE_RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) desc) AS rnk
    FROM food_sales
    GROUP BY Branch, state
)
SELECT 
    Branch,
    num_orders AS totalOrderByBranch ,
   state
  
FROM RankedBranches;
 



-- Top Product
-- This query identifies the top products based on cost and reviews, 
-- which can help the business understand what products are most profitable and popular among customers.

with Prod as
 (select DISTINCT Sub_Category,Cost_of_Product,product_category, Review,count(*) as prod_count, 
DENSE_RANK() over (ORDER BY Cost_of_Product desc ) AS rnk
from food_sales
where review >=4
group by Sub_Category,Cost_of_Product,Revenue,product_category,review
)

select distinct sub_category, cost_of_product
from Prod
GROUP BY sub_category, cost_of_product,review 
order by cost_of_product desc;



-- Total Revenue Across Different Years
-- This query calculates the total revenue across different years, which can help 
-- the business understand how its performance has changed over time.
SELECT 
    EXTRACT(YEAR FROM Order_Date) AS year,
    CEIL(SUM(Revenue)) AS TotalRevenue
FROM
    food_sales
GROUP BY year
ORDER BY TotalRevenue DESC;




     

