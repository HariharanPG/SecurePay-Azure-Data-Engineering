# Power BI Transaction Monitoring

This folder documents the Power BI dashboard built for the SecurePay project.

## Data source

The report connects to the Gold summary tables in the Azure SQL Database `securepay-sqldb` using Import mode. The report was published to Power BI Service, connected through a Personal Cloud Connection, manually refreshed successfully and configured for daily scheduled refresh.

## Dashboard coverage

The dashboard presents transaction monitoring metrics and breakdowns, including:

- Total transactions
- Total transaction amount
- Completed, pending and failed transaction counts
- Successful transaction amount
- Transaction type analysis
- Transaction status distribution

## Report file

Add the Power BI Desktop file here as `SecurePay_Transaction_Monitoring_Dashboard.pbix` when ready. The PBIX is not currently stored in this repository.

## Notes

- Dashboard insights are based on simulated transaction records.
- The report is for monitoring and analytics demonstration; it does not perform payment processing or production fraud detection.
- Never commit database passwords, connection strings, tokens or other credentials.
