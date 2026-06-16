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

## Pipeline Walkthrough

**1. Ingestion → Bronze**
Azure Data Factory pipelines copy raw AdventureWorks data into the bronze layer of ADLS Gen2. The copy activity is **parameterized**, so new source tables can be onboarded by adding configuration rather than rebuilding pipelines — a pattern that scales to real ingestion workloads.

**2. Transformation → Silver**
Azure Databricks notebooks use PySpark to clean and standardize the raw data: casting columns to correct data types, handling nulls, and conforming naming conventions. The cleaned output is written back to the silver layer as Parquet — columnar and compressed for efficient downstream querying.

**3. Modeling & Serving → Gold**
Azure Synapse serverless SQL exposes the silver data as a set of **gold-layer views** built with `OPENROWSET` over the Parquet files. These views form the dimensional model — fact and dimension tables for sales, customers, products, calendar, territories, and returns — that reporting consumes. Serverless SQL means there's no provisioned warehouse to manage; queries are billed per use.

**4. Visualization → Power BI**
Power BI connects to the Synapse serverless endpoint and builds interactive dashboards on top of the gold views, turning the modeled data into business insight.

---

## What I Added / Changed

Beyond the core pipeline, I made deliberate engineering improvements:

- **Idempotent serving layer** — defined every gold view with `CREATE OR ALTER VIEW` instead of plain `CREATE VIEW`, so the deployment script can be re-run safely any number of times without failing on objects that already exist. This makes the gold layer reproducible and re-deployable, the way real pipeline code needs to be.
- **Least-privilege BI access** — rather than connecting Power BI through an interactive personal account, I provisioned a dedicated SQL login scoped to `db_datareader`. Reporting gets exactly the read access it needs and nothing more — a security-conscious access pattern and a repeatable connection method.

*Planned / further extensions:* a PySpark data-quality validation layer between silver and gold (row-count, null, uniqueness, and referential-integrity checks that fail the pipeline on bad data), Airflow-based orchestration as an alternative to ADF triggers, and incremental/watermark-based loading.

---

## Repository Structure

```
.
├── ADF-Script/           # Azure Data Factory pipeline definitions / exports
├── Datasets/             # Source AdventureWorks datasets
├── NoteBook/             # Databricks PySpark transformation notebooks (bronze → silver)
├── PowerBI/              # Power BI report / dashboard
├── Synapse SQL Scripts/  # Gold-layer schema and view definitions
└── README.md
```

---

## Skills Demonstrated

- **Cloud data engineering** on the Azure stack (ADF, ADLS Gen2, Databricks, Synapse)
- **Medallion / lakehouse architecture** and layered data refinement
- **PySpark** for distributed data cleaning and transformation
- **Dimensional data modeling** for analytics consumption
- **Serverless SQL** querying over data lake storage
- **Pipeline orchestration** and parameterized, reusable ingestion
- **Reproducible deployments** (idempotent SQL) and **least-privilege access control**
- **BI delivery** with Power BI

---

## How to Reproduce

1. Provision an Azure resource group with ADLS Gen2, Data Factory, Databricks, and a Synapse workspace.
2. Create `bronze`, `silver`, and `gold` containers in the storage account.
3. Import the ADF pipelines (`ADF-Script/`) and run ingestion to populate bronze.
4. Run the Databricks notebooks (`NoteBook/`) to transform bronze → silver.
5. Run the Synapse scripts (`Synapse SQL Scripts/`) to build the gold schema and views.
6. Connect Power BI to the Synapse serverless endpoint and load the gold views.

> **Security note:** No credentials, connection strings, or storage keys are committed to this repository. Use Azure Key Vault / managed identities for secrets in any real deployment.

---

## Dataset

Microsoft's AdventureWorks sample dataset — a retail dataset spanning sales, customers, products, territories, returns, and calendar dimensions.

