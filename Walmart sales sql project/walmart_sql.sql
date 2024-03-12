create database sqlanalysis;
use sqlanalysis;
-- crating the table sales
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null ,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal (10,2) not null,
quantity int not null,
VAT float(6,4)  not null,
total decimal(10,2) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal (12,4) not null,
rating float (2,1) );
select * from sales;

-- checking the null values
SELECT COUNT(*) AS missing_count
FROM sales
WHERE branch
 IS NULL;

-- -------------------------------Feature Engineering-------------------------------

-- ------------time_of_day----------------------------------------------------------
select
     time,
     (case
       when `time` between "00:00:00" and "12:00:00" then "Morning"
       when `time` between "12:01:00" and "16:00:00" then "Afternoon"
       else "Evening"
       end) as time_of_date
     from sales;

-- Adding a column time_of_day
alter table sales add column time_of_day varchar(20);

-- insering the values	
update sales 
set time_of_day = (case
       when `time` between "00:00:00" and "12:00:00" then "Morning"
       when `time` between "12:01:00" and "16:00:00" then "Afternoon"
       else "Evening"
       end
);
-- ------------day_name----------------------------------------------------------
select 
date ,
DAYNAME(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = DAYNAME(date) ;


-- ------------month_name----------------------------------------------------------
select 
date,
monthname(date) as month_name
from sales;
alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date) ;


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	count(DISTINCT product_line)
FROM sales;


-- What is the most common payment method?
SELECT
     payment_method,
	count(payment_method) as cnt
FROM sales
GROUP BY payment_method
order by  cnt desc;

-- What is the most selling product line
SELECT
     product_line,
	count(quantity) as cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue desc;


-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs desc;


-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue desc;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------












