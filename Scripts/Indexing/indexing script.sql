-- Use master database
USE master
GO

-- Connect to the sales_db_analysis_project
USE sales_db_analysis_project;
GO

-- create clustered index on gold.fact_sales on column order_date
CREATE CLUSTERED COLUMNSTORE INDEX idx_gold_factSales_orderNumber ON gold.fact_sales;
GO

-- create clustered columnstore index on gold.dim_customers
CREATE CLUSTERED COLUMNSTORE INDEX idx_gold_dimCustomers_customerKey ON gold.dim_customers;
GO

-- create clustered columnstore index on gold.dim_prodcuts
CREATE CLUSTERED COLUMNSTORE INDEX idx_gold_dimProducts_productKey ON gold.dim_products;
GO
