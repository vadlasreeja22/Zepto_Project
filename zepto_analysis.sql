create database if not exists Zepto_project
  
drop table if exists zepto;
use Zepto_project
  
create table zepto (
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--adding new column id
ALTER TABLE zepto1 ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST ; 

--products in stock vs out of stock
SELECT outOfStock, COUNT(id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(id) > 1
ORDER BY count(id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. Products with High MRP but Out of Stock
SELECT name, mrp
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Calculate Estimated Revenue for each category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Products where MRP > 500 and discount < 10%
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Top 5 categories with highest avg discount
SELECT category,
       ROUND(AVG(discountPercent)) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Price per gram for products >= 100g
SELECT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms  AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7. Group products into weight categories
SELECT name, weightInGms,
       CASE
         WHEN weightInGms < 1000 THEN 'Low'
         WHEN weightInGms < 5000 THEN 'Medium'
         ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8. Total Inventory Weight per Category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
