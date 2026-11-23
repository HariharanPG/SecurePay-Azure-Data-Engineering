/*
    SecurePay - Data Validation Queries
    Read-only checks for the staging and curated layers.
*/

-- 1. Staging record count, unique transaction IDs and missing IDs.
SELECT
    COUNT(*) AS TotalTransactions,
    COUNT(DISTINCT transaction_id) AS UniqueTransactions,
    COUNT(*) - COUNT(transaction_id) AS MissingTransactionIDs
FROM dbo.StagingTransactions;

-- 2. Record counts across the ingestion and transformation layers.
SELECT 'Staging' AS Layer, COUNT(*) AS TotalRecords
FROM dbo.StagingTransactions
UNION ALL
SELECT 'Silver', COUNT(*)
FROM dbo.SilverTransactions
UNION ALL
SELECT 'Rejected', COUNT(*)
FROM dbo.RejectedTransactions;

-- 3. Find duplicate transaction IDs in staging.
SELECT transaction_id, COUNT(*) AS Occurrences
FROM dbo.StagingTransactions
WHERE transaction_id IS NOT NULL
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;

-- 4. Find duplicate transaction IDs in Silver.
SELECT transaction_id, COUNT(*) AS Occurrences
FROM dbo.SilverTransactions
WHERE transaction_id IS NOT NULL
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;

-- 5. Check required Silver fields and positive amounts.
SELECT
    COUNT(*) AS TotalSilverRecords,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS MissingTransactionID,
    SUM(CASE WHEN amount IS NULL OR amount <= 0 THEN 1 ELSE 0 END) AS InvalidAmount,
    SUM(CASE WHEN currency IS NULL OR LTRIM(RTRIM(currency)) = '' THEN 1 ELSE 0 END) AS MissingCurrency,
    SUM(CASE WHEN transaction_type IS NULL OR LTRIM(RTRIM(transaction_type)) = '' THEN 1 ELSE 0 END) AS MissingTransactionType,
    SUM(CASE WHEN transaction_status IS NULL OR LTRIM(RTRIM(transaction_status)) = '' THEN 1 ELSE 0 END) AS MissingTransactionStatus,
    SUM(CASE WHEN transaction_timestamp IS NULL THEN 1 ELSE 0 END) AS MissingTransactionTimestamp
FROM dbo.SilverTransactions;

-- 6. Inspect rejected records. SELECT * is used because the deployed
-- rejection-diagnostic column names have not yet been exported to this repo.
SELECT *
FROM dbo.RejectedTransactions;
