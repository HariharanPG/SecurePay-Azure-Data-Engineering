/*
    SecurePay table definitions — verification required.

    The repository does not include the original CREATE TABLE statements. The
    authoritative columns, data types, primary keys, constraints, defaults,
    nullability, and indexes cannot be confirmed from the available project
    files. Do not deploy guessed table definitions.

    Obtain/script the existing definitions from the project's Azure SQL
    Database or its original source, then place the verified CREATE TABLE
    statements for all five tables below. These placeholders are intentionally
    comments and are not executable DDL.
*/

-- TODO (verify against the authoritative project schema):
-- CREATE TABLE dbo.StagingTransactions (...);
-- CREATE TABLE dbo.SilverTransactions (...);
-- CREATE TABLE dbo.RejectedTransactions (...);
-- CREATE TABLE dbo.GoldTransactionSummary (...);
-- CREATE TABLE dbo.GoldPaymentTypeSummary (...);

/*
    Suggested schema inspection for an existing database. This reports column
    metadata but does not replace scripting and reviewing keys, constraints,
    defaults, indexes, or the original table definitions.
*/
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    c.column_id AS ColumnOrdinal,
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length AS MaxLengthBytes,
    c.precision AS NumericPrecision,
    c.scale AS NumericScale,
    c.is_nullable AS IsNullable,
    c.is_identity AS IsIdentity,
    dc.definition AS DefaultDefinition
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
JOIN sys.columns AS c
    ON c.object_id = t.object_id
LEFT JOIN sys.default_constraints AS dc
    ON dc.object_id = c.default_object_id
WHERE s.name = N'dbo'
  AND t.name IN
  (
      N'StagingTransactions',
      N'SilverTransactions',
      N'RejectedTransactions',
      N'GoldTransactionSummary',
      N'GoldPaymentTypeSummary'
  )
ORDER BY t.name, c.column_id;
GO
