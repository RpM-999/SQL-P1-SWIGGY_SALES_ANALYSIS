-------------------------------- Data Cleaning ---------------------------------------

USE [Swiggy Database]

-- 1.NULL Check

SELECT
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Total_Null_State,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Total_Null_City
FROM dbo.[swiggy data];