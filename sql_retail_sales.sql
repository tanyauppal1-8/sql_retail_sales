-- SQL Retail Sales Analyst
CREATE DATABASE sql_project_1;

USE sql_project_1;
-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT NULL,
    category VARCHAR(20),
	quantiy	INT NULL,
    price_per_unit DECIMAL(10,2) NULL,
	cogs DECIMAL(10,2) NULL,
	total_sale DECIMAL(10,2) NULL
	);
    
SELECT COUNT(*)
FROM retail_sales;

-- Data Cleaning
DELETE
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit = 0
    OR cogs IS NULL
    OR total_sale IS NULL;
    
SELECT COUNT(*)
FROM retail_sales;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*)
AS total_sale
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT(customer_id))
AS unique_customer_count
FROM retail_sales;

-- How many unique category we have?
SELECT COUNT(DISTINCT(category))
AS unique_category_count
FROM retail_sales;

-- What are the names of categories we have?
SELECT DISTINCT(category)
FROM retail_sales;

-- Data Analysis and Business Key Problems and Answers

-- Q.1 Write a SQL query to retrieve all records for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all records where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE ((category = 'Clothing') AND (quantiy > 3) AND (sale_date BETWEEN '2022-11-01' AND '2022-11-30'));

-- Q.3 Write a SQL query to calculate the total sales named as 'total_sale_for_this_category' for each category
SELECT category, SUM(total_sale) AS total_sale_for_this_category
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age), 2) AS average_age_of_person
FROM retail_sales
WHERE age != 0
GROUP BY category
HAVING category = 'Beauty';

-- Q.5 Write a SQL query to find all records where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions identified as transactions_id, made by each gender in each category
SELECT gender, category, COUNT(transactions_id) AS count_of_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;

-- Q.7 Write a SQL query to calculate the average sale for each month and then display the best selling month in each year
SELECT sale_year_month, average_sale
FROM
(
	SELECT sale_year_month, average_sale,
	RANK() OVER (
		PARTITION BY year_detail
		ORDER BY average_sale DESC) AS final_level
	FROM
	(
		SELECT YEAR(sale_date) AS year_detail, DATE_FORMAT(sale_date, '%Y-%m') AS sale_year_month, ROUND(AVG(total_sale), 2) AS average_sale
		FROM retail_sales
		GROUP BY YEAR(sale_date), DATE_FORMAT(sale_date, '%Y-%m')
		ORDER BY DATE_FORMAT(sale_date, '%Y-%m')
	) AS ft
) AS fin_que
WHERE final_level = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, ROUND(SUM(total_sale), 0) AS customer_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT shift, COUNT(shift) AS number_of_orders
FROM
(
	SELECT HOUR(sale_time) AS shift_in_hour,
	CASE
		WHEN HOUR(sale_time) BETWEEN 0 AND 12 THEN 'Morning'
		WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
	FROM retail_sales
) AS ft
GROUP BY shift;

-- End Of Project