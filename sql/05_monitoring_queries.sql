/*
    SecurePay - SQL Monitoring Queries
    Read-only operational and business checks.
*/

-- 1. Transaction count and total amount by transaction status.
SELECT
    transaction_status,
    COUNT(*) AS TransactionCount,
    SUM(amount) AS TotalAmount
FROM dbo.SilverTransactions
GROUP BY transaction_status
ORDER BY TransactionCount DESC;

-- 2. Transaction count and total amount by transaction type.
SELECT
    transaction_type,
    COUNT(*) AS TransactionCount,
    SUM(amount) AS TotalAmount
FROM dbo.SilverTransactions
GROUP BY transaction_type
ORDER BY TransactionCount DESC;

-- 3. Transaction count and total amount by merchant.
SELECT
    merchant,
    COUNT(*) AS TransactionCount,
    SUM(amount) AS TotalAmount
FROM dbo.SilverTransactions
GROUP BY merchant
ORDER BY TotalAmount DESC;

-- 4. Daily transaction trend.
SELECT
    CAST(transaction_timestamp AS date) AS TransactionDate,
    COUNT(*) AS TransactionCount,
    SUM(amount) AS TotalAmount
FROM dbo.SilverTransactions
GROUP BY CAST(transaction_timestamp AS date)
ORDER BY TransactionDate;

-- 5. Latest processed Silver records.
-- processed_timestamp is present in the observed Silver table output.
SELECT TOP (100) *
FROM dbo.SilverTransactions
ORDER BY processed_timestamp DESC;

-- 6. Current counts in the operational layers.
SELECT 'Staging' AS Layer, COUNT(*) AS TotalRecords
FROM dbo.StagingTransactions
UNION ALL
SELECT 'Silver', COUNT(*)
FROM dbo.SilverTransactions
UNION ALL
SELECT 'Rejected', COUNT(*)
FROM dbo.RejectedTransactions;

-- 7. Inspect the Gold summary outputs.
SELECT * FROM dbo.GoldTransactionSummary;
SELECT * FROM dbo.GoldPaymentTypeSummary;
