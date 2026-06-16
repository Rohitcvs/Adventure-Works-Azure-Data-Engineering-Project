DROP VIEW IF EXISTS gold.calendar
GO

CREATE VIEW gold.calendar
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Calendar/',
    FORMAT = 'PARQUET'
) as QUER1
GO

CREATE VIEW gold.customers
AS
SELECT
    *
FROM
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Customers/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.products
AS
SELECT
    *
FROM
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Products/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.Product_Categories
AS
SELECT
    *
FROM
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Product_Categories/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.returns
AS
SELECT
    *
FROM
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Returns/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.sales
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Sales/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.subcat
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/Product_Subcategories/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO

CREATE VIEW gold.territories
AS
SELECT 
    * 
FROM 
    OPENROWSET
        (
            BULK 'https://awstoragelake4.dfs.core.windows.net/silver/AdventureWorks_Territories/',
            FORMAT = 'PARQUET'
        ) as QUER1
GO
