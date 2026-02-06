USE DataWareHouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startTime DATETIME = GETDATE();
    DECLARE @endTime DATETIME;
    DECLARE @tableStart DATETIME;
    DECLARE @tableEnd DATETIME;
    DECLARE @rowCount INT;

    BEGIN TRY
        -- HEADER
        PRINT '===========================================================';
        PRINT '               Loading Bronze Layer                        ';
        PRINT '===========================================================';

        -- CRM Tables Section
        PRINT '';
        PRINT '-------------------- Loading CRM Tables -------------------';
        PRINT '';

        -- 1. CRM CUSTOMER INFO
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.crm_cust_info;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- 2. CRM PRODUCT INFO
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.crm_prd_info;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- 3. CRM SALES DETAILS
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.crm_sales_details;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- ERP Tables Section
        PRINT '';
        PRINT '-------------------- Loading ERP Tables -------------------';
        PRINT '';

        -- 4. ERP LOC A101
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.erp_loc_a101;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- 5. ERP CUST AZ12
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.erp_cust_az12;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- 6. ERP PX CAT G1V2
        SET @tableStart = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'F:\Data Science Projects\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK, KEEPNULLS);
        SELECT @rowCount = COUNT(*) FROM bronze.erp_px_cat_g1v2;
        SET @tableEnd = GETDATE();
        PRINT '   -> Rows loaded: ' + CAST(@rowCount AS NVARCHAR(10)) 
              + ' | Time: ' + CAST(DATEDIFF(SECOND, @tableStart, @tableEnd) AS NVARCHAR(10)) + ' sec';

        -- TOTAL
        SET @endTime = GETDATE();
        PRINT '';
        PRINT '===========================================================';
        PRINT '               Bronze Layer Load Complete                  ';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
        PRINT 'End Time: ' + CONVERT(VARCHAR, @endTime, 120);
        PRINT '===========================================================';

    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while loading bronze layer:';
        PRINT ERROR_MESSAGE();
        PRINT 'Error line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        THROW;
    END CATCH
END;
GO

EXEC bronze.load_bronze;
