--INSERTING THE CSV DATASET BY GUI METHOD

CREATE TABLE retail_transactions (
    customer_id VARCHAR(50), -- Customer ID
    transaction_id VARCHAR(50) PRIMARY KEY, -- Transaction ID
    gender VARCHAR(10), -- Male or Female
    age_group VARCHAR(20), -- Age range as string (e.g., '18-25')
    purchase_date TIMESTAMP, -- Date and time of transaction
    product_category VARCHAR(100), -- e.g., Electronics, Apparel
    discount_availed BOOLEAN, -- Yes/No converted to TRUE/FALSE
    discount_name VARCHAR(50), -- e.g., FESTIVE50
    discount_amount NUMERIC(10,2), -- Discount in INR
    gross_amount NUMERIC(10,2), -- Amount before discount
    net_amount NUMERIC(10,2), -- Final amount after discount
    purchase_method VARCHAR(50), -- e.g., Credit Card
    location VARCHAR(100) -- City
);
-- DISPLAYING THE DATA IN TABLE FORMAT

select * from retail_transactions;

--PERFORMING SOME OPERATIONS TOTAL REVENUE AND DISC. STATS

SELECT
    SUM(gross_amount) AS total_gross_revenue,
    SUM(discount_amount) AS total_discounts_given,
    SUM(net_amount) AS total_net_revenue
FROM retail_transactions;


-- Checking Customer Demographics Breakdown
select gender from retail_transactions
group by gender;


SELECT gender, age_group, COUNT(*) AS total_customers
FROM retail_transactions
GROUP BY gender, age_group
ORDER BY total_customers DESC;

-- Extracting the total sales of each category using group by function

SELECT product_category,
COUNT(*) AS total_transactions,
SUM(net_amount) AS total_sales
FROM retail_transactions
GROUP BY product_category
ORDER BY total_sales DESC;


-- Extracting the all the info of the customer using where clause when discount is not given
SELECT *
FROM retail_transactions
WHERE discount_availed = false
ORDER BY net_amount DESC
LIMIT 10;

-- Extracting  Highest valued customer using subquery
SELECT customer_id, SUM(net_amount) AS total_spent
FROM retail_transactions
GROUP BY customer_id
HAVING SUM(net_amount) = (
SELECT MAX(customer_total)
FROM (
SELECT customer_id, SUM(net_amount) AS customer_total
FROM retail_transactions
GROUP BY customer_id ) AS subquery
);

-- Extracting  the 5th Highest person for the total spent money
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(net_amount) AS total_spent
    FROM retail_transactions
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 5
) AS top5
ORDER BY total_spent
LIMIT 1;

-- Customers who spent more than the average total spend

SELECT customer_id, SUM(net_amount) AS total_spent
FROM retail_transactions
GROUP BY customer_id
HAVING SUM(net_amount) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(net_amount) AS total
        FROM retail_transactions
        GROUP BY customer_id
    ) AS sub
);

