USE DataWareHouse;
GO

/* =========================================================
   GOLD LAYER
   Business-ready views for analytics & reporting
   ========================================================= */

------------------------------------------------------------
-- Customer Dimension
------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id)            AS Customer_Key,
    ci.cst_id                                         AS Customer_Id,
    ci.cst_key                                        AS Customer_Number,
    ci.cst_firstname                                  AS First_Name,
    ci.cst_lastname                                   AS Last_Name,
    la.cntry                                          AS Country,
    ci.cst_marital_status                             AS Marital_Status,
    CASE
        WHEN ci.cst_gndr <> 'NA' THEN ci.cst_gndr      -- CRM is the master for gender
        ELSE COALESCE(ca.gen, 'NA')
    END                                               AS Gender,
    ca.bdate                                          AS Birthdate,
    ci.cst_create_date                                AS Create_Date
FROM silver.crm_cust_info      AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101  AS la ON ci.cst_key = la.cid;
GO

------------------------------------------------------------
-- Product Dimension
------------------------------------------------------------
IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS Product_Key,
    pn.prd_id                                               AS Product_Id,
    pn.prd_key                                              AS Product_Number,
    pn.prd_nm                                               AS Product_Name,
    pn.cat_id                                               AS Category_Id,
    pc.cat                                                  AS Category,
    pc.subcat                                               AS Subcategory,
    pc.maintenance                                         AS Maintenance,
    pn.prd_cost                                             AS Cost,
    pn.prd_line                                             AS Product_Line,
    pn.prd_start_dt                                         AS Start_Date
FROM silver.crm_prd_info         AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;   -- Exclude historical products
GO

------------------------------------------------------------
-- Sales Fact
------------------------------------------------------------
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num   AS Order_Number,
    pr.Product_Key,
    cu.Customer_Key,
    sd.sls_order_dt  AS Order_Date,
    sd.sls_ship_dt   AS Shipping_Date,
    sd.sls_due_dt    AS Due_Date,
    sd.sls_sales     AS Sales_Amount,
    sd.sls_quantity  AS Quantity,
    sd.sls_price     AS Price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products   AS pr ON sd.sls_prd_key = pr.Product_Number
LEFT JOIN gold.dim_customers  AS cu ON sd.sls_cust_id = cu.Customer_Id;
GO
