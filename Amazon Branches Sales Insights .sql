create database amazon_data;
use amazon_data;
describe sales_analysis;
select * from sales_analysis;
-- SQL Capstone Project on Amazon Slaes Data
-- Creating a New column time_of_day 
alter table sales_analysis
add column time_of_day varchar(20) after Time;

-- updating values in time_of_day column
set sql_safe_updates = 0;

update sales_analysis
	set time_of_day = 
		case
			when time(time) >= '00:00:00' and time(time) < '12:00:00' then 'Morning'
            when time(time) >= '12:00:00' and time(time) < '18:00:00' then 'Afternoon'
            else 'Evening'
		end;
        
select * from sales_analysis;

-- Creating a New column day_name
 alter table sales_analysis
add column day_name varchar(20) after Date;

update sales_analysis 
	set day_name=
		case dayofweek(date)
			when 1 then 'Sun'
            when 2 then 'Mon'
            when 3 then 'Tue'
            when 4 then 'Wed'
            when 5 then 'Thu'
            when 6 then 'Fri'
            when 7 then 'Sat'
		end;
select * from sales_analysis;

-- Adding a New column month_name
alter table sales_analysis
add column month_name varchar(20) after day_name;

-- updating values in month_name column
update sales_analysis
	set month_name =
		case month(date)
			when 1 then 'Jan'
            when 2 then 'Feb'
            when 3 then 'Mar'
            when 4 then 'Apr'
            when 5 then 'May'
            when 6 then 'Jun'
            when 7 then 'Jul'
            when 8 then 'Aug'
            when 9 then 'Sep'
            when 10 then 'Oct'
            when 11 then 'Nov'
            when 12 then 'Dec'
		end;
select * from sales_analysis;

-- Business Que
-- 1.What is the count of distinct cities in the dataset?
select distinct city from sales_analysis;

-- 2.For each branch, what is the corresponding city?
select distinct branch,city from sales_analysis;

-- 3.What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT `Product line`) FROM sales_analysis;
SELECT DISTINCT `Product line` FROM sales_analysis;

-- 4.Which payment method occurs most frequently?
select payment, count(*) as frequency
from sales_analysis
group by payment
order by frequency desc;

-- 5.Which product line has the highest sales?
select `Product line`, count(*) as total_sales
from sales_analysis
group by `Product line`
order by total_sales desc;

-- 6.How much revenue is generated each month?
select month_name, round(sum(total),2) as revenue
from sales_analysis
group by month_name
order by revenue desc;

-- 7.In which month did the cost of goods sold reach its peak?
select month_name, round(sum(cogs),2) as total_cogs
from sales_analysis
group by month_name
order by total_cogs desc;

-- 8.Which product line generated the highest revenue?
select `Product line`, round(sum(total),2) as highest_revenue
from sales_analysis
group by `Product line`
order by highest_revenue desc;

-- 9.In which city was the highest revenue recorded?
select city, round(sum(total),2) as highest_revenue
from sales_analysis
group by city
order by highest_revenue desc;

-- 10.Which product line incurred the highest Value Added Tax?
select `Product line`, round(sum(`Tax 5%`), 2) as Total_vat
from sales_analysis
group by `Product line`
order by `Total_vat` desc;

-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select `product line`, round(sum(total),2) as Total_sales,
	case
		when sum(total) > (
			select avg(total_sales)
            from(
				select `product line`, sum(total) as Total_sales
                from sales_analysis
                group by `product line`
                ) as subquery
        ) then 'Good'
        else 'Bad'
        end as sales_status
        from sales_analysis
        group by `product line`
        order by total_sales desc;
        
-- 12.Identify the branch that exceeded the average number of products sold.
select branch, sum(quantity) as total_quantity
from sales_analysis
group by branch
having sum(quantity) > (select avg(quantity) from sales_analysis);

-- 13.Which product line is most frequently associated with each gender?
select `product line`, gender, count(*) as frequency
from sales_analysis
group by gender, `product line`
order by frequency desc;

-- 14.Calculate the average rating for each product line.
select `product line`, round(avg(rating),3) as avg_rating
from sales_analysis
group by `product line`
order by avg_rating desc;

-- 15.Count the sales occurrences for each time of day on every weekday.
select time_of_day, day_name, count(*) as sales_occurence
from sales_analysis
where day_name in ('Mon','Tue','Wed','Thu','Fri')
group by time_of_day, day_name
order by sales_occurence desc;

-- 16.Identify the customer type contributing the highest revenue.
select `customer type`, round(sum(total), 2) as highest_revenue
from sales_analysis
group by `customer type`
order by highest_revenue desc;

-- 17.Determine the city with the highest VAT percentage.
select city,
round(sum(`Tax 5%`), 2) as higest_vat,
round(sum(Total), 2) as total_sales,
round((sum(`Tax 5%`) / sum(Total)) * 100,2) as vat_percentage
from sales_analysis
group by city
order by higest_vat desc;


-- 18.Identify the customer type with the highest VAT payments.
select `Customer type`, round(sum(`Tax 5%`),2) as highest_vat_payments
from sales_analysis
group by `Customer type` 
order by highest_vat_payments desc;

-- 19.What is the count of distinct customer types in the dataset?
select count(distinct `Customer type`) as distinct_customer_type
from sales_analysis;

-- 20.What is the count of distinct payment methods in the dataset?
select count(distinct payment) as distinct_paymnet_method
from sales_analysis;

-- 21.Which customer type occurs most frequently?
select `Customer type`, count(`Customer type`) as frequency
from sales_analysis
group by `Customer type`
order by frequency desc;

-- 22.Identify the customer type with the highest purchase frequency.
select `Customer type`, count(*) as highest_purchase
from sales_analysis
group by `Customer type`
order by highest_purchase desc;

-- 23.Determine the predominant gender among customers.
select gender, count(*) as predominant_gender
from sales_analysis
group by gender
order by predominant_gender desc;

-- 24.Examine the distribution of genders within each branch.
select branch,gender, count(*) as gender_count
from sales_analysis
group by gender,branch
order by gender_count desc;

-- 25.Identify the time of day when customers provide the most ratings.
select time_of_day, count(rating) as rating_count
from sales_analysis
group by time_of_day
order by rating_count desc;

-- 26.Determine the time of day with the highest customer ratings for each branch.
select branch,time_of_day, round(avg(rating),2) as average_rating
from sales_analysis
group by branch,time_of_day
order by average_rating desc;

-- 27.Identify the day of the week with the highest average ratings.
select day_name, round(avg(rating),2) as highest_rating
from sales_analysis
group by day_name
order by highest_rating desc;

-- 28.Determine the day of the week with the highest average ratings for each branch.
select branch,day_name, round(avg(rating),2) as highest_average_rating
from sales_analysis
group by branch,day_name
order by highest_average_rating desc;
