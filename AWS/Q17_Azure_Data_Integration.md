# Q17: Azure Data Integration

## Objective
To design an Azure solution for ingesting daily customer transaction CSV files and preparing them for analysis.

### (a) Service for Orchestrating Data Movement

Azure Data Factory (ADF) is suitable for orchestrating data movement and transformation. It supports pipelines, scheduling, monitoring, and integration with Azure storage services.

### (b) Copy CSV Files into Azure Data Lake Storage Gen2

1. Create an Azure Data Factory instance.
2. Create linked services for the source and destination.
3. Configure a source dataset for the incoming CSV file.
4. Configure a destination dataset for Azure Data Lake Storage Gen2.
5. Add a Copy Data activity to the pipeline.
6. Run the pipeline and verify that the file appears in the destination filesystem.

### (c) Organize Files by Ingestion Date

Use a date-based folder structure to simplify tracking and analysis. For example:

`/transactions/ingestion_date=2026-10-28/transactions.csv`

Generate the ingestion date dynamically from the pipeline execution date.

### (d) Handle Malformed Records and Missing Values

Validate the CSV schema, required columns, data types, and mandatory fields. Log or redirect malformed records to a separate location for investigation. Reject records missing essential identifiers or amounts. Apply default values only when permitted by business rules.

### (e) Monitor Pipeline Execution and Validate Completeness

Use Azure Data Factory Monitor to inspect pipeline runs, activity duration, and errors. Configure alerts for failures where required. Compare source and destination record counts, check required fields for null values, and validate business totals. Record rejected-record counts to identify incomplete processing.

## Conclusion

Azure Data Factory orchestrates ingestion, while Azure Data Lake Storage Gen2 stores date-organized transaction files. Schema validation, error handling, monitoring, and completeness checks help produce reliable data for analysis.
