## Adventure-Works-Azure-Data-Engineering-Project
A production-style, end-to-end batch data pipeline on Microsoft Azure that takes raw retail data from source to dashboard. The project ingests the AdventureWorks dataset, refines it through a medallion (bronze → silver → gold) lakehouse architecture, and delivers clean, analytics-ready data to Power BI — demonstrating the full data engineering lifecycle: ingestion, transformation, modeling, serving, and visualization.

Built with the modern Azure data stack: Azure Data Factory, ADLS Gen2, Azure Databricks (PySpark), Azure Synapse Analytics, and Power BI.

## Business Context
AdventureWorks is a fictional retail company with sales, customer, product, and territory data spread across multiple source tables. The business question this pipeline supports: how are sales performing across products, regions, and customer segments over time?
Raw operational data isn't fit for that kind of analysis directly — it's messy, unmodeled, and spread out. This pipeline turns it into a clean dimensional model that a business analyst can slice in Power BI without touching the underlying complexity.

## Architecture

```
Source data
      │
      ▼
[ Azure Data Factory ]   ── ingestion (parameterized copy pipelines)
      │
      ▼
[ ADLS Gen2 ]  bronze  ── raw landing zone (data stored as-is)
      │
      ▼
[ Azure Databricks / PySpark ]
      │   clean · cast types · handle nulls · conform schema
      ▼
[ ADLS Gen2 ]  silver  ── cleaned, standardized Parquet
      │
      ▼
[ Synapse Serverless SQL ]  gold  ── curated analytics views (dimensional model)
      │
      ▼
[ Power BI ]  ── interactive dashboards & reporting
```

## Tech Stack

| Layer          | Technology                               | Role                                            |
|----------------|------------------------------------------|-------------------------------------------------|
| Ingestion      | Azure Data Factory                       | Orchestrated, parameterized data movement       |
| Storage        | Azure Data Lake Storage Gen2             | Scalable lakehouse storage across all layers    |
| Transformation | Azure Databricks, PySpark                | Distributed cleaning and transformation         |
| Serving        | Azure Synapse Analytics (Serverless SQL) | Pay-per-query analytics layer over Parquet      |
| Visualization  | Power BI                                 | Business-facing dashboards                       |
| File format    | Parquet                                  | Columnar, compressed storage for analytics      |


