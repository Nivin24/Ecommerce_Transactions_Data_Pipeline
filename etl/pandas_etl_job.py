import pandas as pd
import awswrangler as wr

# S3 paths
RAW_PATH = 's3://final-project-bucket-26/raw/'   # folder instead of one file
CURATED_PATH = 's3://final-project-bucket-26/curated/ecommerce_transactions/'

def main():
    # Read ALL CSVs from the raw folder
    df = wr.s3.read_csv(path=RAW_PATH)

    # Type conversions
    df['amount'] = pd.to_numeric(df['amount'], errors='coerce')
    df['total_price'] = pd.to_numeric(df['total_price'], errors='coerce')
    df['transaction_date'] = pd.to_datetime(df['transaction_date'], errors='coerce')

    # Remove rows with missing key data
    df = df.dropna(subset=['customer_name', 'product_name', 'amount', 'transaction_date'])

    # String cleanup
    df['product_name'] = df['product_name'].str.strip()

    # Derived columns
    df['month'] = df['transaction_date'].dt.month
    df['year'] = df['transaction_date'].dt.year

    # Write to Parquet with partitioning
    wr.s3.to_parquet(
        df=df,
        path=CURATED_PATH,
        dataset=True,
        partition_cols=['year', 'month'],
        mode="overwrite_partitions"  # prevents duplicates when rerun
    )

    print("ETL job completed successfully.")

if __name__ == "__main__":
    main()