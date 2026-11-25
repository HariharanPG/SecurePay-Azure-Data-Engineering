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

The working pipeline contains these five activities in sequence:

1. **Truncate_SQL_Staging** – clears the staging table before the current copy operation.
2. **Copy_Bronze_To_SQL** – copies JSON transaction records from Blob Storage into SQL staging.
3. **Load_Silver_Transactions** – executes the Silver validation and load procedure.
4. **Load_Gold_Summaries** – executes the Gold summary refresh procedure.

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

The source `meta` property is excluded from the SQL mapping.

## Event trigger

The storage event trigger listens for Blob Created events in the Bronze container, under the `raw` path, for JSON files. A successful event starts the pipeline when a matching file is created.

## Validation performed

A successful test run was followed by SQL checks showing 60 records in Staging, 60 in Silver and 0 in Rejected for that test batch.

## Operational considerations

The current pipeline is the original working baseline. It truncates staging and uses a wildcard source file pattern. Before treating it as a robust continuous ingestion design, add processed-file tracking, incremental staging loads, retry/recovery handling and protection against overlapping executions.

## Exporting the actual ADF artifacts

The deployed pipeline JSON, dataset JSON, linked-service definitions and trigger JSON should be exported from the ADF authoring interface and added here when available. Remove secrets and environment-specific credentials before committing. This documentation describes the verified design; it is not a substitute for those exported deployment artifacts.
