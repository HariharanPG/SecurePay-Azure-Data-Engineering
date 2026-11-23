# SecurePay – Azure Data Engineering & Payment Transaction Monitoring

An end-to-end data engineering project that automates the ingestion, processing and analysis of simulated payment transactions using Microsoft Azure, n8n and Power BI.

## Project Overview

SecurePay collects simulated transaction data from a public REST API, stores it in Azure Blob Storage, processes it through a Bronze-Silver-Gold data architecture and visualizes transaction insights using Power BI.

## Architecture

**Data flow:**

RandomAPI → n8n → Azure Blob Storage (Bronze) → Azure Event Grid → Azure Data Factory → Azure SQL Database (Staging → Silver / Rejected → Gold) → Power BI

See the [architecture documentation](architecture/README.md) for the Mermaid architecture diagram and component responsibilities.

## Technologies Used

- **API integration:** RandomAPI, REST API
- **Workflow automation:** n8n Community Edition
- **Cloud platform:** Microsoft Azure
- **Storage:** Azure Blob Storage (ADLS Gen2)
- **Event processing:** Azure Event Grid
- **Data orchestration:** Azure Data Factory
- **Database:** Azure SQL Database
- **Query language:** SQL
- **Visualization:** Power BI

## Project Implementation

### 1. Data ingestion
- Integrated a public REST API to retrieve simulated payment transactions.
- Automated scheduled API requests using n8n.
- Stored incoming JSON files in the Azure Blob Storage Bronze container.

### 2. Event-driven orchestration
- Configured Azure Event Grid to detect newly created transaction files.
- Used a Blob Created event trigger to start the Azure Data Factory pipeline.

### 3. Data transformation
- Loaded raw transaction data into SQL staging.
- Applied SQL validation and rejection handling in the Silver layer.
- Used stored procedures to create Gold transaction and payment-type summaries.

### 4. Data visualization
- Developed a Power BI transaction monitoring dashboard.
- Presented transaction counts, amounts, payment statuses and transaction types.
- Published the report to Power BI Service and configured scheduled refresh.

## Key Learnings

- REST API integration and workflow automation.
- Azure Blob Storage and event-driven processing.
- Azure Data Factory orchestration.
- Medallion Architecture and SQL transformations.
- Data validation, deduplication and rejected-record handling.
- Power BI reporting and scheduled refresh.

## Repository Structure

- [`architecture/`](architecture/README.md) – Architecture diagram and component documentation.
- [`adf/`](adf/README.md) – Azure Data Factory pipeline and trigger documentation.
- [`sql/`](sql/README.md) – SQL validation, monitoring and stored-procedure execution scripts.
- [`n8n/`](n8n/README.md) – API ingestion workflow documentation.
- [`power-bi/`](power-bi/README.md) – Dashboard documentation and location for the PBIX file.
- [`screenshots/`](screenshots/README.md) – Suggested screenshots and safe-upload guidance.

## Current Scope and Future Improvements

The current implementation is a working portfolio baseline. Incremental file tracking, safe replay handling, stronger operational monitoring and additional security hardening are planned improvements. The current ADF pipeline truncates staging before copying its matching Bronze files, so it should not be treated as a fully hardened continuous ingestion design yet.

## Disclaimer

This project uses simulated payment transaction data from a public REST API for learning and demonstration. It is not connected to a real payment gateway or banking system and does not perform production fraud detection or payment processing.
