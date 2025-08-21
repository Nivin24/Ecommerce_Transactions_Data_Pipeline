# 🛍️ E-commerce Transactions Data Pipeline using AWS Glue, Lambda & Athena

---

## 📌 Project Overview

This project demonstrates the creation of an **event-driven ETL pipeline** for processing **e-commerce transaction data** using **AWS Lambda, Glue, Athena, and S3**.

The pipeline automatically triggers data transformation when a new file is uploaded to **Amazon S3**, processes the data using **Glue ETL**, updates schema using **Glue Crawlers**, and makes the transformed data queryable using **Amazon Athena**.

---

## 🗂️ Table of Contents

- [Project Architecture](#-project-architecture)
- [Dataset Description](#-dataset-description)
- [AWS Services Used](#-aws-services-used)
- [Project Workflow](#-project-workflow)
  - [1. Raw Data Ingestion](#1-raw-data-ingestion)
  - [2. Lambda Trigger](#2-lambda-trigger)
  - [3. Glue Crawlers](#3-glue-crawlers)
  - [4. Glue ETL Job](#4-glue-etl-job)
  - [5. Athena Querying](#5-athena-querying)
- [Transformed Dataset Schema](#-transformed-dataset-schema)
- [Lambda Function Details](#-lambda-function-details)
- [SQL Queries](#-sql-queries)
- [Folder Structure](#-folder-structure)
- [How to Run](#-how-to-run)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

---

## 🏗️ Project Architecture

```plaintext
          ┌────────────────────┐
          │   Raw Dataset      │
          │  (S3 Bucket)       │
          └─────────┬──────────┘
                    │  (PUT/POST Event)
                    ▼
          ┌────────────────────┐
          │  Lambda Function   │
          │ trigger-glue-etl   │
          └─────────┬──────────┘
                    │
         Starts Glue ETL Job
                    ▼
        ┌──────────────────────┐
        │   Glue ETL Job       │
        │  (pandas_etl_job)    │
        └─────────┬────────────┘
                  │
        Writes Transformed Data
                  ▼
        ┌──────────────────────┐
        │ Transformed Dataset  │
        │     (S3 Bucket)      │
        └─────────┬────────────┘
                  │
    Starts Crawler for Schema Update
                  ▼
        ┌──────────────────────┐
        │ Glue Crawler #2      │
        │ curated_to_analysis  │
        └─────────┬────────────┘
                  │
                  ▼
        ┌──────────────────────┐
        │ Amazon Athena        │
        │ Query Transformed    │
        │ Data for Analysis    │
        └──────────────────────┘
```

---

## 📊 Dataset Description

The dataset contains e-commerce transaction records with the following key attributes:

- **Transaction ID**: Unique identifier for each transaction
- **Customer Information**: Customer ID, demographics
- **Product Details**: Product ID, category, price
- **Transaction Details**: Timestamp, quantity, total amount
- **Location Data**: Geographic information for analysis

---

## ☁️ AWS Services Used

| Service | Purpose |
|---------|----------|
| **Amazon S3** | Data storage for raw and transformed datasets |
| **AWS Lambda** | Event-driven trigger for ETL pipeline |
| **AWS Glue** | Data cataloging and ETL transformations |
| **Amazon Athena** | Serverless querying of transformed data |
| **AWS IAM** | Identity and access management |

---

## 🔄 Project Workflow

### 1. Raw Data Ingestion
- Raw e-commerce transaction data is uploaded to the **source S3 bucket**
- Data format: CSV files with transaction records
- S3 bucket configured with event notifications

### 2. Lambda Trigger
- **Lambda function** (`trigger-glue-etl`) is automatically invoked on S3 PUT/POST events
- Function validates the uploaded file and initiates the ETL process
- Error handling and logging implemented for monitoring

### 3. Glue Crawlers
- **Crawler #1**: Scans raw data bucket to update schema in Glue Data Catalog
- **Crawler #2**: Scans transformed data bucket after ETL completion
- Automatic schema detection and table creation

### 4. Glue ETL Job
- **ETL Job** (`pandas_etl_job`) processes the raw data
- Data transformations include:
  - Data cleaning and validation
  - Type conversions and formatting
  - Aggregations and calculations
  - Partitioning for optimal querying

### 5. Athena Querying
- Transformed data becomes queryable through **Amazon Athena**
- SQL-based analytics and reporting
- Integration with visualization tools

---

## 🗃️ Transformed Dataset Schema

| Column | Type | Description |
|--------|------|-------------|
| `transaction_id` | string | Unique transaction identifier |
| `customer_id` | string | Customer unique identifier |
| `product_id` | string | Product unique identifier |
| `product_category` | string | Product category classification |
| `transaction_date` | date | Date of transaction |
| `transaction_amount` | double | Total transaction amount |
| `quantity` | int | Number of items purchased |
| `customer_location` | string | Customer geographic location |
| `payment_method` | string | Payment method used |

---

## ⚡ Lambda Function Details

### Function Configuration
- **Runtime**: Python 3.9
- **Memory**: 128 MB
- **Timeout**: 5 minutes
- **Trigger**: S3 Event Notification

### Key Features
- Automatic Glue job triggering
- Error handling and retry logic
- CloudWatch logging integration
- Environment variable configuration

```python
def lambda_handler(event, context):
    # Extract S3 event details
    # Validate file format
    # Trigger Glue ETL job
    # Handle errors and logging
    pass
```

---

## 🔍 SQL Queries

### Sample Analytical Queries

#### 1. Top Product Categories by Revenue
```sql
SELECT 
    product_category,
    SUM(transaction_amount) as total_revenue,
    COUNT(*) as transaction_count
FROM transformed_transactions
GROUP BY product_category
ORDER BY total_revenue DESC
LIMIT 10;
```

#### 2. Monthly Sales Trends
```sql
SELECT 
    DATE_TRUNC('month', transaction_date) as month,
    SUM(transaction_amount) as monthly_revenue,
    COUNT(DISTINCT customer_id) as unique_customers
FROM transformed_transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;
```

#### 3. Customer Segmentation
```sql
SELECT 
    customer_location,
    AVG(transaction_amount) as avg_transaction_value,
    COUNT(*) as transaction_frequency
FROM transformed_transactions
GROUP BY customer_location
ORDER BY avg_transaction_value DESC;
```

---

## 📁 Folder Structure

```
Ecommerce_Transactions_Data_Pipeline/
├── lambda_functions/
│   ├── trigger-glue-etl.py
│   └── requirements.txt
├── glue_scripts/
│   ├── pandas_etl_job.py
│   └── transformation_utils.py
├── sql_queries/
│   ├── analytics_queries.sql
│   └── data_validation.sql
├── infrastructure/
│   ├── cloudformation_template.yaml
│   └── iam_policies.json
├── sample_data/
│   └── sample_transactions.csv
└── README.md
```

---

## 🚀 How to Run

### Prerequisites
- AWS Account with appropriate permissions
- AWS CLI configured
- Python 3.9+ installed

### Deployment Steps

1. **Set up S3 Buckets**
   ```bash
   aws s3 mb s3://your-raw-data-bucket
   aws s3 mb s3://your-transformed-data-bucket
   ```

2. **Deploy Lambda Function**
   - Create Lambda function with provided code
   - Configure S3 event trigger
   - Set up IAM roles and permissions

3. **Configure Glue Components**
   - Create Glue database
   - Set up crawlers for both buckets
   - Deploy ETL job script

4. **Test the Pipeline**
   - Upload sample CSV file to raw data bucket
   - Monitor Lambda and Glue job execution
   - Query results in Athena

### Monitoring and Troubleshooting
- Check CloudWatch logs for Lambda function
- Monitor Glue job execution status
- Verify data quality in transformed bucket

---

## 🔮 Future Improvements

- [ ] **Real-time Processing**: Implement Kinesis for streaming data
- [ ] **Data Quality Checks**: Add automated data validation rules
- [ ] **Cost Optimization**: Implement S3 lifecycle policies
- [ ] **Monitoring Dashboard**: Create CloudWatch dashboard
- [ ] **Error Notifications**: Set up SNS alerts for failures
- [ ] **Data Lineage**: Implement data lineage tracking
- [ ] **Security Enhancements**: Add data encryption at rest
- [ ] **Performance Optimization**: Implement data partitioning strategies

---

## 👨‍💻 Author

**Nivin24**
- GitHub: [@Nivin24](https://github.com/Nivin24)
- Project: E-commerce Transactions Data Pipeline

---

*This project demonstrates modern data engineering practices using AWS cloud services for scalable, event-driven data processing.*
