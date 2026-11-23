# SecurePay – Azure Data Engineering & Payment Transaction Monitoring

An end-to-end data engineering project that automates the ingestion, processing and analysis of simulated payment transactions using Microsoft Azure, n8n and Power BI.

## Project Overview

SecurePay is designed to collect transaction data from an external REST API, store it in Azure Blob Storage, process it through a Medallion Architecture and visualize transaction insights using Power BI.

## Architecture

**Data Flow:**

RandomAPI → n8n → Azure Blob Storage (Bronze) → Azure Event Grid → Azure Data Factory → Azure SQL Database (Staging → Silver → Gold) → Power BI

## Technologies Used

- **API Integration:** RandomAPI, REST API
- **Workflow Automation:** n8n
- **Cloud Platform:** Microsoft Azure
- **Storage:** Azure Blob Storage (ADLS Gen2)
- **Event Processing:** Azure Event Grid
- **Data Orchestration:** Azure Data Factory
- **Database:** Azure SQL Database
- **Query Language:** SQL
- **Visualization:** Power BI

## Project Implementation

### 1. Data Ingestion
- Integrated an external REST API to retrieve simulated payment transactions.
- Automated API requests using n8n.
- Stored incoming JSON files in Azure Blob Storage.

### 2. Data Orchestration
- Configured Azure Event Grid to detect newly created transaction files.
- Triggered Azure Data Factory pipelines automatically.

### 3. Data Transformation
- Implemented Bronze, Silver and Gold layers.
- Loaded raw transaction data into SQL staging.
- Applied data validation and rejection handling.
- Used SQL stored procedures for Silver and Gold transformations.

### 4. Data Visualization
- Developed an interactive Power BI dashboard.
- Monitored transaction counts, amounts, payment statuses and transaction types.
- Configured scheduled dashboard refresh.

## Key Learnings

- REST API integration and automated data ingestion.
- Azure Data Factory pipeline orchestration.
- Event-driven data processing.
- Medallion Architecture implementation.
- SQL-based data validation and transformation.
- Power BI dashboard development.

## Repository Structure

- `architecture/` – Architecture diagrams and documentation.
- `adf/` – Azure Data Factory documentation.
- `sql/` – SQL scripts and stored procedures.
- `n8n/` – n8n workflow documentation and export.
- `power-bi/` – Power BI dashboard files.
- `screenshots/` – Project screenshots.


**Note:** This project uses simulated payment transaction data from a public REST API for learning and demonstration purposes. It is not connected to a real payment gateway or banking system.
