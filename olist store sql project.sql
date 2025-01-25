#     Project Name: Olist Store Analysis

# KPI_1
# 1:Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

use olist_store_analysis;

SELECT 
     CASE WHEN dayofweek(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) 
     IN (1, 7) THEN 'weekend' ELSE 'weekday' END AS daytype,
     count(distinct o.order_id) as totalOrders,
     round(sum(p.payment_value)) as totalPayments,
     round(avg(p.payment_value)) as AveragePayment
      from 
       olist_orders_dataset o
      join 
         order_payments_dataset p on o.order_id = p.order_id
         group by
               daytype;
               
               
#KPI-2
# : Number of Orders with review score 5 and payment type

select 
count(pmt.order_id) as Total_Orders
from order_payments_dataset pmt
inner join
order_reviews_dataset rev on pmt.order_id = rev.order_id
where
rev.review_score = 5
and pmt.payment_type = "credit_card";


## KPI-3
-- 3. Average number of days taken for order_delivered_customer_date for pet_shop
select avg(datediff(order_delivered_customer_date, order_approved_at)) as avg_days 
from olist_orders_dataset 
inner join order_items_dataset
on olist_orders_dataset.order_id= order_items_dataset.order_id
inner join olist_products_dataset 
on order_items_dataset.product_id=olist_products_dataset.product_id 
where product_category_name="pet_shop" ;


## KPI-4
-- 4.Average price and payment values from customers of sao paulo city
select concat('R$',format(avg(price),2)) as avg_price,concat('R$',format(avg(payment_value),2)) as avg_payment_value from order_payments_dataset 
inner join order_items_dataset 
on order_payments_dataset.order_id = order_items_dataset.order_id
inner join olist_orders_dataset 
on order_items_dataset.order_id = olist_orders_dataset.order_id
inner join olist_customers_dataset 
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id 
where customer_city="sao paulo";



## KPI-5
-- 5. Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select order_purchase_timestamp as order_purchase,order_delivered_customer_date as order_deliver,review_score 
from olist_orders_dataset inner join order_reviews_dataset 
on olist_orders_dataset.order_id = order_reviews_dataset.order_id; 

-- using datediff()
select datediff(order_purchase_timestamp ,order_delivered_customer_date) as shipping_days,avg(review_score)
from olist_orders_dataset  join order_reviews_dataset 
on olist_orders_dataset.order_id = order_reviews_dataset.order_id group by shipping_days;


