/*
    SecurePay validation and transformation checks.
    Review data-changing EXEC statements before running them.
*/

-- Check staging record count and unique transaction IDs
SELECT
    COUNT(*) AS TotalTransactions,
    COUNT(DISTINCT transaction_id) AS UniqueTransactions,
    COUNT(*) - COUNT(transaction_id) AS MissingTransactionIDs
FROM dbo.StagingTransactions;

-- Check record counts across all layers
SELECT 'Staging' AS Layer, COUNT(*) AS TotalRecords
FROM dbo.StagingTransactions
UNION ALL
SELECT 'Silver', COUNT(*)
FROM dbo.SilverTransactions
UNION ALL
SELECT 'Rejected', COUNT(*)
FROM dbo.RejectedTransactions;

-- Check Silver transactions
SELECT *
FROM dbo.SilverTransactions
ORDER BY processed_timestamp DESC;

-- Check rejected transactions
SELECT *
FROM dbo.RejectedTransactions;

-- Execute Silver transformation
EXEC dbo.usp_LoadSilver;

-- Execute Gold transformation
EXEC dbo.usp_LoadGold;
