-- Use master database
USE master
GO

-- Check if the database already exists or not, if yes, drop it for recreate
IF EXISTS (SELECT  1 FROM sys.databases WHERE name='sales_db_analysis_project')
BEGIN
	DROP DATABASE sales_db_analysis_project;
END

-- Create database sales_db_analysis_project for analysis project
CREATE DATABASE sales_db_analysis_project;
GO

-- Login to the new database
USE sales_db_analysis_project;
GO

-- Check the gold schema if exist or not, if yes, drop it

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='gold')
BEGIN 
	DROP SCHEMA gold;
END;
GO

-- Create new schema named gold
CREATE SCHEMA gold;
GO

-- Drop fact_sales table if exists
IF OBJECT_ID('gold.fact_sales','U') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales(
	order_key		INT,
	order_number	NVARCHAR(50),
	customer_key	INT,
	product_key		INT,
	order_date		DATE,
	ship_date		DATE,
	duration_date	DATE,
	sales			INT,
	quantity		INT,
	price			INT
);
GO
 
-- batch insert data to fact_sales from csv file
BULK INSERT gold.fact_sales
FROM 'D:\SQL Data Analyzing Project (Sales)\Datasets\fact_sales.csv'
WITH(
	FIRSTROW = 1,
	FIELDTERMINATOR=',',
	TABLOCK
);
GO
-- Drop dim_customers table if exists
IF OBJECT_ID('gold.dim_customers','U') IS NOT NULL
	DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers(
	customer_key		INT,
	customer_id			INT,
	customer_code		NVARCHAR(50),
	first_name			NVARCHAR(50),
	last_name			NVARCHAR(50),
	gender				NVARCHAR(50),
	martial_status		NVARCHAR(50),
	country				NVARCHAR(50),
	brith_day			DATE
);
GO

-- batch insert data to dim_customers from csv file
BULK INSERT gold.dim_customers
FROM 'D:\SQL Data Analyzing Project (Sales)\Datasets\dim_customers.csv'
WITH(
	FIRSTROW = 1,
	FIELDTERMINATOR=',',
	TABLOCK
);
GO
-- Drop dim_products table if exists
IF OBJECT_ID('gold.dim_products','U') IS NOT NULL
	DROP TABLE gold.dim_products;
GO

CREATE TABLE gold.dim_products(
	product_key		INT,
	product_id		INT,
	product_number	NVARCHAR(50),
	product_name	NVARCHAR(50),
	category_id		NVARCHAR(50),
	category_name   NVARCHAR(50),
	subcategory		NVARCHAR(50),
	product_line	NVARCHAR(50),
	product_cost	INT,
	maintenance		NVARCHAR(50),
	start_date		DATE
);
GO

-- batch insert data to dim_products from csv file
BULK INSERT gold.dim_products
FROM 'D:\SQL Data Analyzing Project (Sales)\Datasets\dim_products.csv'
WITH(
	FIRSTROW = 1,
	FIELDTERMINATOR=',',
	TABLOCK
);
GO
