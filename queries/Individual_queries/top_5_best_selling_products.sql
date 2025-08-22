SELECT product_name,
       SUM(quantity) AS total_quantity_sold
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;