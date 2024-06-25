create database project2;
use project2;
select count(*) from ecommerce_csv;

/*kpi 1*/





SELECT
    CASE 
        WHEN DAYOFWEEK(`olist_orders_dataset.order_purchase_timestamp`) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    SUM(`olist_order_payments_dataset.payment_value`) AS TotalPaymentValue,
    COUNT(*) AS TotalOrders
FROM
    ecommerce_csv
GROUP BY
    CASE 
        WHEN DAYOFWEEK(`olist_orders_dataset.order_purchase_timestamp`) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END;
    
    /*kpi 2*/
    
SELECT 
    COUNT(`olist_orders_dataset.order_id`) AS order_count,
    `olist_order_reviews_dataset.review_score` 
FROM 
    ECOMMERCE_CSV
WHERE 
    `olist_order_reviews_dataset.review_score` = 'CREDIT_CARD'
GROUP BY 
    `olist_order_reviews_dataset.review_score`;

/*kpi3*/

SELECT 
    AVG(Delivery_days) AS Average_delivery_days,
    `olist_products_dataset.product_category_name` AS product_category_name
FROM 
    ecommerce_csv
WHERE 
    `olist_products_dataset.product_category_name` = 'pet_shop'
GROUP BY 
    `olist_products_dataset.product_category_name`;

/*kpi 5*/
SELECT 
    AVG(delivery_days) AS avg_shipping_days,
    `olist_order_reviews_dataset.review_score` AS avg_review_score
FROM 
    ecommerce_csv
GROUP BY 
    `olist_order_reviews_dataset.review_score`;


