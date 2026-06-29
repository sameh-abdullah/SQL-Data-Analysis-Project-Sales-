/* 3. Product Manager
Objective: Optimize product portfolio and profitability
Key Questions:
1	Which product categories and subcategories perform best? 
2	What is the profitability per product? (sales vs product_cost) 
3	Which products have low sales and may need to be discontinued? 
4	How do different product lines perform over time? 
5	Are new products (based on start_date) performing well? 

*/

-- Connect to the sales_db_analsis_project
USE sales_db_analysis_project;
GO

-- CREATE VIEW TABLE CONTAIN THE REQUIRED INFORMATION FOR PROJECT MANAGER ANALYSIS
CREATE OR ALTER VIEW gold.view_product_manager_report AS 
    SELECT 
        sales.order_number,
        sales.order_date,
        prd.product_key,
        prd.product_name,
        prd.category_id,
        prd.category_name,
        prd.subcategory,
        prd.product_line,
        prd.start_date,
        sales.sales,
        sales.quantity,
        sales.price,
        prd.product_cost,
        sales.sales-(sales.quantity*prd.product_cost) AS product_profit
    FROM gold.fact_sales sales
    LEFT JOIN gold.dim_products prd 
        ON sales.product_key = prd.product_key;
    
GO



--- 1	Which product categories and subcategories perform best? 
SELECT 
    category_name,
    subcategory,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    SUM(product_profit) AS total_profit
FROM gold.view_product_manager_report
GROUP BY category_name,subcategory
ORDER BY 1,3 DESC;
GO

--2	What is the profitability per product? (sales vs product_cost) 
SELECT
    product_key,
    product_name,
    SUM(sales) AS total_sales,
    SUM(product_cost*quantity) AS total_cost,
    SUM(product_profit) AS total_profit
FROM GOLD.view_product_manager_report
GROUP BY product_key,product_name
ORDER BY 5 DESC;
GO
-- 3	Which products have low sales and may need to be discontinued?
SELECT
    product_name,
    product_cost,
    start_date,
    SUM(quantity) AS total_quantity,
    SUM(sales) AS total_sales,
    SUM(product_profit) AS total_profit
FROM gold.view_product_manager_report
GROUP BY product_name,product_cost,start_date
ORDER BY 3,4, 6 ASC;
GO

--4	How do different product lines perform over time? 
SELECT
    year_month,
    product_line,
    total_sales,
    total_sales - LAG(total_sales) OVER (PARTITION BY product_line ORDER BY year_month) AS sales_profermance
FROM (
    SELECT
        DATETRUNC(MONTH,order_date) AS year_month,
        product_line,
        SUM(sales) AS total_sales
    FROM gold.view_product_manager_report
    GROUP BY
        DATETRUNC(MONTH,order_date),
        product_line) T;
GO

--5	Are new products (based on start_date) performing well? 
SELECT
    product_key,
    product_name,
    start_date,
    DATEDIFF(MONTH,start_date,GETDATE()) AS total_months_since_begin,
    SUM(sales) AS total_sales,
    AVG(sales) AS avg_sales,
    SUM(product_profit) AS total_profit
    
FROM gold.view_product_manager_report
GROUP BY product_key,product_name,DATEDIFF(MONTH,start_date,GETDATE()),start_date
ORDER BY 4 ASC, 5 DESC;
GO

