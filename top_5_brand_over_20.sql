-- What are the top 5 brands by receipts scanned among users 21 and over?
-- The results are the top 5 brands, but since the sample size is low, the receipt count is low
-- and there are many with the same number of receipts (i.e. Nerds and Dove both have 6 receipts scanned)
-- If this were based on the full database, I would use a RANK function to look at ties

-- thinned transcations table to those 21 and over
WITH users_21 AS (
SELECT id, 
DATE_DIFF('year', CAST(BIRTH_DATE AS DATE), current_date) AS age 
FROM users 
WHERE age > 20
)

-- count receipt_ids by brand, exclude brand NULLs; there isn't much data to go off of-not much overlap between users and transactions table
SELECT brand,
	COUNT(receipt_id) AS receipt_count
FROM transactions t
JOIN products p ON t.barcode = p.barcode
JOIN users_21 u ON t.user_id = u.id
WHERE brand IS NOT NULL
GROUP BY brand 
ORDER BY receipt_count DESC
LIMIT 5;
