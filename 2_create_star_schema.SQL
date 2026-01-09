--------------------------------------------------------------------- Building Schema -----------------------------------------------------------------

USE [Swiggy Database]

--------------------------------------------------------------------- Dimention Tables ----------------------------------------------------------------


-- 1. Dimention Date Table

CREATE TABLE Dim_Date(
    date_ID INT IDENTITY(1,1) PRIMARY KEY,
    full_date DATE,
    day INT,
    week INT,
    month INT,
    quater INT,
    year INT,
    month_name VARCHAR(20)
)

SELECT *
FROM dbo.[Dim_Date];


-- 2. Dimention Location Table

CREATE TABLE Dim_Location(
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    state VARCHAR(100),
    city VARCHAR(100),
    location VARCHAR(200)
)

SELECT *
FROM dbo.[Dim_Location];


-- 3. Dimention Restaurent Table


CREATE TABLE Dim_Restaurant(
    restaurant_ID INT IDENTITY(1,1) PRIMARY KEY,
    restaurent_name VARCHAR(300)
    )

SELECT *
FROM dbo.[Dim_Restaurant]


-- 4. Dimention Category

CREATE TABLE Dim_Catagory(
    catagory_ID INT IDENTITY(1,1) PRIMARY KEY,
    catagory VARCHAR(200)
)

SELECT *
FROM dbo.[Dim_Catagory]



-- 5. Dimention Dish Table

CREATE TABLE Dim_Dish(
    diah_ID INT IDENTITY(1,1) PRIMARY KEY,
    dish_name VARCHAR(200)
)

SELECT *
FROM dbo.[Dim_Dish]

--------------------------------------------------------------------- Fact Table ----------------------------------------------------------------

--1.  Fact Order Table

CREATE TABLE Fact_Order(
    order_ID INT IDENTITY(1,1) PRIMARY KEY,

    date_ID INT,
    location_ID INT,
    restaurent_ID INT,
    catagory_ID INT,
    dish_ID INT,

    price_INR DECIMAL(10,2),
    rating DECIMAL(4,2),
    Rating_Count INT,

    FOREIGN KEY (date_ID) REFERENCES Dim_Date(date_ID),
    FOREIGN KEY (location_ID) REFERENCES Dim_Location(location_ID),
    FOREIGN KEY (restaurent_ID) REFERENCES Dim_Restaurant(restaurant_ID),
    FOREIGN KEY (catagory_ID) REFERENCES Dim_Catagory(catagory_ID),
    FOREIGN KEY (dish_ID) REFERENCES Dim_Dish(dish_ID)
)

SELECT *
FROM [swiggy data]


EXEC sp_rename 
    'Fact_Order.Rating_Count',                    --      Rename Rating_Count --> rating_count
    'rating_count',
    'COLUMN';


SELECT *
FROM Fact_Order;


---------------------------------------------------------------------Inset Data Into Dimention Tables --------------------------------------


-- 1. Inset Data Into Dim_Date

INSERT INTO Dim_Date(
    full_date,
    day,
    week,
    month,
    quater,
    year,
    month_name 
)

SELECT DISTINCT
    Order_Date,
    DAY(Order_Date),
    DATEPART(WEEK,Order_Date),
    MONTH(Order_Date),
    DATEPART(QUARTER,Order_Date),
    YEAR(Order_Date),
    DATENAME(MONTH,Order_Date)
FROM dbo.[swiggy data]
WHERE Order_Date IS NOT NULL;

--

SELECT *
FROM dbo.[Dim_Date]

DELETE FROM Dim_Date;

-- 2. Inset Data Into Dim_Location

INSERT INTO Dim_Location(
    state,
    city,
    location
)

SELECT DISTINCT
    State,
    City,
    Location
FROM dbo.[swiggy data];

--

SELECT TOP 10 *
FROM dbo.[Dim_Location]


-- 3. Inset Data Into Dim_Restaurant

INSERT INTO Dim_Restaurant(
    restaurent_name
)

SELECT DISTINCT
    Restaurant_Name
FROM dbo.[swiggy data];

--

SELECT TOP 10 *
FROM dbo.[Dim_Restaurant]



-- 4. Inset Data Into Dim_Restaurant

INSERT INTO Dim_Catagory(
    catagory
)

SELECT DISTINCT
    Category
FROM dbo.[swiggy data];

--

SELECT TOP 10 *
FROM dbo.[Dim_Catagory]



-- 5. Inset Data Into Dim_Dish

INSERT INTO Dim_Dish(
    dish_name
)

SELECT DISTINCT
    Dish_Name
FROM dbo.[swiggy data];

--

SELECT TOP 10 *
FROM dbo.[Dim_Dish]


-- 5. Inset Data Into Fact_Order

INSERT INTO Fact_Order(
    date_ID,
    location_ID,
    restaurent_ID,
    catagory_ID,
    dish_ID,
    price_INR,
    rating,
    rating_count
)
SELECT DISTINCT 
    dd.[date_ID],
    dl.[location_ID],
    dr.[restaurant_ID],
    dc.[catagory_ID],
    dds.[dish_ID],
    s.[Price_INR],
    s.[Rating],
    s.[Rating_Count]
FROM 
    dbo.[swiggy data] s

    JOIN Dim_Date dd 
    ON
    dd.[full_date] = s.[Order_Date]


    JOIN Dim_Location dl 
    ON
    dl.[state] = s.[State] 
    AND 
    dl.[city] = s.[City] 
    AND 
    dl.[location] = s.[Location]

    JOIN Dim_Restaurant dr  
    ON
    dr.[restaurent_name] = s.[Restaurant_Name]

    JOIN Dim_Catagory dc  
    ON
    dc.[catagory] = s.[Category]

    JOIN Dim_Dish dds
    ON
    dds.[dish_name] = s.[Dish_Name]


