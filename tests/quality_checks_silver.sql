USE DataWareHouse;
GO
-- CHECK FOR NULLS OR DUPLICATES IN PRIMARY KEY
-- EXPECTATION: NO RESULT
SELECT 
cst_id,
COUNT(*)
FROM [DataWareHouse].[silver].[crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
-- CHECK FOR UNWANTED SPACES
-- EXPECTATION: NO RESULTS
SELECT
cst_firstname
FROM [DataWareHouse].[silver].[crm_cust_info]
WHERE cst_firstname != TRIM(cst_firstname)
---
SELECT
cst_gndr
FROM [DataWareHouse].[silver].[crm_cust_info]
WHERE cst_gndr != TRIM(cst_gndr)
---
SELECT
cst_lastname
FROM [DataWareHouse].[silver].[crm_cust_info]
WHERE cst_lastname != TRIM(cst_lastname)
---
SELECT
cst_marital_status
FROM [DataWareHouse].[silver].[crm_cust_info]
WHERE cst_marital_status != TRIM(cst_marital_status)
---
SELECT
cst_key
FROM [DataWareHouse].[silver].[crm_cust_info]
WHERE cst_key != TRIM(cst_key)
-- DATA STANDARDIZATION & CONSISTENCY
SELECT
DISTINCT cst_gndr
FROM [DataWareHouse].[silver].[crm_cust_info]
---
SELECT
DISTINCT cst_marital_status
FROM [DataWareHouse].[silver].[crm_cust_info]
---------------------------------------------


---------------------------------------------
-- CHECK FOR UNWANTED SPACES
-- EXPECTATION: NO RESULTS
SELECT 
prd_id,
COUNT(*)
FROM [DataWareHouse].[silver].[crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
---
SELECT
prd_nm
FROM [DataWareHouse].[silver].[crm_prd_info]
WHERE prd_nm != TRIM(prd_nm)
---
-- DATA STANDARDIZATION & CONSISTENCY
SELECT
DISTINCT prd_line
FROM [DataWareHouse].[silver].[crm_prd_info]
---
-- CHECK FOR INVALID DATE ORDERS
SELECT *
FROM [DataWareHouse].[silver].[crm_prd_info]
WHERE prd_end_dt < prd_start_dt
----------------------------------------------



----------------------------------------------
-- CHECK FOR INVALID DATE ORDERS
SELECT
[sls_order_dt]
FROM [DataWareHouse].[silver].[crm_sales_details]
-- CHECK FOR INVALID DATE ORDERS
SELECT
*
FROM [DataWareHouse].[silver].[crm_sales_details]
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt < sls_due_dt
-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales ,
sls_quantity,
sls_price 
FROM [DataWareHouse].[silver].[crm_sales_details]
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Final Check 
SELECT * FROM silver.crm_sales_details
------------------------------------------------


------------------------------------------------
-- Identify Out-Of-Range Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()
-- DATA  STANDARDIZATION & CONSISTENCY
SELECT DISTINCT gen
FROM silver.erp_cust_az12
-- ALL FINAL DATA 
SELECT * FROM silver.erp_cust_az12
------------------------------------------------


------------------------------------------------
-- DOUBLE CHECKING ALL THE INFORMATION
SELECT *
FROM silver.erp_loc_a101
------------------------------------------------


------------------------------------------------
-- DOUBLE CHECKING ALL THE INFORMATION
SELECT *
FROM silver.erp_px_cat_g1v2
