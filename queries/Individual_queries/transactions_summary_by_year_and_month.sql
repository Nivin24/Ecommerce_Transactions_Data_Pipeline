SELECT year,
       month,
       COUNT(transaction_id) AS total_transactions,
       ROUND(SUM(total_price),2) AS total_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY year, month
ORDER BY year, month;