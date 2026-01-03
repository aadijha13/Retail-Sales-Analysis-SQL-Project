-- SQL Retail Sales Analysis - P1
CREATE DATABASE RETAIL SALES
-- Create Table
CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT INT,
	COGS FL,
	TOTAL_SALE
)
--VIEW DATA 
SELECT
	*
FROM
	RETAIL_SALES;

-- TOTAL DATA
SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

/* DATA CLEANING */
-- HOW TO SEE NULL DATA?
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- HOW TO DELETE NULL DATA?
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

/* DATA EXPLORATION*/
-- HOW MANY SALES WE HAVE?
SELECT
	COUNT(*) AS TOTAL_SALES
FROM
	RETAIL_SALES;

-- HOW MANY UNIUQUE CUSTOMERS WE HAVE?
SELECT
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES;

/*Data Analysis & Business Key Problems & Answers */
-- My Analysis & Findings --
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND QUANTIY >= 4
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS "TOTAL SALE",
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	GENDER,
	CATEGORY,
	COUNT(*) AS TOTAL_TRANSACTIONS
FROM
	RETAIL_SALES
GROUP BY
	GENDER,
	CATEGORY
ORDER BY
	GENDER;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
	YEAR,
	MONTH,
	AVG_SALE
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALE) AS AVG_SALE,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			)
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANK = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALES
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5
	-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY
	-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH HOURLY_SALE AS (
    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
            WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            ELSE 'EVENING'
        END AS SHIFT
    FROM RETAIL_SALES
)
SELECT
    SHIFT,
    COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALE
GROUP BY SHIFT;