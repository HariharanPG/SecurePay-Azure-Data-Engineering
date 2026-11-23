/*
    SecurePay operational monitoring queries.
    transaction_id and processed_timestamp are the column names referenced by
    the project's supplied validation query. Gold summaries are selected as
    whole rows because their exact column definitions are not present in the
    repository; verify the authoritative schema before building column-specific
    dashboards or alerts.
*/

-- Total Silver transactions
SELECT COUNT(*) AS TotalSilverTransactions
FROM dbo.SilverTransactions;

-- Total rejected transactions
SELECT COUNT(*) AS TotalRejectedTransactions
FROM dbo.RejectedTransactions;

-- Duplicate transaction IDs in Silver (only IDs occurring more than once)
SELECT
    transaction_id,
    COUNT(*) AS Occurrences
FROM dbo.SilverTransactions
WHERE transaction_id IS NOT NULL
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC, transaction_id;

-- Gold overall transaction summary
SELECT *
FROM dbo.GoldTransactionSummary;

-- Gold payment-type summary
SELECT *
FROM dbo.GoldPaymentTypeSummary;

-- Latest processed transactions
SELECT *
FROM dbo.SilverTransactions
ORDER BY processed_timestamp DESC;
