-- What is the percentage of sales in the Health & Wellness category by generation?
-- For this question, I am assuming that the FINAL_SALE column in the transactions table is inclusive of the total number of products purchased (FINAL_QUANTITY).
-- I looked up some of the UPCs, prices, and compared that to the quantity to make this decision. 
-- I'm also excluding the rows with blank values in the FINAL_SALE column.

-- -- get ages
WITH 
users_age AS (
SELECT id, 
birth_date,
DATE_DIFF('year', CAST(BIRTH_DATE AS DATE), current_date) AS age,
FROM users 
)
,
-- get generations
users_gen AS (
SELECT *,
CASE WHEN age BETWEEN 1 AND 12 THEN 'Gen Alpha' 
	WHEN age BETWEEN 13 AND 28 THEN 'Gen Z'
	WHEN age BETWEEN 29 AND 44 THEN 'Millennial'
	WHEN age BETWEEN 45 AND 60 THEN 'Gen X'
	WHEN age > 60 THEN 'Boomer'
END AS generation
FROM users_age
)
,
-- get sales in Health & Wellness category, and getting rid of blanks in final_sale
gen_sales AS (
SELECT 
final_sale,
generation
FROM transactions t
JOIN products p ON t.barcode = p.barcode
JOIN users_gen u ON t.user_id = u.id
WHERE final_sale > '  '
AND category_1 like 'Health & Wellness'
)
,
-- get total sales per generation
sales_agg_table AS (
SELECT 
generation,
SUM(CAST(final_sale AS DECIMAL)) AS gen_total
FROM gen_sales
GROUP BY generation
)
,
-- get column with total overall sales
final_table AS (
SELECT generation,
gen_total,
SUM(gen_total) OVER () AS total_sales
FROM sales_agg_table
GROUP BY generation, gen_total
)
--calculate percentage for each generation
SELECT generation,
ROUND((gen_total / total_sales)*100,2) AS percentage
FROM final_table
GROUP BY ALL
ORDER BY percentage;

