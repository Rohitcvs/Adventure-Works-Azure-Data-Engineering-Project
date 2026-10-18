-- Step 1: Run in the master database
-- Creates a dedicated SQL login for Power BI
CREATE LOGIN powerbi_reader WITH PASSWORD = '<strong password>';
GO

-- Step 2: Run in your serverless SQL database (the one containing the gold schema)
-- Maps the login to a database user
CREATE USER powerbi_reader FOR LOGIN powerbi_reader;
GO

-- Grants read-only access to all views and tables in the database
ALTER ROLE db_datareader ADD MEMBER powerbi_reader;
GO
