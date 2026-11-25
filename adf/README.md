# Azure Data Factory

This folder documents the Azure Data Factory orchestration used in SecurePay.

## Azure resources and connections

- Storage linked service: `LS_AzureBlob_SecurePay`
- Azure SQL linked service: `LS_AzureSQL_SecurePay`
- Bronze JSON dataset: `DS_Bronze_SecurePay_JSON`
- SQL staging dataset: `DS_SQL_StagingTransactions`
- Pipeline: `PL_SecurePay_Bronze_To_Silver`
- Storage event trigger: `TR_SecurePay_Bronze_NewFile`

## Pipeline activities

The current pipeline uses four activities in sequence:

1. **Truncate_SQL_Staging** – clears the staging table before the current copy operation.
2. **Copy_Bronze_To_SQL** – copies transaction records from the Bronze JSON files in Blob Storage into SQL staging.
3. **Load_Silver_Transactions** – executes the Silver validation and load procedure.
4. **Load_Gold_Summaries** – executes the Gold summary refresh procedure.

The pipeline does not use a metadata lookup or metadata-driven file-selection activity. Its current source configuration uses the configured Bronze folder and file pattern.

## Source JSON mapping

The source JSON contains a `data` array. The pipeline maps these fields:

| JSON field | SQL column |
|---|---|
| `id` | `transaction_id` |
| `amount` | `amount` |
| `currency` | `currency` |
| `type` | `transaction_type` |
| `status` | `transaction_status` |
| `description` | `description` |
| `merchant` | `merchant` |
| `timestamp` | `transaction_timestamp` |
| `reference` | `reference` |

## Event trigger

The storage event trigger listens for Blob Created events in the Bronze container, under the `raw` path, for JSON files. A matching new file starts the Azure Data Factory pipeline.

## Validation performed

A successful test run was followed by SQL checks showing 60 records in Staging, 60 in Silver and 0 in Rejected for that test batch.

## Operational considerations

The current pipeline is a working portfolio baseline. It truncates staging before copying files that match the configured Bronze source pattern. Incremental file tracking, safe replay handling, retry/recovery handling and protection against overlapping executions are potential future improvements.
