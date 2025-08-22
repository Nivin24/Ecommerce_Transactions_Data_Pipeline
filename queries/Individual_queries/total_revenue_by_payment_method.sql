SELECT payment_method,
       ROUND(SUM(total_price),2) AS total_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY payment_method
ORDER BY total_revenue DESC;