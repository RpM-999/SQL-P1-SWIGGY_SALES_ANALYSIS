--------------------------------------------------------------- KPI's ----------------------------------------------------------------------


USE [Swiggy Database]


--------------------------------------------------------------------------------------------------------------------------------------------


-- 1. Total Oder 

SELECT COUNT(*) AS Total_Orders
FROM dbo.[Fact_Order]


-- 2. Total Revenew in ₹-M (GMV = Gross Merchandise Value)

SELECT 
    FORMAT(SUM(CONVERT(float,price_INR))/1000000,'N2')  + ' INR Mill.' AS Total_Revenew_in_Mill
FROM dbo.[Fact_Order]


-- 3. Average Order Value (AOV)

SELECT
    (SUM(Price_INR)*1.0 / COUNT(DISTINCT Order_ID)) AS AVG_Order_Value
FROM dbo.[Fact_Order]


-- 4. Orders per Day

SELECT
    d.full_date,
    COUNT(DISTINCT f.order_ID)
FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d 
    ON
    f.date_ID = d.date_ID
GROUP BY d.full_date
ORDER BY d.full_date


--5. Orders per Quarter

SELECT
    d.[year],
    d.[quater],
    COUNT(DISTINCT f.order_ID) AS order_per_quater
FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d
    ON
    f.date_ID = d.date_ID
GROUP BY d.[year],d.[quater]
ORDER BY d.[year],d.[quater]


--6. Orders per Month

SELECT
    d.[year],
    d.[month],
    COUNT(DISTINCT f.order_ID) AS order_per_month
FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d
    ON
    f.date_ID = d.date_ID
GROUP BY d.[year],d.[month]
ORDER BY d.[year],d.[month]


--7. Revenue by Month (Base for Growth Metrics)

SELECT
    d.[year],
    d.[month],
    FORMAT(SUM(CONVERT(float,f.price_INR))/1000000,'N2')+ ' M' AS Revenew_per_Month_in_Million
FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d
    ON f.date_ID = d.date_ID
GROUP BY d.[year],d.[month]
ORDER BY d.[year],d.[month]


--8. Month-over-Month (MoM) Revenue Growth %

WITH Monthly_Revenue AS (
    SELECT
        d.[year],
        d.[month],
        SUM(f.[Price_INR]) AS revenue
    FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d
        ON f.Date_ID = d.Date_ID
    GROUP BY d.[year], d.[month]
)

SELECT
    [year],
    [month],
    [revenue],
    LAG(revenue) OVER(ORDER BY [year],[month]) AS prev_revenew,
    (revenue-LAG(revenue) OVER(ORDER BY [year],[month]))*100/LAG(revenue) OVER(ORDER BY [year],[month]) AS monthly_groth_in_pct
FROM Monthly_Revenue
ORDER BY[year],[month]


--9. Quarter-over-Quarter (QoQ) Revenue Growth %

WITH Quaterly_curr_Revenue AS (
    SELECT
        d.[year],
        d.[quater],
        SUM(f.[Price_INR]) AS curr_revenue
    FROM dbo.[Fact_Order] f
    JOIN dbo.[Dim_Date] d
        ON f.Date_ID = d.Date_ID
    GROUP BY d.[year], d.[quater]
),
Quaterly_prev_Revenue AS(
    SELECT
        [year],
        [quater],
        curr_revenue,
        LAG(curr_revenue) OVER(ORDER BY [year],[quater]) AS prev_revenew
    FROM Quaterly_curr_Revenue
)
SELECT
    [year],
    [quater],
    [curr_revenue],
    [prev_revenew],
    ([curr_revenue]-[prev_revenew])*100.0/[prev_revenew] AS quaterly_growth
FROM Quaterly_prev_Revenue


--10. Year-over-Year (YoY) Revenue Growth %

-- There is only 1 year 2025 , no need to  calculate YoY

----------------------------------------------------------------Location Performance KPIs---------------------------------------------------

--1. Orders by Location (State / City)

SELECT 
    l.[state],
    l.[city],
    COUNT(DISTINCT f.Order_ID) AS total_orders
FROM dbo.[Fact_Order] f
JOIN dbo.[Dim_Location] l
ON f.[location_ID] = l.[location_ID]
GROUP BY L.[state],L.[city]
ORDER BY total_orders DESC


--2. Revenue by State / City


SELECT 
    l.[state],
    l.[city],
     FORMAT(SUM(CONVERT(float,f.price_INR))/1000000,'N2')+ ' M'AS revenue_per_state_city
FROM dbo.[Fact_Order] f
JOIN dbo.[Dim_Location] l
ON f.[location_ID] = l.[location_ID]
GROUP BY L.[state],L.[city]
ORDER BY revenue_per_state_city DESC


--3. Average Order Value (AOV) by Location

SELECT 
    l.[state],
    l.[city],
    SUM(f.price_INR)/COUNT(DISTINCT f.Order_ID) AS avg_order_value_by_location
FROM dbo.[Fact_Order] f
JOIN dbo.[Dim_Location] l
ON f.[location_ID] = l.[location_ID]
GROUP BY l.[state],l.[city]
ORDER BY avg_order_value_by_location DESC

--4. Location Revenue Contribution %


WITH Location_Revenue AS (
    SELECT
        l.State,
        l.City,
        SUM(f.Price_INR) AS revenue
    FROM dbo.Fact_Order f
    JOIN dbo.Dim_Location l
        ON f.Location_ID = l.Location_ID
    GROUP BY l.State, l.City
),

Total_Revenue AS (
    SELECT SUM(revenue) AS total_revenue
    FROM Location_Revenue
)

SELECT
    lr.State,
    lr.City,
    lr.revenue,
    lr.revenue * 100.0 / tr.total_revenue AS revenue_contribution_pct
FROM Location_Revenue lr
CROSS JOIN Total_Revenue tr
ORDER BY revenue_contribution_pct DESC;


--5. 
--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------
