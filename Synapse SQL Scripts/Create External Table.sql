-- Create a master key for encryption, using a password for security.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'give your password';
-- Create a database-scoped credential with a managed identity for authentication.
CREATE DATABASE SCOPED CREDENTIAL cred_rohit
WITH 
    IDENTITY = 'Managed Identity';

-- Create an external data source named 'source_silver', which points to a specific location in Azure Data Lake Storage (Silver tier).
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION = 'https://awstoragelake4.dfs.core.windows.net/silver', 
    CREDENTIAL = cred_rohit,
);
-- Create another external data source named 'source_gold', pointing to the 'gold' directory in Azure Data Lake Storage.
CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION = 'https://awstoragelake4.dfs.core.windows.net/gold', 
    CREDENTIAL = cred_rohit, 
);
-- Create an external file format for reading Parquet files with Snappy compression.
CREATE EXTERNAL FILE FORMAT format_parquet 
WITH (
    FORMAT_TYPE = PARQUET, 
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec' 
);
-- Create an external table 'extsales' in the 'gold' schema, referencing the Parquet files in the 'gold' data source.
-- The table will be populated with the data from 'gold.sales'.
CREATE EXTERNAL TABLE gold.extsales
WITH (
    LOCATION = 'extsales', 
    DATA_SOURCE = source_gold, 
    FILE_FORMAT = format_parquet 
)
AS
SELECT * FROM gold.sales;











