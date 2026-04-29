/* .  Finance Analyst

Objective: Track revenue, cost, and profitability

Key Questions:
1	What is total revenue vs total cost? 
2	What is profit margin by product/category? 
3	Which customers or products are least profitable? 
4	How does revenue trend over time? 
5	What is the contribution margin per product? 

*/

-- Connect to the sales_db_analsis_project
USE sales_db_analysis_project;
GO

-- CREATE VIEW TABLE CONTAIN THE REQUIRED INFORMATION FOR PROJECT MANAGER ANALYSIS
CREATE OR ALTER VIEW gold.view_finance_analyst_report AS
    SELECT 
        sales.order_date,
        cust.customer_key,
        CONCAT(cust.first_name,' ',cust.last_name) AS customer_name,
        prd.category_name,
        prd.product_key,
        prd.product_name,
        sales.sales,
        prd.product_cost * sales.quantity AS product_cost,
        sales.sales-(prd.product_cost*sales.quantity) AS profit
        

    FROM gold.fact_sales sales
    LEFT JOIN gold.dim_products prd
        ON sales.product_key=prd.product_key
    LEFT JOIN gold.dim_customers cust
        ON sales.customer_key=cust.customer_key;
GO


--1	What is total revenue vs total cost? 
SELECT 
    SUM(sales) AS total_revenue,
    SUM(product_cost) AS total_cost
FROM gold.view_finance_analyst_report;
GO

--2	What is profit margin by product/category? 
SELECT 
    category_name,
    product_name,
    total_revenue,
    CONCAT(ROUND((total_profit)/ CAST(NULLIF(total_revenue,0) AS float) *100,2),'%') AS profit_margin 
FROM (
    SELECT
        category_name,
        product_name,
        SUM(sales)           AS total_revenue,
        SUM(product_cost)    AS total_cost,
        SUM(profit)          AS total_profit
    FROM gold.view_finance_analyst_report
    GROUP BY
        category_name,
        product_name) T
ORDER BY 1,4 DESC;
GO

-- 3	Which customers or products are least profitable? 
WITH cte_agg_profit AS(
    SELECT
        customer_key,
        customer_name,
        SUM(sales) AS total_revenue,
        SUM(profit) AS total_profit,
        MIN(SUM(profit)) OVER () AS min_profit
    FROM gold.view_finance_analyst_report
    GROUP BY
        customer_key,
        customer_name)  

SELECT 
    customer_key,
    customer_name,
    total_revenue,
    total_profit
FROM cte_agg_profit
WHERE total_profit = min_profit;
GO

-- 4	How does revenue trend over time? 
SELECT
    year_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY year_month ASC) AS total_sales_over_time
FROM (
    SELECT
        DATETRUNC(MONTH,order_date) AS year_month,
        SUM(sales) AS total_sales
    FROM gold.view_finance_analyst_report
    GROUP BY
        DATETRUNC(MONTH,order_date)) T
