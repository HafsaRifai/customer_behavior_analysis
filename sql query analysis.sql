select * from customer limit 20

--1.what is the total revenue creatd by male vs female customers ?

select gender, SUM (purchase_amount) as revenue 
from customer 
group by gender 
--2.which customer used a discount but still spent more than the avg purchase amount ?

select customer_id, purchase_amount
from customer
where discount_applied = 'yes' and purchase_amount >= (select AVG (purchase_amount) from customer)

--3.which are top 5 products with the highest average review rating ?

select item_purchased, ROUND(AVG(review_rating :: numeric) ,2) as "average product rating"
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

--4.compare the average purchase amounts between standard and express shipping ?

select shipping_type, Round(AVG(purchase_amount),2)
from customer
where shipping_type in ('standard' , 'express')
group by shipping_type 


--5.do subscribed customer spend more ? compare the average spend and total revnue between subribers and non subcribers ?

select subscription_status,
count (customer_id) as total_customers,
ROUND(avg(purchase_amount),2) as avg_spend,
ROUND(avg(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

--6.which 5 products have the highest percentage of purchases with discounts applied ?

select item_purchased,
round (100 * sum(case when discount_applied = 'yes' then 1 else 0 end)/ count (*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate  desc
limit 5 ;

--7.segmnets customers into new , returning and loyal based on their total number of their prev purchases and show the count of each segment 

with customer_type as (
         select customer_id, 
		        previous_purchases,
                case 
                    when previous_purchases = 1 then 'new'
	                when previous_purchases between 2 and 10 then 'returning'
	                else 'loyal'
	            end as customer_segment 
         from customer
)

select customer_segment , 
        count (*) as "number of customers"
from customer_type 
group by customer_segment

--8.what are the top3 most purchased products within each category ?

with item_count as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category , item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_count 
where item_rank<= 3;

--9.are customers who are repeat buyers (more than 5 prev purchases) also likely to subscribe 

select subscription_status ,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5 
group by subscription_status


--10. what is the revenue contribution of each age group

select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc ;










