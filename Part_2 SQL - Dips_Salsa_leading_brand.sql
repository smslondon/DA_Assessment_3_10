-- Which is the leading brand in the Dips & Salsa category?
-- I'm defining 'leading brand' as 'has the most total sales' during this period. 
-- Again, I am assuming that the FINAL_SALE column in the transactions table is inclusive of the total number of products purchased (FINAL_QUANTITY). 
-- I'm also excluding the rows with blank values in that column. 

-- get top brands in category; exclude blanks
WITH 
top_brands AS (
SELECT category_2,
brand,
SUM(CAST(final_sale AS DECIMAL)) AS total_brand_sales
FROM transactions t
JOIN products p ON t.barcode = p.barcode
WHERE category_2 like 'Dips & Salsa'
AND final_sale > '  '
AND brand IS NOT NULL
GROUP BY brand, category_2 
ORDER BY total_brand_sales DESC
)
-- get top brand
SELECT brand
FROM top_brands
LIMIT 1;