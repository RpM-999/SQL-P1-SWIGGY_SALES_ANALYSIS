--------------------------------- Data Cleaning ---------------------------------------

USE [Swiggy Database]

-- 1.NULL Check


SELECT
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Total_Null_State,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Total_Null_City,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Total_Null_Order,
    SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) AS Total_Null_Restaurent,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS Total_Null_Location,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Total_Null_Category,
    SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS Total_Null_DiahName,
    SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS Total_Null_Price,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Total_Null_Rating,
    SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS Total_Null_RatingCount
FROM dbo.[swiggy data];


-- 2. Check Empty String

SELECT *
FROM dbo.[swiggy data]
WHERE
    State = '' OR
    City ='' OR
    Restaurant_Name = '' OR
    Location = '' OR
    Category = '' OR
    Dish_Name = '' 
   ; 


-- 3. Check Duplicates 

SELECT
    State,
    City,
    Order_Date,
    Restaurant_Name,
    Location,
    Category,
    Dish_Name,
    Price_INR,
    Rating,
    Rating_Count,
    COUNT(*) AS CNT 
FROM dbo.[swiggy data]
GROUP BY State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR,Rating, Rating_Count
HAVING COUNT(*)>1;


-- 4. Delete Duplication

WITH CTE AS (
    SELECT * ,
    ROW_NUMBER() OVER(PARTITION BY State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR,Rating, Rating_Count ORDER BY (SELECT NULL)) AS RNK
    FROM dbo.[swiggy data]
    )

DELETE FROM CTE
WHERE RNK>1;

SELECT *
FROM [swiggy data]