create database walmart_sales_data; 

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(10) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10, 2) not null,
    quantitiy int not null,
    VAT float(6, 4) not null,
    total decimal(12, 4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10, 2) not null,
    gross_margin_percentage float(11, 9),
    gross_income decimal(12, 4) not null,
    rating float(2, 1)
    
);


-- ----------------------feature engineering----------------------------------------------
-- ----------------------------------------------------------------------- 
-- -------- Time of the day

-- 1. Adding a new column "time_of_day" to give insights of sales in the Morning, Afternoon and
-- Evening. This will help answer the question on which part of the day most sales are made.

SELECT time, 
       CASE 
           WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
           WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sales;


alter table sales add column time_of_day varchar(20);

UPDATE sales
SET time_of_day = 
    CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END;

-- Day name --
-- 2. Add a new column "day_name" that contains the extracted days of the week on which 
-- the given transactioon took place (Mon, Tue, Thur, Fri). This will help answer the question
-- on which week of the day each branch is busiest.

select date,
dayname(date) as day_name
from sales;
  
alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- 3. Add a new column named month_name that contains the extracted months of the year
-- on which the given transaction took place (Jan, Feb, Mar). Help determine which  
-- month of the year has the most sales and profit

select date,
monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- -----------------------------------------------------------------------------------
-- ---------------------------------- Questions --------------------------------------------

-- Q1. How many unique cities does the data have ?

select 
distinct city 
from sales;


-- Q2. In which city is each branch ?

select 
	distinct city, 
    branch
from sales;


-- Q3. How many unique product line does the data have ?

select 
	count(distinct product_line)
from sales;


-- Q4. What is the most common payment method ?

select payment_method, count(payment_method) as Count
from sales
group by payment_method
order by Count desc;


-- Q5. What is the most selling product line ?

select product_line, 
count(product_line) as Count
from sales
group by product_line
order by Count desc;


-- Q6. What is the total revenue by month ?

select month_name as month, round(sum(total), 2) as total_revenue
from sales
group by month
order by total_revenue;


-- Q7. What month had the largest COGS (cost of goods sold) ?

select month_name as month, 
sum(cogs) as cogs
from sales
group by month 
order by cogs desc;


-- Q8. What product line had the largest revenue ?

select product_line, 
round(sum(total), 2) as total_revenue
from sales
group by product_line
order by total_revenue desc;


-- Q9. What is the city with the largest revenue ?

select branch, city, 
round(sum(total), 2) as total_revenue 
from sales
group by branch, city 
order by total_revenue desc;


-- Q10. What product line has the largest VAT ? 

select product_line, 
round(avg(VAT), 3) as VAT 
from sales
group by product_line
order by VAT desc;


-- Q11. Which branch sold the more products than average product sold ?

select branch, 
sum(quantitiy) as most_sold
from sales 
group by branch 
having sum(quantitiy) > (select avg (quantitiy) from sales);


-- Q12. What is the most common product line by gender ?

select gender, product_line,
count(gender) as total_count
from sales
group by gender, product_line
order by total_count desc;


-- Q13. What is the average rating of each product line ?

select product_line, 
round(avg(rating), 2) as avg_rate
from sales
group by product_line
order by avg_rate desc;


-- Q14. Number of sale made in each time of the day per week. for ex. "Sunday"

select time_of_day, 
count(time_of_day) as total_sale 
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sale desc; 


-- Q15. Which of the customer types brings the most revenue ?

select customer_type, 
round(sum(total), 2) as total_revenue 
from sales
group by customer_type
order by total_revenue desc;


-- Q16. Which city has the largest tax percent / Value added tax (VAT) ?

select city, 
round(avg(VAT), 2) as tax_percent 
from sales
group by city
order by tax_percent desc;


-- Q17. Which customer type pays the most VAT ?

select customer_type, 
round(avg(VAT), 2) as tax 
from sales
group by customer_type
order by tax desc;
 
 
 -- Q18. Which customer type buys the most ?

select customer_type,
count(customer_type) as customer_count 
from sales
group by customer_type
order by customer_type desc;


-- Q19. What is the gender of the most customers ?

select gender, 
count(customer_type) as customers 
from sales
group by gender
order by customers desc;


-- Q20. Which time of the day customers give more ratings ?

select time_of_day, 
count(rating) as rating  
from sales
group by time_of_day
order by rating desc;


-- Q21. Which day of the week has the best avg rating ?

select day_name, 
round(avg(rating), 2) as avg_customer_rating 
from sales
group by day_name
order by avg_customer_rating desc;





























