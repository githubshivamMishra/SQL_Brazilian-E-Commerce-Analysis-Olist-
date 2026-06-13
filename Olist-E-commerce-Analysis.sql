drop database if exists olist

CREATE database olist_ecommerce;

use olist_ecommerce;

create table customer(
	customer_id	varchar(40) primary key,
	customer_unique_id	varchar(40),
	customer_zip_code_prefix int,
	customer_city varchar(40),
	customer_state varchar(5)
);

create table geolocation (
	geolocation_zip_code_prefix int	,
	geolocation_lat	decimal(10,8),
	geolocation_lng	decimal(11,8),
	geolocation_city varchar(80),
	geolocation_state varchar(5)
);

create table prodcategory(
	product_category_name varchar(50),
	product_category_name_english varchar(40)
);

drop table if exists  product
create table product(
	product_id	varchar(40) primary key,
	product_category_name varchar(50),
	product_name_lenght	int,
	product_description_lenght	int,
	product_photos_qty	int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);

create table seller (
	seller_id	varchar(40) primary key,
	seller_zip_code_prefix	int,
	seller_city	varchar(50),
	seller_state varchar(5)
);

create table orders(
	order_id varchar(40) primary key,
	customer_id	varchar(40),  -- fk
	order_status varchar(20),
	order_purchase_timestamp varchar(30),	
	order_approved_at varchar(30),
	order_delivered_carrier_date varchar(30),	
	order_delivered_customer_date varchar(30),
	order_estimated_delivery_date varchar(30)
);

create table orderitem(
	order_id varchar(40), -- fk
	order_item_id int,
	product_id varchar(40), -- fk 
	seller_id varchar(40), -- fk
	shipping_limit_date	varchar(30),
	price	float,
	freight_value float
);

create table orderpayment(
	order_id varchar(40),-- fk
	payment_sequential	int,
	payment_type varchar(20),
	payment_installments int,
	payment_value float
);

create table orderreview(
	review_id varchar(40),
	order_id varchar(40),-- fk
	review_score int,
	review_comment_title varchar(300),
	review_comment_message	varchar(700),
	review_creation_date	varchar(30),
	review_answer_timestamp varchar(30)
);

show columns from orders

UPDATE orders
SET order_purchase_timestamp =
STR_TO_DATE(
    REPLACE(REPLACE(order_purchase_timestamp,'A.M','AM'),'P.M','PM'),
    '%d/%m/%y %h:%i:%s %p');

select 
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date,
	shipping_limit_date
from orders


-- updating orders table

ALTER TABLE orders
MODIFY COLUMN order_purchase_timestamp DATETIME,
MODIFY COLUMN order_approved_at DATETIME,
MODIFY COLUMN order_delivered_carrier_date DATETIME,
MODIFY COLUMN order_delivered_customer_date DATETIME,
MODIFY COLUMN order_estimated_delivery_date DATETIME;

UPDATE orders
SET order_approved_at = NULL
WHERE order_approved_at = '';

UPDATE orders
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date = '';

UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

UPDATE orders
SET order_estimated_delivery_date = NULL
WHERE order_estimated_delivery_date = '';

UPDATE orders
SET shipping_limit_date = NULL
WHERE shipping_limit_date = '';

ALTER TABLE orders
MODIFY COLUMN shipping_limit_date DATETIME;



-- updating review table
show columns from orderreview

select * 
from orderreview

-- review_creation_date 
-- review_answer_timestamp

ALTER TABLE orderreview
MODIFY COLUMN review_creation_date DATETIME,
MODIFY COLUMN review_answer_timestamp DATETIME;

show columns from orderreview

-- adding foreign key 

-- customer->order

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

-- orders ->orderitem

alter table orderitem 
add constraint fk_order_id
foreign key (order_id)
references orders(order_id);

-- orders-> orderpayment

alter table orderpayment 
add constraint fk_orders
foreign key (order_id)	
references orders(order_id);

-- orders ->orderreview

alter table orderreview 
add constraint fk_order_review
foreign key (order_id)
references orders(order_id);

-- orderitem->product

alter table orderitem 
add constraint fk_prod_id
foreign key (product_id)
references product(product_id);

-- orderitem ->seller

alter table orderitem 
add constraint fk_seller_id
foreign key (seller_id)
references seller(seller_id);

-- adding primary key 

alter table prodcategory 
add primary key (product_category_name);

-- prodcategory-product

alter table product
add constraint fk_prod_cat
foreign key (product_category_name)
references prodcategory(product_category_name);

-- below code description:in prodcategory table we have uniques product category 
-- and in product table 2 records are extra which is not in prodcategory table so we did bla bla ..

/*with cte as (
select product_category_name
from product
where product_category_name not in (
select 
	product_category_name
from prodcategory)
and product_category_name !=''
)

select 
	product_category_name,
	count(*) as cnt
from cte 
group by 1

update product
set product_category_name=NULL 
where product_category_name=''

-- portateis_cozinha_e_preparadores_de_alimentos-unknow_category_2
-- pc_gamer-unknow_category_1

INSERT INTO prodcategory
VALUES ('unknown_category_1', 'Unknown'),
       ('unknown_category_2', 'Unknown');

select product_category_name,
count(*)
from prodcategory
group by 1

update product
set product_category_name='unknown_category_1'
where product_category_name='pc_gamer';


update product
set product_category_name='unknown_category_2'
where product_category_name='portateis_cozinha_e_preparadores_de_alimentos';

show create table product
*/


select * from customer;
select * from geolocation;
select * from orderitem;
select * from orderpayment;
select * from orderreview;
select * from orders;
select * from prodcategory;
select * from product;
select * from seller;

/*
-- 🧠 📊 50 BUSINESS SQL QUESTIONS (Olist Project)
 */

 🟢 BASIC (1–15)
-- 1.Total number of customers in the dataset
 
 select count(*) as customer_cnt 
 from customer;
 
-- 2.Total number of orders placed

 select count(*)  as total_order
 from orders;
 
-- 3.Count of orders by order status

 select 
 	order_status,
 	count(*) as staus_cnt
 from orders
 group by 1;
 
-- 4.Number of unique products

 select 
 	count(distinct product_id) as total_prod
 from product;
 
 or 
 
  select 
 	count(distinct product_category_name) as total_prod
 from product;
 
-- 5.Number of unique sellers

 select 
 	count(*) as uniques_seller
 from seller;
 
-- 6.Number of product categories

 select 
 	count(distinct product_category_name) as total_prod
 from product;
 
-- 7.Top 10 cities with most customers

select
	customer_city,
	count(*) as cntbycity
from customer
group by 1 
order by cntbycity desc
limit 10 ;

-- 8.Top 10 states with most customers

select
	customer_state,
	count(*) as cntbystate
from customer
group by 1 
order by cntbystate desc
limit 10;

-- 9.Orders placed per month
show columns  from orders

select 
	year(order_purchase_timestamp),
	month(order_purchase_timestamp),
	count(*) as cntbymnt
from orders
group by 1,2
order by 1,2;

-- 10.Orders placed per year

select 
	year(order_purchase_timestamp),
	count(*) as cnt
from orders 
group by 1;

-- 11.Number of delivered orders

select count(*) as deliveredno
from orders
where order_Status='delivered';

-- 12.Number of cancelled orders

select count(*) as canceledno
from orders
where order_Status='canceled';

-- 13.Number of processing orders

select count(*) as processingno
from orders
where order_Status='processing';

select
	order_status,
	count(*) 
from orders
group by order_status

-- 14.Average order per customer

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer
FROM customer_orders;

-- 15.Total revenue (sum of payment_value)

select 
	sum(payment_value) as toal_revenue
from orderpayment;

-- 🟡 INTERMEDIATE (16–30)
-- 1.Top 10 customers by total spend-- 
select 
	c.customer_unique_id,
	sum(op.payment_value) as totalspend
from customer c
join orders o
	on c.customer_id=o.customer_id
join orderpayment op
	on op.order_id=o.order_id
group by 1
order by totalspend desc 
limit 10
	
-- 2.Top 10 sellers by number of orders
select 
	seller_id,
	count(distinct order_id) as cnt
from orderitem
group by 1
order by 2 DESC 
limit 10

-- ok3.Top 10 products by sales volume

select 
	product_id,
	count(order_id) as cnt
from orderitem
group by 1
order by 2 desc 
limit 10

-- 4.Most popular product category-- 

SELECT
    p.product_category_name,
    COUNT(oi.order_id) AS total_sales
FROM product p
JOIN orderitem oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_sales DESC
LIMIT 1;

-- 5.Category-wise total revenue--need to check 

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value),2) AS revenue
FROM product p
JOIN orderitem oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- 6.Average freight value per order

select 
	order_id,
	avg(freight_value)
from orderitem
group by 1

-- ok7.Payment type distribution (credit card, boleto, etc.)

select 
	payment_type,
	SUM(payment_value) as amountbytype
from orderpayment
group by 1
order by amountbytype desc

-- 8.Most used payment type

select 
	payment_type,
	count(*) as total_transaction
from orderpayment
group by 1
order by ptype desc
limit 1


-- ok9.Average payment installments

select 
	avg(payment_installments)
from orderpayment


-- 10.Monthly revenue trend

select 
	Year(o.order_delivered_customer_date) as yrs,
	Month(o.order_delivered_customer_date) as mnths,
	sum(op.payment_value)
from orders o 
join orderpayment op
	on o.order_id=op.order_id	
Group by 1,2
order by 1,2

-- ok11.-State-wise revenue

select 
	c.customer_state,
	sum(op.payment_value) as revenue
from customer c 
join orders o 
 	on c.customer_id=o.customer_id
join orderpayment op 
 	on o.order_id=op.order_id
group by 1

-- ok12.City-wise revenue

select 
	c.customer_city,
	sum(op.payment_value) as revenue
from customer c 
join orders o 
 	on c.customer_id=o.customer_id
join orderpayment op 
 	on o.order_id=op.order_id
group by 1

-- 13.Orders with delayed delivery

SELECT *
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;

-- ok14.Average delivery time (purchase → delivered)

SELECT
    AVG(
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 15.Average approval time (purchase → approved)

SELECT
    AVG(
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_approved_at
        )
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL; -- Average time taken to approve an order after purchase

🔵 ADVANCED (31–45)
-- Customer lifetime value (CLV)
-- **important point -customer_id in both table customer and orders are unique customer_id means u cant get duplicay 
-- so use customer_unique_id column to solve this type of questions**

select 
	c.customer_unique_id,
	sum(op.payment_value) as CLV
from customer c 
join orders o 
	on c.customer_id=o.customer_id
join orderpayment op
	on o.order_id=op.order_id
group by 1
order by 2 desc;


-- Repeat customers (customers with >1 order)

SELECT 
	c.customer_unique_id,
	count(o.order_id) as cnt
from customer c 
join orders o
	on c.customer_id=o.customer_id
group by 1
having count(o.order_id)>1

	
-- Retention rate of customers
-- means in first month we got 10 customer and in feb month how many january customer we get in feb --Jan customer in feb month 	

with customer_month as (
	select  DISTINCT 
		c.customer_unique_id,
		Date_format(order_purchase_timestamp,'%Y-%m-01') as order_month
	from customer c
	join orders o 
		on c.customer_id=o.customer_id
),
retention_customer as (
	select 
		cm1.order_month ,
		count(distinct cm2.customer_unique_id)  as retention_cust,
		count(distinct cm1.customer_unique_id) as total_cust
	from customer_month cm1 
	left join customer_month cm2
		on cm1.customer_unique_id =cm2.customer_unique_id
		and cm2.order_month=DATE_ADD(cm1.order_month, interval 1 Month)
	group by 1	
)

select 
	order_month,
	total_cust,
	retention_cust,
	round(retention_cust*100.0/(total_cust),2) as retention_pct
from retention_customer
order by order_month
	
-- First purchase vs repeat purchase comparison

with purchase_rank as(
		select 
			c.customer_unique_id,
			o.order_id,
			op.payment_value,
			row_number() over(partition by customer_unique_id
							  order by order_purchase_timestamp) as rnk
		from customer c
		join orders o 
			on c.customer_id=o.customer_id
		join orderpayment op 
		on o.order_id=op.order_id
)

select 
	CASE 
		when rnk=1 then 'First Purchase'
		else 'Repeat Purchase'
	END as Purchase_category,
	count(*) as total_order,
	sum(payment_value) as total_revenue,
	round(avg(payment_value),2) as avg_revenue
from purchase_rank
group by 1

-- Analysis revealed that the majority of revenue was generated from first-time purchases (~15.25M), 
-- while repeat purchases contributed less than 1M. Additionally, repeat orders had a lower average order value (97.22 vs 158.71), 
-- indicating opportunities to improve customer retention and post-purchase engagement.

-- Monthly active customers

select 
	DATE_FORMAT(o.order_purchase_timestamp , '%Y-%m') as order_month ,
	count(distinct c.customer_unique_id)
from customer c 
join orders o 
 	on c.customer_id=o.customer_id
group by 1
order by 1
 	

-- Average order value (AOV)

select 
	round(sum(payment_value)/count(distinct order_id),2)  as revenue
from orderpayment

or

SELECT
    ROUND(AVG(order_revenue),2) AS AOV
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS order_revenue
    FROM orderpayment
    GROUP BY order_id
) t;

-- Revenue contribution of top 20% customers

with cte as (
	select 
		c.customer_unique_id,
		sum(op.payment_value) as revenue
	from customer c
	join orders o 
		on c.customer_id=o.customer_id
	join orderpayment op 
		on op.order_id=o.order_id	
	group by 1	
)
,ranked_customer as (
	select 
		customer_unique_id,
		revenue,
		row_number()over(order by revenue desc) as rnk,
		count(*) over()as total_customer
	from cte 
)

select 
	round(
		sum(CASE 
			when rnk <= 0.20* total_customer then revenue 
			else 0
			END)* 100.0 
			/sum(revenue),2)  as top20pctcustomer
from ranked_customer

or 

WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS revenue
    FROM customer c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN orderpayment op
        ON op.order_id = o.order_id
    GROUP BY c.customer_unique_id
),
customer_bucket AS (
    SELECT
        customer_unique_id,
        revenue,
        NTILE(5) OVER (ORDER BY revenue DESC) AS bucket
    FROM customer_revenue
)

SELECT
    ROUND(
        SUM(CASE WHEN bucket = 1 THEN revenue ELSE 0 END)
        * 100.0 /
        SUM(revenue),
        2
    ) AS top20pct_revenue_contribution
FROM customer_bucket;


-- The top 20% of customers contributed 53.77% of total revenue,
-- indicating moderate revenue concentration among high-value customers, 
-- though the dataset does not strictly follow the classic 80/20 Pareto distribution.


-- Pareto analysis (80/20 rule)
-- >Pareto analysis revealed that the top 20% of customers contributed 53.77% of total revenue, 
-- >indicating moderate customer revenue concentration and the presence of high-value customer segments.

-- Sellers with highest cancellation rate

with totalorders as (
	select 
		s.seller_id,
		count(distinct oi.order_id) as totalorder
	from seller s
	join orderitem oi
		on s.seller_id=oi.seller_id
	join orders o 
		on o.order_id=oi.order_id
	group by 1	
)
,
canceledorders as (
	select 
		s.seller_id,
		count(distinct o.order_id) as canceledorder
	from seller s
	join orderitem oi 
		on s.seller_id=oi.seller_id
	join orders o
		on o.order_id=oi.order_id
	where o.order_status='canceled'
	group by 1	
)
, ranked as 
	(select 
		cs.seller_id,
		cs.canceledorder,
		ts.totalorder,
		round(cs.canceledorder *100.0/ts.totalorder,2) as seller_cancellation_rate,
		rank()over(order by cs.canceledorder *100.0/ts.totalorder desc ) as rnk
	from canceledorders cs
	join totalorders ts
		on cs.seller_id =ts.seller_id 
)		

select * 
from ranked 
where rnk=1

-- Products never sold
SELECT 
    p.product_id
FROM product p
LEFT JOIN orderitem oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
or 
SELECT 
    p.product_id
FROM product p
WHERE NOT EXISTS (
    SELECT 1
    FROM orderitem oi
    WHERE oi.product_id = p.product_id
);
-- Product catalog ≈ Product sold universe

-- Category with highest return/cancellation

with return_orders as (
	select 
		p.product_category_name,
		
		count(distinct o.order_id) as total_orders ,
		
		sum(CASE when o.order_status='return' THEN  1 else 0 
			end) as returned_orders,
			
		sum(CASE when o.order_status='canceled' THEN  1 else 0 
			end) as canceled_orders
	from product p
	join orderitem oi
		on p.product_id = oi.product_id
	join orders o
		on o.order_id=oi.order_id
	group by 1	
)
,category_rate AS (
    SELECT *,
        (canceled_orders + returned_orders) AS bad_orders,
        ROUND(
            (canceled_orders + returned_orders) * 100.0 / NULLIF(total_orders,0),
            2
        ) AS bad_order_rate
    FROM return_orders
)

SELECT *
FROM category_rate
ORDER BY bad_order_rate DESC;

	
-- Orders with multiple sellers

select 
	 order_id,
	count(distinct seller_id)
from orderitem
group by 1
having count(distinct seller_id)>1

-- Delivery performance by state --avg 

select 
	c.customer_state,
	round(avg(
		timestampdiff(Day,o.order_purchase_timestamp,o.order_delivered_customer_date)),2) as avg_delv
from customer c
join orders o 
 	on c.customer_id=o.customer_id
where order_delivered_customer_date	is not null
group by 1 

-- Late delivery percentage

with late_orders as (
select 
	order_id,
	(case 
		when order_delivered_customer_date>order_estimated_delivery_date then 1 else 0
	end) as late_order
from orders
)

select  
	(sum(l.late_order)*100.0/count(o.order_id)) as late_deliv_pct
from late_orders l
join orders o
	on l.order_id=o.order_id	
	
-- Late orders kitne din late the?	
	
select 
	avg(timestampdiff(Day,order_estimated_delivery_date,order_delivered_customer_date))
from orders 
where order_delivered_customer_date>order_estimated_delivery_date

-- "Approximately 8% of delivered orders were delivered after the estimated delivery date, 
-- indicating that the logistics network met delivery commitments for about 92% of orders."	

-- Shipping delay impact on review score,Average rating of delayed vs on-time orders

with delay_order as (
	select 
		order_id,
		(case 
			when order_delivered_customer_date>order_estimated_delivery_date then 'Late Delivery' else 'Early Delivery'
		end) as delivery_status
	from orders
	WHERE order_delivered_customer_date IS NOT NULL
	)
	
SELECT
    d.delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM delay_order d
JOIN orderreview r
    ON d.order_id = r.order_id
GROUP BY d.delivery_status;


