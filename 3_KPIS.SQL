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

--6. Orders per Month

--7. Revenue by Month (Base for Growth Metrics)

--8. Month-over-Month (MoM) Revenue Growth %

--9. Quarter-over-Quarter (QoQ) Revenue Growth %

--10. Year-over-Year (YoY) Revenue Growth %

--11. 
--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------
