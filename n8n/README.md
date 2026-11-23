# n8n API Ingestion Workflow

This folder documents the n8n workflow used to retrieve simulated payment transactions and land them in Azure Blob Storage.

## Runtime

- n8n Community Edition
- Self-hosted locally using Docker Desktop and Docker Compose
- Local editor URL: `http://localhost:5678`
- Container/service name: `n8n`
- Persistent Docker volume: `n8n_data`
- Time zone configured as `Asia/Kolkata`

## Workflow outline

The current workflow has three main nodes:

1. **Schedule Trigger** – starts the workflow at the configured interval (currently 60 seconds).
2. **HTTP Request** – calls the simulated transaction API:
   `https://randomapi.dev/api/transactions?count=10&currency=INR`
3. **Azure Storage** – creates a JSON blob in the Azure Blob Storage Bronze container.

The generated blob names use the `securepay_transactions_` prefix and a timestamp, with JSON file extension.

## Role in the architecture

n8n handles the scheduled external API call and Azure Blob file creation. Azure Event Grid detects the new file and triggers the Azure Data Factory pipeline. ADF and Azure SQL handle the downstream data engineering transformations.

## Important notes

- The API provides simulated data for learning and demonstration; no real payment data is used.
- The workflow schedule can create frequent files and Azure events. Monitor executions and cloud usage, and disable the workflow when it is not needed.
- Do not commit n8n credentials, API keys, Azure connection strings, access keys or exported credential data.

## Workflow export

Export the workflow JSON from n8n and add a sanitized copy here as `securepay_api_to_blob_workflow.json`. Check the export for credential references or sensitive values before committing. The JSON export is not included yet; this README documents the current node sequence.