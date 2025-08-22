SELECT customer_name,
       ROUND(SUM(total_price),2) AS total_spent
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;