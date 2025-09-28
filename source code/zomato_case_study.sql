create database zomato;

SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM users;
SELECT * FROM restaurants;
SELECT * FROM menu;
SELECT * FROM food;
SELECT * FROM delivery_partner;


-- Zomato_data Case Study

-- Questions

-- 1. Select a database.

use zomato;

-- 2. Count the total number of orders.

select count(order_id) as "total number of orders" from orders;

-- 3. Return 'n' random records from the orders table i.e. find 5 random samples.

select * from orders order by rand() limit 5;

-- 4. Find NULL values from the orders table.
select * from orders where restaurant_rating is null;

-- 5. Replace empty fields with NULL values.

set sql_safe_updates = 0;
update orders set restaurant_rating = null where restaurant_rating is null;

-- 6. Find the number of orders placed by each customer.

select users.user_id, name, count(orders.user_id) as "number of orders" 
from users
left join orders
on users.user_id = orders.user_id
group by user_id, name;

-- 7. Find the restaurants with the highest number of menu items.

select restaurants.r_id, r_name, count(menu.r_id) as "total menu" from restaurants
left join menu
on restaurants.r_id = menu.r_id
group by restaurants.r_id, r_name;


-- 8. Find the number of votes and average rating for all restaurants.

select restaurants.r_id, r_name, avg(restaurant_rating) as "average rating" , count(restaurant_rating) as "number of votes" from restaurants
left join orders
on restaurants.r_id = orders.r_id
where restaurant_rating is not null
group by restaurants.r_id, r_name;

-- 9. Which food item is sold by most of the restaurants?

select food.f_id, f_name, count(*) as total_count from food
left join menu
on food.f_id = menu.f_id
group by f_name,f_id
order by total_count desc limit 1;
SELECT * FROM menu;


-- 10. Which restaurant had the maximum revenue in May?

select r_name, sum(amount) as "maximum revenue" from restaurants
left join orders
on restaurants.r_id = orders.r_id
where monthname(date(date))= "May"
group by r_name
order by "maximum revenue" desc limit 1;


-- 11. Find Month-wise revenues of restaurants.

select monthname(date(date)) as "Month" ,sum(amount) as "maximum revenue" from restaurants
left join orders
on restaurants.r_id = orders.r_id
group by Month;


-- 12. Find restaurants with revenue of more than 1500.

select r_name ,sum(amount) as maximum_revenue from restaurants
left join orders
on restaurants.r_id = orders.r_id
group by r_name
having maximum_revenue >= 1500;

-- 13. Find customers who never ordered.

select users.user_id, name, count(order_id) as ordered from users
left join orders
on users.user_id = orders.user_id
group by users.user_id, name
having ordered is null;

-- 14. Show order details of particular customers in a given date range. (For example, Order details of Neha from 5th June to 15th July 2022)

select users.user_id,name,date,order_id,r_id,amount from orders
join users
on users.user_id = orders.user_id 
where name = "neha"  and
date between "2022-06-05" and "2022-07-15";

-- 15. Find the costliest restaurants.

select r_name as restaurant_name ,max(price) as Highest_price from restaurants
left join menu
on restaurants.r_id = menu.r_id
group by r_name
having Highest_price = (select max(price) from menu);

-- 16. Find delivery partner compensation using the formula ( deliveries 100+ & avg rating).

select delivery_partner.partner_id,partner_name, sum(delivery_time) as total_delivery,avg(delivery_rating) as total_delivery_rating from orders
left join delivery_partner
on orders.partner_id = delivery_partner.partner_id
group by delivery_partner.partner_id,partner_name
having total_delivery > 100;


-- 17. Find all Veg restaurants.

select restaurants.r_name as restaurants_name, food.type from food
left join menu
on food.f_id = menu.f_id
left join restaurants
on menu.r_id = restaurants.r_id
where type = "veg"
group by restaurants.r_name;

-- 18. Find min and max order value for all customers

select users.user_id, users.name, max(amount) as max_order_value ,min(amount) as min_order_value from users
left join orders
on users.user_id = orders.user_id
group by users.user_id, users.name;
