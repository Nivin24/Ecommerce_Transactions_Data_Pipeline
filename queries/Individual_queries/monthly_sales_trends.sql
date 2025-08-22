SELECT year,
       month,
       ROUND(SUM(total_price),2) AS monthly_revenue
FROM "AwsDataCatalog"."ecommerce_db"."curated_for_analysiscurated"
GROUP BY year, month
ORDER BY year, month;