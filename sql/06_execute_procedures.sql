/*
    SecurePay - Stored Procedure Execution

    Run this script only after the intended batch has been copied into
    dbo.StagingTransactions and you are ready to process that batch.

    The ADF pipeline already orchestrates these procedure calls.
    This file is for controlled manual testing in Azure SQL.
*/

-- Step 1: Validate the staging batch before processing.
SELECT COUNT_BIG(*) AS staging_record_count
FROM dbo.StagingTransactions;

SELECT TOP (20) *
FROM dbo.StagingTransactions;

-- Step 2: Load validated records into Silver and invalid records
-- into RejectedTransactions.
EXEC dbo.usp_LoadSilver;

-- Step 3: Refresh the Gold summary tables from Silver.
EXEC dbo.usp_LoadGold;

-- Step 4: Verify the results.
SELECT 'Silver' AS layer_name, COUNT_BIG(*) AS total_records
FROM dbo.SilverTransactions
UNION ALL
SELECT 'Rejected', COUNT_BIG(*)
FROM dbo.RejectedTransactions;

SELECT *
FROM dbo.GoldTransactionSummary;

SELECT *
FROM dbo.GoldPaymentTypeSummary;
