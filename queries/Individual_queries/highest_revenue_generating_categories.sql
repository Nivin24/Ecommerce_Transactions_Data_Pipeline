SELECT category,
       ROUND(SUM(total_price),2) AS total_category_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY category
ORDER BY total_category_revenue DESC;