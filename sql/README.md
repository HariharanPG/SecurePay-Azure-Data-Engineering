# SecurePay SQL Assets

This folder contains SQL validation, monitoring and execution queries for the SecurePay Azure SQL Database.

## Database objects

| Object | Purpose |
|---|---|
| `dbo.StagingTransactions` | Receives transaction records copied from Bronze JSON files by Azure Data Factory. |
| `dbo.SilverTransactions` | Stores validated transaction records. |
| `dbo.RejectedTransactions` | Stores records rejected by Silver-layer validation. |
| `dbo.GoldTransactionSummary` | Stores the overall transaction summary produced by the Gold procedure. |
| `dbo.GoldPaymentTypeSummary` | Stores the payment-type summary produced by the Gold procedure. |

## Stored procedures

- `dbo.usp_LoadSilver`: validates staging records, routes invalid records to the rejected table, deduplicates valid records using `ROW_NUMBER()`, and avoids inserting transaction IDs already present in Silver.
- `dbo.usp_LoadGold`: refreshes the Gold summary tables from Silver. The implemented procedure truncates and reloads the summary tables.

The exact deployed table DDL and full stored procedure definitions should be exported from Azure SQL and committed as separate scripts. This repository does not substitute guessed definitions for the actual database objects.

## ADF execution sequence

1. `Truncate_SQL_Staging`
2. `Get_Bronze_File_Metadata`
3. `Copy_Bronze_To_SQL`
4. `Load_Silver_Transactions`
5. `Load_Gold_Summaries`

ADF orchestrates the staging load and the two stored procedure calls. See `06_execute_procedures.sql` for controlled manual testing instructions.

## Files

- `04_data_validation_queries.sql`: validates layer counts, transaction IDs and required Silver fields.
- `05_monitoring_queries.sql`: provides operational summaries and recent transaction views.
- `06_execute_procedures.sql`: manually executes the existing Silver and Gold stored procedures.

## Implementation notes

- The source is simulated transaction data retrieved from a public REST API; it is not a real payment gateway.
- The current ADF pipeline truncates SQL staging and copies files matching a Bronze wildcard. Treat repeated unattended execution carefully until incremental file tracking and idempotent staging ingestion are implemented.
- The Silver procedure prevents duplicate transaction IDs in Silver, but the current rejected-record logic may add the same rejected record again on repeated executions.
- Gold summary tables are refreshed from Silver; they are not an immutable transaction ledger.

## Running the scripts

1. Open the `securepay-sqldb` database in Azure SQL Query Editor or SQL Server Management Studio.
2. Run read-only validation or monitoring queries as needed.
3. Run the procedure execution script only after confirming staging contains the intended batch.
4. Check Silver, Rejected and Gold results.

Never commit passwords, connection strings, access keys, SAS tokens or other secrets.