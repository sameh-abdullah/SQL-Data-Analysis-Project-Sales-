/* . Operations / Supply Chain Manager

Objective: Improve delivery efficiency and reduce delays

Key Questions:
1	What is the average shipping time? (ship_date - order_date) 
2	Which orders have the longest delivery durations? 
3	Are there delays by region? 
4	How does delivery performance impact sales? 
5	Are certain periods experiencing slower shipping? 

*/

-- Connect to the sales_db_analsis_project
USE sales_db_analysis_project;
GO

-- CREATE VIEW TABLE CONTAIN THE REQUIRED INFORMATION FOR PROJECT MANAGER ANALYSIS
CREATE OR ALTER VIEW gold.view_supply_chain_report AS
    SELECT 
        sales.order_number,
        cust.country,
        sales.order_date,
        sales.ship_date,
        sales.duration_date,
        sales.sales,
        DATEDIFF(DAY,order_date,ship_date) AS shipping_time_by_days,
        DATEDIFF(DAY,order_date,duration_date) AS delivery_duration_by_days
    FROM gold.fact_sales sales
    LEFT JOIN gold.dim_products prd
        ON sales.product_key=prd.product_key
    LEFT JOIN gold.dim_customers cust
        ON sales.customer_key=cust.customer_key;
GO


--1	What is the average shipping time? (ship_date - order_date) 
SELECT 
    AVG(shipping_time_by_days) AS avg_shipping_days
FROM gold.view_supply_chain_report
ORDER BY 1 DESC;
GO

-- 2	Which orders have the longest delivery durations? 
SELECT 
    --TOP 10 // USE TOP + NUMBER IF WE WANT FILTER THE SPECIFIC NUMBER OF ORDERS WHO HAVE THE LONGEST DELIVERY DURATIONS
    *
FROM (
    SELECT
        DISTINCT order_number,
        order_date,
        duration_date,
        delivery_duration_by_days
    FROM gold.view_supply_chain_report) T
ORDER BY 3 DESC
GO

--3	Are there delays by region? 
SELECT
    country,
    COUNT(DISTINCT order_number) AS total_orders,
    AVG(delivery_duration_by_days) AS av_delivery_days
FROM gold.view_supply_chain_report
WHERE country<>'n/a' -- where the country not mentioned
GROUP BY country
ORDER BY 3 DESC;
GO

-- 4	How does delivery performance impact sales? 
SELECT 
    delivery_duration_by_days,
     SUM(sales) AS total_sales
FROM gold.view_supply_chain_report
GROUP BY delivery_duration_by_days
ORDER BY 1 DESC;
GO

-- 5	Are certain periods experiencing slower shipping? 
SELECT
    DATETRUNC(MONTH,ship_date) AS shipping_date,
    AVG(shipping_time_by_days) AS avg_shipping_days
FROM gold.view_supply_chain_report
GROUP BY 
    DATETRUNC(MONTH,ship_date)
ORDER BY 1
GO
