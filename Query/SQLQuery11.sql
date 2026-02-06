USE DataWareHouse;
GO

/* =========================================================
   GOLD LAYER – DATA VALIDATION & QUALITY CHECKS
   ========================================================= */

------------------------------------------------------------
-- Customer Dimension
------------------------------------------------------------

-- Check for duplicate customers
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info      AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101  AS la ON ci.cst_key = la.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1;
GO

-- Gender data integration check (CRM vs ERP)
SELECT DISTINCT
    ci.cst_gndr        AS crm_gender,
    ca.gen             AS erp_gender,
    CASE
        WHEN ci.cst_gndr <> 'NA' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'NA')
    END                AS final_gender
FROM silver.crm_cust_info      AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101  AS la ON ci.cst_key = la.cid
ORDER BY 1, 2;
GO

-- Customer dimension data quality check
SELECT * FROM gold.dim_customers;
GO

SELECT DISTINCT Gender FROM gold.dim_customers;
GO

------------------------------------------------------------
-- Product Dimension
------------------------------------------------------------

-- Check for duplicate products
SELECT
    prd_key,
    COUNT(*) AS duplicate_count
FROM (
    SELECT
        pn.prd_id,
        pn.cat_id,
        pn.prd_key,
        pn.prd_nm,
        pn.prd_cost,
        pn.prd_line,
        pn.prd_start_dt,
        pc.cat,
        pc.subcat,
        pc.maintenance
    FROM silver.crm_prd_info         AS pn
    LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
    WHERE pn.prd_end_dt IS NULL
) t
GROUP BY prd_key
HAVING COUNT(*) > 1;
GO

-- Product dimension data quality check
SELECT * FROM gold.dim_products;
GO

------------------------------------------------------------
-- Sales Fact
------------------------------------------------------------

-- Sales fact data quality check
SELECT * FROM gold.fact_sales;
GO

------------------------------------------------------------
-- Foreign Key Integrity Check
------------------------------------------------------------

SELECT
    f.*
FROM gold.fact_sales      AS f
LEFT JOIN gold.dim_customers AS c ON c.Customer_Key = f.Customer_Key
LEFT JOIN gold.dim_products  AS p ON p.Product_Key  = f.Product_Key
WHERE c.Customer_Key IS NULL
   OR p.Product_Key IS NULL;
GO
