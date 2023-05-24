use world;

-- Which product has the highest price? Only return a single row.

select
    product_name,
    price
from 
   products
order by
     price desc
limit 1;

-- Which customer has made the most orders?
 select
    concat(c.first_name,' ',c.last_name) as Full_name,
    count(o.order_date) as no_of_order
from customers c
inner join orders o
on c.customer_id=o.customer_id
group by 
     Full_name
limit 1;

-- What’s the total revenue per product?

select
    p.product_name,
    sum(p.price*o.quantity) as Revenue
from products p
inner join order_items o 
on o.product_id=p.product_id
group by 
    p.product_name
order by
     Revenue desc;

-- Find the day with the highest revenue.
select
    dayname(oi.order_date) as day_name,
    sum(p.price*o.quantity) as Revenue
from products p
inner join order_items o 
on o.product_id=p.product_id
inner join orders oi
on oi.order_id=o.order_id
group by 
    day_name
order by
     Revenue desc
limit 1;


-- Find the first order (by date) for each customer.
with first_order as (select
    c.customer_id,
    o.order_date,
    dense_rank() over(partition by c.customer_id order by o.order_date) as rn
from customers c
join orders o
on c.customer_id=o.customer_id
group by
	c.customer_id,
    o.order_date)

select 
    customer_id,
    order_date
from first_order
where rn=1;

-- Find the top 3 customers who have ordered the most distinct products
select
    concat(c.first_name,' ',c.last_name) as Full_name,
    count(distinct o.order_date) as no_of_uniq_order
from customers c
inner join orders o
on c.customer_id=o.customer_id
group by 
     Full_name
order by
     no_of_uniq_order desc
limit 3;


-- Which product has been bought the least in terms of quantity?
select
    p.product_name,
    count(oi.quantity) as cnt
from products p
join order_items oi 
on oi.product_id=p.product_id
group by
     p.product_name
order by
     cnt desc
limit 1;

-- For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

with detail as (select
    p.product_name,
    o.order_id,
    sum(p.price*o.quantity) as Revenue
from products p
inner join order_items o 
on o.product_id=p.product_id
group by 
    p.product_name,
    o.order_id
order by
     Revenue desc)

select
   order_id,
   Revenue,
   case
      when Revenue > 300 then 'Expensive'
      when Revenue between 100 and 300 then 'Affordable'
      else 'Cheap'
      end as Range_group
from detail;

-- Find customers who have ordered the product with the highest price.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    p.price
FROM
    customers c
JOIN
    orders o ON o.customer_id = c.customer_id
JOIN
    order_items oi ON oi.order_id = o.order_id
JOIN
    products p ON p.product_id = oi.product_id
WHERE
    p.price = (
        SELECT MAX(price)
        FROM products
    );


-- What is the avg revenue?

select
    avg(p.price*o.quantity) as median_Revenue
from products p
inner join order_items o 
on o.product_id=p.product_id
inner join orders oi
on oi.order_id=o.order_id
;









