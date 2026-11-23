# SecurePay SQL assets

This folder documents the SQL Server / Azure SQL Database portion of SecurePay. The intended flow is:

```text
Azure Blob Storage (Bronze) → Azure Data Factory → dbo.StagingTransactions
                                               → dbo.usp_LoadSilver
                                               → dbo.SilverTransactions / dbo.RejectedTransactions
                                               → dbo.usp_LoadGold
                                               → Gold summary tables → Power BI
```

## Database layers

- **Staging (`dbo.StagingTransactions`)** — raw transaction records loaded by Azure Data Factory. Treat this as the source for Silver processing.
- **Silver (`dbo.SilverTransactions`)** — validated and deduplicated transactions used for downstream analysis.
- **Rejected (`dbo.RejectedTransactions`)** — records that fail the required validation checks. The described rules reject missing transaction IDs; null or non-positive amounts; and missing currency, transaction type, transaction status, or transaction timestamp.
- **Gold (`dbo.GoldTransactionSummary`, `dbo.GoldPaymentTypeSummary`)** — aggregate tables refreshed from Silver for reporting and Power BI.

## Schema and implementation verification

The repository currently contains only a short SQL README; it does not contain original table definitions or stored procedure source. Consequently, this folder does **not** claim proposed column types, keys, constraints, defaults, rejection-table shape, Gold aggregate expressions, deduplication sort order, or other unverified details as the original SecurePay schema. The numbered SQL files mark the missing implementation details for verification instead of silently inventing them. In particular, the `CREATE TABLE` and procedure sections are documentation scaffolds, not deployable definitions, until reconciled with the actual database/project artifacts.

Before deploying DDL or procedures, obtain the authoritative definitions from the project database, Azure Data Factory mappings, and/or the original SQL source. In Azure Data Studio or SSMS, the table definitions can be scripted through **Object Explorer → table → Script Table as → CREATE To**. Verify the complete staging, Silver, rejected, and Gold schemas, including data types, nullability, keys, constraints, defaults, and indexes. Then replace the marked scaffolds with those verified definitions and test against a non-production database.

## Validation and transformation behavior

`dbo.usp_LoadSilver` is described as validating staged rows, inserting invalid rows into Rejected, deduplicating candidates with `ROW_NUMBER()`, and using `NOT EXISTS` to avoid inserting transaction IDs already present in Silver. Confirm the exact column names, reject-reason representation, duplicate precedence/order, and behavior on repeat runs from the original implementation before deployment.

`dbo.usp_LoadGold` is described as truncating and reloading both Gold summaries from Silver. Confirm the exact grouping keys, aggregate expressions, destination columns, and transaction/locking behavior before running it in production. Because `TRUNCATE` empties a destination before reload, execute and validate this procedure with care.

## Execution order

After replacing and verifying the scaffolds, the intended operational order is:

1. Create or verify the five tables using `01_create_tables.sql`.
2. Deploy `dbo.usp_LoadSilver` from `02_usp_LoadSilver.sql`.
3. Deploy `dbo.usp_LoadGold` from `03_usp_LoadGold.sql`.
4. Load raw records into staging with the configured ADF pipeline.
5. Run `EXEC dbo.usp_LoadSilver;` and inspect counts/rejections using `04_data_validation_queries.sql`.
6. Run `EXEC dbo.usp_LoadGold;` and review aggregates and recent processing with `05_monitoring_queries.sql`.

Silver must run before Gold so that Gold refreshes from the latest validated Silver data. The validation script includes procedure execution statements; run them deliberately, as they perform data changes.

## Running in Azure SQL Database

1. Connect to the intended Azure SQL Database using Azure Data Studio, SSMS, or an approved deployment pipeline. Configure authentication outside these source files; never commit credentials, connection strings, or keys.
2. Confirm the target database and review all schema/implementation verification notes in the numbered scripts.
3. Replace documentation scaffolds only with definitions verified against the actual project schema and logic. Do not execute incomplete scaffold sections.
4. Deploy table definitions, then procedures, in the order above. Use a development/test database first.
5. Run validation and monitoring queries and compare their results with expected project behavior. No execution results are asserted by these files.

All scripts target Microsoft SQL Server / Azure SQL T-SQL. `04_data_validation_queries.sql` and `05_monitoring_queries.sql` are operational queries; the table and stored-procedure scripts require the noted source-of-truth verification before deployment.
