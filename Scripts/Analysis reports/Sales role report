/*
 1. Sales Manager

Objective: Increase revenue and monitor sales performance

Key Questions:
	1	What are total sales by month, quarter, and year? 
	2	Which products generate the highest revenue? 
	3	Which customers contribute the most to sales? 
	4	What is the average order value? 
	5	Are there seasonal trends in sales? 
	6	Which regions (countries) perform best? 
*/

-- Connect to the sales_db_analsis_project
USE sales_db_analysis_project;
GO

CREATE OR ALTER VIEW gold.view_sales_manager_report AS

WITH cte_main_sales_data AS (
	SELECT
		sales.order_date,
		sales.sales,
		sales.order_number,
		prd.product_name,
		cust.customer_key,
		CONCAT(cust.first_name,' ',cust.last_name) as customer_name,
		cust.country
	FROM gold.fact_sales sales
	LEFT JOIN gold.dim_products prd
	ON sales.product_key=prd.product_key
	LEFT JOIN gold.dim_customers cust
	ON sales.customer_key=cust.customer_key
), cte_aggregation AS(
	SELECT 
		YEAR(order_date)				AS year,
		DATEPART(QUARTER,order_date)	AS quarter,
		MONTH(order_date)				AS month,
		country,
		product_name,
		customer_name,
		SUM(sales)						AS total_sales,
		COUNT(DISTINCT order_number)	AS total_orders,
		COUNT(DISTINCT customer_key)	AS toal_cutomers

	FROM cte_main_sales_data
	GROUP BY 
		YEAR(order_date),
		DATEPART(QUARTER,order_date),
		MONTH(order_date),
		product_name,
		customer_name,
		country)
SELECT 
		CONCAT(year,' - ','Q',quarter) AS year_quarter,
		year,
		quarter,
		month,
		customer_name,
		country,
		product_name,
		total_sales,
		total_orders,
		CASE 
			WHEN total_orders = 0 THEN 0
			ELSE total_sales/total_orders 
		END AS average_order_value
FROM cte_aggregation;
GO

--  1 What are total sales by month, quarter, and year? 
SELECT 
    year,
    'Q'+ CAST(quarter as CHAR) AS quarter,
    month,
    SUM(total_sales) AS total_sales
FROM gold.view_sales_manager_report
GROUP BY 
    year,
    'Q'+ CAST(quarter as CHAR),
    month
ORDER BY 1,3,4 DESC;
GO

--	2	Which products generate the highest revenue? 
SELECT 
    product_name,
    SUM(total_sales) AS total_sales
FROM gold.view_sales_manager_report
GROUP BY 
    product_name
ORDER BY
    2 DESC

--	3	Which customers contribute the most to sales? 
SELECT 
    customer_name,
    SUM(total_sales) AS total_sales
FROM gold.view_sales_manager_report
GROUP BY 
    customer_name
ORDER BY
    2 DESC

--	4	What is the average order value? 
SELECT 
    ROUND(SUM(total_sales)/NULLIF(CAST(SUM(total_orders) AS FLOAT),0) ,2) AS average_order_value
FROM gold.view_sales_manager_report

--	5	Are there seasonal trends in sales? 
SELECT 
    year,
    'Q'+ CAST(quarter as CHAR) AS quarter,
    SUM(total_sales) AS total_sales
FROM gold.view_sales_manager_report
GROUP BY 
    year,
    'Q'+ CAST(quarter as CHAR)
ORDER BY 1,3 DESC;

--	6	Which regions (countries) perform best? 

SELECT 
    country,
    SUM(total_sales) AS total_sales
FROM gold.view_sales_manager_report
GROUP BY country
ORDER BY 2 DESC
