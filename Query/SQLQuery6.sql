USE DataWareHouse;
GO
-- CHECK FOR NULLS OR DUPLICATES IN PRIMARY KEY
-- EXPECTATION: NO RESULT
SELECT 
cst_id,
COUNT(*)
FROM [DataWareHouse].[bronze].[crm_cust_info]
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
-- CHECK FOR UNWANTED SPACES
-- EXPECTATION: NO RESULTS
SELECT
cst_firstname
FROM [DataWareHouse].[bronze].[crm_cust_info]
WHERE cst_firstname != TRIM(cst_firstname)
---
SELECT
cst_gndr
FROM [DataWareHouse].[bronze].[crm_cust_info]
WHERE cst_gndr != TRIM(cst_gndr)
---
SELECT
cst_lastname
FROM [DataWareHouse].[bronze].[crm_cust_info]
WHERE cst_lastname != TRIM(cst_lastname)
---
SELECT
cst_marital_status
FROM [DataWareHouse].[bronze].[crm_cust_info]
WHERE cst_marital_status != TRIM(cst_marital_status)
---
SELECT
cst_key
FROM [DataWareHouse].[bronze].[crm_cust_info]
WHERE cst_key != TRIM(cst_key)
-- DATA STANDARDIZATION & CONSISTENCY
SELECT
DISTINCT cst_gndr
FROM [DataWareHouse].[bronze].[crm_cust_info]
---
SELECT
DISTINCT cst_marital_status
FROM [DataWareHouse].[bronze].[crm_cust_info]
---------------------------------
-- prd_info
-- CHECK FOR NULLS OR DUPLICATES IN PRIMARY KEY
-- EXPECTATION: NO RESULT
SELECT [prd_id]
      ,[prd_key]
      ,REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') as cat_id
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWareHouse].[bronze].[crm_prd_info]
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') NOT IN (SELECT DISTINCT id FROM  bronze.erp_px_cat_g1v2)

SELECT DISTINCT id FROM DataWareHouse.bronze.erp_px_cat_g1v2
-----------------------
SELECT [prd_id]
      ,[prd_key]
      ,REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') as cat_id
      ,SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
  FROM [DataWareHouse].[bronze].[crm_prd_info]
WHERE SUBSTRING(prd_key,7,LEN(prd_key)) NOT IN (SELECT sls_prd_key FROM DataWareHouse.bronze.crm_sales_details)

SELECT sls_prd_key FROM DataWareHouse.bronze.crm_sales_details
-- CHECK FOR UNWANTED SPACES
-- EXPECTATION: NO RESULTS
SELECT 
prd_id,
COUNT(*)
FROM [DataWareHouse].[bronze].[crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL
---
SELECT
prd_nm
FROM [DataWareHouse].[bronze].[crm_prd_info]
WHERE prd_nm != TRIM(prd_nm)
---
-- DATA STANDARDIZATION & CONSISTENCY
SELECT
DISTINCT prd_line
FROM [DataWareHouse].[bronze].[crm_prd_info]
---
-- CHECK FOR INVALID DATE ORDERS
SELECT *
FROM [DataWareHouse].[bronze].[crm_prd_info]
WHERE prd_end_dt < prd_start_dt
----------------------------------------------



----------------------------------------------
-- CHECK FOR INVALID DATE ORDERS
SELECT
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM [DataWareHouse].[bronze].[crm_sales_details]
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101 OR sls_order_dt < 19000101
-- CHECK FOR INVALID DATE ORDERS
SELECT
*
FROM [DataWareHouse].[bronze].[crm_sales_details]
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt < sls_due_dt
-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.

SELECT DISTINCT
sls_sales AS old_sls_price,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
     ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=0
     THEN sls_sales / NULLIF(sls_quantity,0)
     ELSE sls_price
END AS sls_price
FROM [DataWareHouse].[bronze].[crm_sales_details]
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
----------------------------------------------



----------------------------------------------
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
    ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
    ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
     ELSE 'n/a'
END AS gen
FROM DataWareHouse.bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
    ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM DataWareHouse.silver.crm_cust_info)
-- Identify Out-Of-Range Dates
SELECT DISTINCT
bdate
FROM DataWareHouse.bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()
-- DATA  STANDARDIZATION & CONSISTENCY
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
     ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12
----------------------------------------------



----------------------------------------------
SELECT 
REPLACE(cid,'-','') AS cid,
CASE WHEN TRIM(cntry) = 'DE'THEN 'Germany'
     WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101 WHERE REPLACE(cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info)
-- DATA  STANDARDIZATION & CONSISTENCY
SELECT DISTINCT
cntry AS old_cntry,
CASE WHEN TRIM(cntry) = 'DE'THEN 'Germany'
     WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM BRONZE.erp_loc_a101
ORDER BY cntry
----------------------------------------------



----------------------------------------------
SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2
-- CHECK FOR UNWANTED SPACES
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)
-- DATA  STANDARDIZATION & CONSISTENCY
SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2
---
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2
---
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2