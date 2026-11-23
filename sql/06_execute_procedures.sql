/*
    SecurePay - Stored Procedure Execution

    Run only after the intended batch has been copied into
    dbo.StagingTransactions and you are ready to process it.

    The ADF pipeline already orchestrates these procedure calls.
    This file is for controlled manual testing in Azure SQL.
*/

-- Step 1: Check that staging contains the expected batch.
SELECT COUNT(*) AS StagingRecordCount
FROM dbo.StagingTransactions;

SELECT TOP (20) *
FROM dbo.StagingTransactions;

-- Step 2: Validate staging records, load valid records into Silver,
-- and route invalid records to RejectedTransactions.
EXEC dbo.usp_LoadSilver;

-- Step 3: Refresh the Gold summary tables from Silver.
EXEC dbo.usp_LoadGold;

-- Step 4: Verify the results.
SELECT 'Silver' AS Layer, COUNT(*) AS TotalRecords
FROM dbo.SilverTransactions
UNION ALL
SELECT 'Rejected', COUNT(*)
FROM dbo.RejectedTransactions;

SELECT * FROM dbo.GoldTransactionSummary;
SELECT * FROM dbo.GoldPaymentTypeSummary;
