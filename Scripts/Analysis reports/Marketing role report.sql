/*2. Marketing Analyst
Objective: Understand customer behavior and improve targeting
Key Questions:
1	Who are our most valuable customers? 
2	What is the distribution of customers by gender and country? 
3	Do certain customer segments buy specific product categories? 
4	What is the customer purchase frequency? 
5	Are there patterns based on age (from birth_day)? 
6	Which products are popular among different demographics? 
*/


-- Connect to the sales_db_analsis_project
USE sales_db_analysis_project;
GO


CREATE or ALTER VIEW gold.view_marketing_analysis_report AS

WITH cte_main_customers_detials AS(
    SELECT 
        sales.order_number,
        sales.order_date,
        cust.customer_key,
        CONCAT(cust.first_name,' ',cust.last_name) AS customer_name,
        DATEDIFF(YEAR,cust.brith_day,GETDATE()) AS age,
        cust.gender,
        cust.country,
        prd.product_name,
        prd.category_name,
        sales.sales,
        sales.quantity
    FROM gold.fact_sales sales
    LEFT JOIN gold.dim_products prd
        ON sales.product_key=prd.product_key
    LEFT JOIN gold.dim_customers cust 
        ON sales.customer_key=cust.customer_key),
cte_aggregation_customers AS(
SELECT 
    order_number,
    order_date,
    customer_key,
    customer_name,
    age,
    gender,
    country,
    category_name,
    product_name,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity
FROM cte_main_customers_detials
GROUP BY
    order_number,
    order_date,
    customer_key,
    customer_name,
    age,
    gender,
    country,
    category_name,
    product_name)

SELECT
    order_number,
    order_date,
    customer_key,
    customer_name,
    gender,
    age,
    CASE 
        WHEN age IS NULL THEN 'N/A'
        WHEN age <20 THEN 'Under 20'
        WHEN age <30 THEN '20 - 29'
        WHEN age <40 THEN '30 - 39'
        WHEN age <50 THEN '40 - 49'
        ELSE '50 and above'
    END AS age_group,
    country,
    category_name,
    product_name,
    total_sales,
    total_quantity
FROM cte_aggregation_customers;
GO

--1	Who are our most valuable customers? 
SELECT 
    TOP 30
    customer_key,
    customer_name,
    country,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(total_sales) AS total_sales
FROM gold.view_marketing_analysis_report
GROUP BY customer_key,customer_name,country
ORDER BY 4 DESC

--2	What is the distribution of customers by gender and country? 
SELECT 
    country,
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.view_marketing_analysis_report
GROUP BY country,gender
ORDER BY 1,2,3 DESC

--3	Do certain customer segments buy specific product categories? 
SELECT 
    category_name,
    age_group,
    COUNT(customer_key) AS total_customers
FROM gold.view_marketing_analysis_report
GROUP BY category_name,age_group
ORDER BY 1,2,3 DESC

-- 4	What is the customer purchase frequency?
SELECT
    TOP 10 product_name,
    COUNT(product_name) AS total_product
FROM gold.view_marketing_analysis_report
GROUP BY product_name
ORDER BY 2 DESC
--5	Are there patterns based on age (from birth_day)? 
SELECT 
    age_group,
    SUM(total_sales) AS total_sales,
    SUM(total_quantity) AS total_quantity,
    COUNT(DISTINCT order_date) AS total_orders
FROM gold.view_marketing_analysis_report
GROUP BY age_group

--6	Which products are popular among different demographics? 

SELECT 
    country,
    age_group,
    gender,
    product_name,
    COUNT(total_quantity) AS total_quantity
FROM gold.view_marketing_analysis_report
GROUP BY 
    country,
    age_group,
    gender,
    product_name
HAVING COUNT(total_quantity) >=100 -- FILTER TO TARGETED THE DESIRED QUANTITY HAVE BEEN SOLED
ORDER BY 4,1,5 DESC

