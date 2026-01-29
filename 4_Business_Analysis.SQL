
------------------------------------------------Business Analysis-------------------------------------------

USE [Swiggy Database]

-- 1. Which cities consistently outperform and deserve expansion budget?



SELECT 
    l.city,
    SUM(f.price_INR) AS total_revenue,
    COUNT(DISTINCT d.[month]) AS active_months,
    SUM(f.price_INR) * 1.0 / COUNT(DISTINCT f.order_ID) AS avg_order_value
FROM dbo.Fact_Order f
JOIN dbo.Dim_Location l 
    ON f.location_ID = l.location_ID
JOIN dbo.Dim_Date d 
    ON f.date_ID = d.date_ID
GROUP BY l.city
HAVING COUNT(DISTINCT d.[month]) >= 6
ORDER BY total_revenue DESC;


-- 2. Are we over-dependent on a few restaurants?

SELECT
    r.restaurent_name,
    SUM(f.price_INR) AS restaurant_revenue,
    ROUND(
        SUM(f.price_INR) * 100.0 /
        SUM(SUM(f.price_INR)) OVER (), 2
    ) AS revenue_contribution_pct
FROM dbo.Fact_Order f
JOIN dbo.Dim_Restaurant r
    ON f.restaurent_ID = r.restaurant_ID
GROUP BY r.restaurent_name
ORDER BY revenue_contribution_pct DESC;



-- 3. Which dishes are overpriced for demand?

SELECT
    d.dish_name,
    AVG(f.price_INR) AS avg_price,
    COUNT(DISTINCT f.order_ID) AS total_orders
FROM dbo.Fact_Order f
JOIN dbo.Dim_Dish d
    ON f.dish_ID = d.dish_ID
GROUP BY d.dish_name
HAVING COUNT(DISTINCT f.order_ID) <
       (
           SELECT AVG(order_cnt)
           FROM (
               SELECT COUNT(DISTINCT order_ID) AS order_cnt
               FROM dbo.Fact_Order
               GROUP BY dish_ID
           ) x
       )
ORDER BY avg_price DESC;



-- 4. When should operations scale up or down?

SELECT
    d.[year],
    d.[month],
    COUNT(DISTINCT f.order_ID) AS total_orders,
    SUM(f.price_INR) AS total_revenue
FROM dbo.Fact_Order f
JOIN dbo.Dim_Date d
    ON f.date_ID = d.date_ID
GROUP BY d.[year], d.[month]
ORDER BY d.[year], d.[month];


-- 5. Weekend vs Weekday Behavior

SELECT
    CASE 
        WHEN d.day IN (6,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT f.order_ID) AS total_orders,
    SUM(f.price_INR) * 1.0 / COUNT(DISTINCT f.order_ID) AS avg_order_value
FROM dbo.Fact_Order f
JOIN dbo.Dim_Date d
    ON f.date_ID = d.date_ID
GROUP BY 
    CASE 
        WHEN d.day IN (6,7) THEN 'Weekend'
        ELSE 'Weekday'
    END;

