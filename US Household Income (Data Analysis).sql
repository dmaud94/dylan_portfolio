# US Household Income (Data Cleaning)

SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;


SELECT id, COUNT(id)
FROM us_Project.us_household_income
GROUP BY id
HAVING COUNT(id) >1;


SELECT *
FROM (
SELECT row_id,
id, 
row_number() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income) duplicates
WHERE row_num > 1;


DELETE FROM us_project.us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
        ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
        FROM us_project.us_household_income) duplicates
WHERE row_num > 1)
;


SELECT DISTINCT state_name
FROM us_Project.us_household_income_statistics
GROUP BY state_name
ORDER BY 1;


UPDATE us_Project.us_household_income_statistics
SET state_name = 'Georgia'
WHERE state_name = 'georia';

UPDATE us_Project.us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia';

UPDATE us_Project.us_household_income_statistics
SET state_name = 'Alabama'
WHERE state_name = 'alabama';


SELECT *
FROM us_Project.us_household_income
WHERE county = 'Autauga County'
ORDER BY 1;


UPDATE us_project.us_household_income
SET place = 'Autaugaville' 
WHERE county = 'Autauga County'
AND city = 'Vinemont';


SELECT type, COUNT(TYPE)
FROM us_Project.us_household_income
GROUP BY type;


UPDATE us_Project.us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';


SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand = NULL);



# US Household Income (Exploratory Data Analysis)


SELECT state_name, county, city, ALand, AWater
FROM us_project.us_household_income;


SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 2 DESC; 


SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY state_name
ORDER BY 3 DESC
LIMIT 10;


SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;


SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id;
    

SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0;


SELECT u.state_name, county, `type`, `primary`, mean, median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0;

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 3 DESC
LIMIT 10;


SELECT `type`, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE mean <> 0
GROUP BY `type`
HAVING COUNT(type) > 100
ORDER BY 4 DESC
LIMIT 20;


SELECT *
FROM us_project.us_household_income
WHERE type = 'community';


SELECT u.state_name, city, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
GROUP BY u.state_name, city
ORDER BY 4 DESC;


    

    


















































