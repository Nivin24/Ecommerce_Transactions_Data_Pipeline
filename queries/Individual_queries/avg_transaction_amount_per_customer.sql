SELECT customer_name,
       AVG(total_price) AS avg_transaction_value
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY customer_name
ORDER BY avg_transaction_value DESC
LIMIT 10;