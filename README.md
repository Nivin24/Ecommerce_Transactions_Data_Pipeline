# 🛍️ E-commerce Transactions Data Pipeline using AWS Glue & Athena

## 📌 Project Overview
This project demonstrates the creation of an **end-to-end ETL (Extract, Transform, Load) pipeline** for processing **e-commerce transaction data** using **AWS Glue, Athena, and S3**.  
The workflow involves ingesting raw transaction data, transforming it using **Glue ETL jobs**, and making it queryable in **Athena**.

---

## 🗂️ Table of Contents
- [Project Architecture](#-project-architecture)
- [Dataset Description](#-dataset-description)
- [AWS Services Used](#-aws-services-used)
- [Project Workflow](#-project-workflow)
  - [1. Raw Data Ingestion](#1-raw-data-ingestion)
  - [2. Glue Crawlers](#2-glue-crawlers)
  - [3. Glue ETL Job](#3-glue-etl-job)
  - [4. Athena Querying](#4-athena-querying)
- [Transformed Dataset Schema](#-transformed-dataset-schema)
- [SQL Queries](#-sql-queries)
- [Folder Structure](#-folder-structure)
- [How to Run](#-how-to-run)
- [Future Improvements](#-future-improvements)
- [Author](#-author)

---

## 🏗️ Project Architecture

      ┌──────────────────┐
      │  Raw Dataset     │
      │ (S3 Bucket)      │
      └────────┬─────────┘
               │
    ┌──────────▼──────────┐
    │   Glue Crawler #1   │
    │ (Detect Raw Schema) │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │   Glue ETL Job      │
    │ (Transform Data)    │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │ Transformed Dataset │
    │     (S3 Bucket)     │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │   Glue Crawler #2   │
    │ (Detect Final Schema) │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │    Athena Tables    │
    │  (Query Insights)   │
    └─────────────────────┘


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
- **Amazon Athena** → Performs SQL-based queries on the transformed dataset.

## 🚀 Project Workflow

### 1. Raw Data Ingestion

- The raw e-commerce dataset is uploaded to an Amazon S3 bucket.
- This dataset contains multiple unstructured files that need schema detection.

### 2. Glue Crawlers

- **Crawler #1** → Scans the raw dataset and automatically generates the schema.
- **Crawler #2** → Scans the transformed dataset after ETL and updates the schema in the AWS Glue Data Catalog.

### 3. Glue ETL Job

A PySpark-based Glue ETL job performs:
- Data cleaning
- Column transformations
- Adding year and month partitions
- Calculating `total_price`

The transformed dataset is saved back to S3.

### 4. Athena Querying

- The final transformed data is queried using Amazon Athena.
- SQL queries are saved separately for future reference.

## 📑 Transformed Dataset Schema

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


## 📝 SQL Queries

All SQL queries used for analysis are saved in the repository:

- [`queries/`](./queries/) → Folder containing each query separately.
- [`all_queries.sql`](./queries/all_queries.sql) → A single file containing all queries combined.

## 📁 Folder Structure

ecommerce-transactions-pipeline/
│
├── data/
│ ├── raw/ # Raw dataset
│ └── transformed/ # Transformed dataset
│
├── etl/
│ └── glue_etl_job.py # Glue ETL job script
│
├── queries/
│ ├── all_queries.sql # All queries in one file
│ └── individual_queries/ # Each query saved separately
│
├── README.md # Project documentation
└── requirements.txt # Dependencies (if any)


## 🛠️ How to Run

**Upload Raw Data to S3**

aws s3 cp data/raw/ s3://<your-bucket-name>/raw/ --recursive


**Run Glue Crawler #1**
- Detects the schema of raw data.

**Run Glue ETL Job**
- Transforms the dataset and stores it in a transformed folder.

**Run Glue Crawler #2**
- Detects schema of transformed data.

**Query Data in Athena**
- Use Athena to run SQL queries on the processed dataset.

## 🚀 Future Improvements

- Automate the entire pipeline using AWS Step Functions.
- Set up event-driven ETL with S3 event triggers.
- Integrate QuickSight for visualization.
- Add data quality checks before loading.

## 👨‍💻 Author

Nivin Benny  
📧 Email: [your-email@example.com]  
🔗 LinkedIn: [https://www.linkedin.com/in/nivinbenny](https://www.linkedin.com/in/nivinbenny)

---
