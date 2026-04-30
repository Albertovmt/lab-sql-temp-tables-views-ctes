USE sakila;

-- Step 1: Create a View

DROP VIEW IF EXISTS rental_count;
CREATE VIEW rental_count AS
SELECT c.customer_id, c.first_name, c.email, COUNT(r.rental_id) AS total_rented
FROM rental AS r
LEFT JOIN customer AS c
ON r.customer_id = c.customer_id
GROUP BY customer_id;

-- Step 2: Create a Temporary Table

DROP TEMPORARY TABLE IF EXISTS total_paid;
CREATE TEMPORARY TABLE total_paid AS
SELECT rc.customer_id, rc.total_rented, SUM(p.amount) AS total_amount
FROM rental_count AS rc
LEFT JOIN payment as p
ON rc.customer_id = p.customer_id
GROUP BY rc.customer_id
ORDER BY total_amount DESC;

SELECT *
FROM total_paid;

-- Step 3: Create a CTE and the Customer Summary Report

WITH customer_summary_cte AS (
SELECT rc.first_name AS name, rc.email, rc.total_rented, tp.total_amount
FROM total_paid AS tp
INNER JOIN rental_count AS rc
ON tp.customer_id = rc.customer_id
)
SELECT name, email, total_rented, total_amount, 
(total_amount/total_rented) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY average_payment_per_rental DESC;



