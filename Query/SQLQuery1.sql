-- 1. Switch to master and drop any existing version
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
    ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWareHouse;
END;
GO

-- 2. Create new DataWarehouse database
CREATE DATABASE DataWareHouse;
GO

-- 3. Switch to the new database
USE DataWareHouse;
GO

-- 4. Create schemas (bronze, silver, gold)
CREATE SCHEMA bronze AUTHORIZATION dbo;
GO
CREATE SCHEMA silver AUTHORIZATION dbo;
GO
CREATE SCHEMA gold AUTHORIZATION dbo;
GO

-- 5. Confirm schemas exist
SELECT name AS SchemaName FROM sys.schemas;
GO

