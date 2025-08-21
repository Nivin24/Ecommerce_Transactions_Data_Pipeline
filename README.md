# 🛒 Ecommerce Transactions Data Pipeline

A complete AWS-based data pipeline that processes e-commerce transaction data using AWS Glue, S3, Lambda, and Athena.

```
Raw Data (S3) → Crawler #1 → ETL Job (Lambda Triggered) → Crawler #2 → Athena Queries
    │                │              │                      │              │
    └────────────────┴──────────────┴──────────────────────┴──────────────┘
```

## 📂 Dataset Description
We start with a raw dataset containing e-commerce transaction records, which are later transformed into a structured format.

### Transformed Dataset Columns
| Column Name      | Description                    |
|------------------|-------------------------------|
| transaction_id   | Unique ID for each transaction|
| customer_name    | Name of the customer          |
| product_name     | Name of the purchased product |
| category         | Product category              |
| amount           | Price per unit                |
| transaction_date | Date of transaction           |
| payment_method   | Payment type (e.g., Credit Card, UPI) |
| quantity         | Number of units purchased     |
| total_price      | Total cost (amount × quantity)|
| partition_0      | Internal partition column     |
| year             | Year of transaction           |
| month            | Month of transaction          |

## ☁️ AWS Services Used
- **Amazon S3** → Stores raw and transformed datasets.
- **AWS Glue Crawler** → Automatically detects schema for raw and transformed data.
- **AWS Glue ETL Job** → Processes and transforms the dataset.
- **AWS Lambda** → Orchestrates ETL execution and crawler automation.
- **Amazon Athena** → Performs SQL-based queries on the transformed dataset.

## 🏗️ Project Architecture

The pipeline follows an event-driven architecture with automated schema management:

### Crawler Execution Strategy
- **Crawler #1** → Runs only once upon initial table creation or when schema changes occur in raw data
- **ETL Job** → Triggered automatically by S3 events via Lambda when new raw data arrives
- **Crawler #2** → Executes only after ETL job completion (triggered automatically by Lambda)

This sequence ensures transformed data schema is always registered in the Glue Data Catalog before Athena querying begins.

## 🚀 Project Workflow

### 1. Raw Data Ingestion
- The raw e-commerce dataset is uploaded to an Amazon S3 bucket.
- This dataset contains multiple unstructured files that need schema detection.
- S3 event notification triggers the automated pipeline.

### 2. Schema Detection & ETL Processing
- **Crawler #1** → Scans raw dataset and generates schema (runs once or on schema changes)
- **Lambda Function** → Receives S3 event notification and triggers ETL job
- **ETL Job** → Processes data using PySpark transformations

### 3. Post-ETL Schema Update
- **Crawler #2** → Automatically triggered by Lambda after ETL completion
- Updates transformed dataset schema in AWS Glue Data Catalog
- Ensures Athena has current schema before queries execute

### 4. Athena Querying
- The final transformed data is queried using Amazon Athena.
- SQL queries are saved separately for future reference.

## 🔗 Lambda Automation

Lambda orchestrates the entire pipeline, providing event-driven ETL execution and automated schema updates. The function monitors S3 events, manages ETL job execution, and ensures proper crawler sequencing.

```python
import boto3
import json

def lambda_handler(event, context):
    glue_client = boto3.client('glue')
    
    # Parse S3 event
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        # Trigger ETL job for new raw data
        if 'raw-data/' in key:
            response = glue_client.start_job_run(
                JobName='ecommerce-etl-job',
                Arguments={
                    '--source_bucket': bucket,
                    '--source_key': key
                }
            )
            
            # Wait for ETL completion then trigger Crawler #2
            job_run_id = response['JobRunId']
            
            # Monitor job and trigger post-ETL crawler
            glue_client.start_crawler(
                Name='transformed-data-crawler'
            )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Pipeline triggered successfully')
    }
```

## 🛠️ Glue ETL Job Details
A PySpark-based Glue ETL job performs:
- Data cleaning
- Column transformations
- Adding year and month partitions
- Calculating `total_price`

The transformed dataset is saved back to S3.

## 📑 Transformed Dataset Schema
```
transaction_id STRING
customer_name STRING
product_name STRING
category STRING
amount DOUBLE
transaction_date DATE
payment_method STRING
quantity INT
total_price DOUBLE
partition_0 STRING
year INT
month INT
```

## 📝 SQL Queries
All SQL queries used for analysis are saved in the repository:
- [`queries/`](./queries/) → Folder containing each query separately.
- [`all_queries.sql`](./queries/all_queries.sql) → A single file containing all queries combined.

## 📁 Folder Structure
```
ecommerce-transactions-pipeline/
├── queries/
│   ├── all_queries.sql
│   └── individual_queries/
├── etl_scripts/
│   └── glue_etl_job.py
├── lambda/
│   └── pipeline_orchestrator.py
└── README.md
```
