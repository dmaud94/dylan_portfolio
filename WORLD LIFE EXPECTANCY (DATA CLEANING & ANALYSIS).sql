# World Life Expectancy Project (Data Cleaning)

SELECT *
FROM world_life_expectancy;

-- ID if there are duplicates 

SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1;

-- Remove the identified duplicates by Row ID
    -- use partition by and row number 
    
SELECT row_id, 
CONCAT(country, year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
FROM world_life_expectancy;


SELECT *
FROM (
	SELECT row_id, 
	CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
	FROM world_life_expectancy
) AS row_table
WHERE row_num >1;

-- Delete Duplicates

DELETE FROM world_life_expectancy
WHERE row_id IN (
	SELECT row_id
FROM (
	SELECT row_id, 
	CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
	FROM world_life_expectancy
) AS row_table
WHERE row_num >1);


-- Identify Blanks and/or Nulls

SELECT *
FROM world_life_expectancy
WHERE status = '';


SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE status <> '';

SELECT DISTINCT(country) 
FROM world_life_expectancy
WHERE status = 'Developing';

UPDATE world_life_expectancy
SET status = 'Developing'
WHERE country IN (
	SELECT DISTINCT(country) 
	FROM world_life_expectancy
	WHERE status = 'Developing'); 
-- QUERY DID NOT WORK!


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = '' AND t2.status <> '' AND t2.status = 'Developing';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = '' AND t2.status <> '' AND t2.status = 'Developed';

SELECT *
FROM world_life_expectancy
WHERE country = 'United States of America';


SELECT *
FROM world_life_expectancy;

-- Life expectancy column also has blanks. Need to address that. 
	-- take average of year after and year before blank values to get an average to input into blank cells

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


SELECT t1.country, t1.year, t1.`Life expectancy`, 
	   t2.country, t2.year, t2.`Life expectancy`,
       t3.country, t3.year, t3.`Life expectancy`,
     ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country 
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country 
    AND t1.year = t3.year + 1
WHERE t1.`life expectancy` = '';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country 
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country 
    AND t1.year = t3.year + 1
SET t1.`life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2,1)
WHERE t1.`life expectancy` = '';


SELECT *
FROM world_life_expectancy;



# PART 2: WORLD LIFE EXPECTANCY (EXPLORATORY DATA ANALYSIS) 

SELECT *
FROM world_life_expectancy;


SELECT country, MIN(`life expectancy`), MAX(`Life expectancy`), 
	   ROUND(MAX(`Life expectancy`) - MIN(`life expectancy`),1) AS life_increase_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`life expectancy`) <> 0 AND MAX(`Life expectancy`)  <> 0
ORDER BY life_increase_15_years ASC;


SELECT year, ROUND(AVG(`life expectancy`), 2)
FROM world_life_expectancy
WHERE `life expectancy` <> 0 AND `Life expectancy` <> 0
GROUP BY year
ORDER BY year;


SELECT country, ROUND(AVG(`life expectancy`),1) AS life_exp, ROUND(AVG(gdp),1) as GDP
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0 AND GDP > 0
ORDER BY GDP DESC;


SELECT 
	SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) HIGH_GDP_COUNT, 
    ROUND(AVG(CASE WHEN GDP >= 1500 THEN `life expectancy` ELSE NULL END),1) HIGH_GDP_life_expectancy,
    SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) LOW_GDP_COUNT, 
    ROUND(AVG(CASE WHEN GDP <= 1500 THEN `life expectancy` ELSE NULL END),1) LOW_GDP_life_expectancy
FROM world_life_expectancy;


SELECT status, ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;

SELECT status, COUNT(DISTINCT country), ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;


SELECT country, ROUND(AVG(`life expectancy`),1) AS life_exp, ROUND(AVG(BMI),1) as BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_exp > 0 AND BMI > 0
ORDER BY BMI ASC;


SELECT country, year, `Life expectancy`, `Adult mortality`,
	   SUM(`Adult mortality`) OVER(PARTITION BY country ORDER BY year) AS rolling_total
FROM world_life_expectancy
WHERE country LIKE '%United%';




























