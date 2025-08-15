USE wine;

SHOW FULL TABLES;

SELECT COUNT(DISTINCT(country)) FROM main;

-- Average price/l per type
SELECT t.type_name AS type, 
	ROUND(AVG(price/capacity_liter), 2) AS l_price 
FROM main AS m
JOIN type AS t
	ON m.type_id = t.type_id
WHERE t.type_name != 'brown'
GROUP BY t.type_name;

-- Average price/l per closure
SELECT c.closure_name AS type, 
	ROUND(AVG(price/capacity_liter), 2) AS l_price 
FROM main AS m
JOIN closure AS c
	ON m.closure_id = c.closure_id
GROUP BY c.closure_name;

## Calculations for the presentation

-- Average price/l per country
WITH ranked AS (
    SELECT country,
        price / capacity_liter AS price_per_l,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY price / capacity_liter) AS rn,
        COUNT(*) OVER (PARTITION BY country) AS total_rows
    FROM main
),
medians AS (
    SELECT country,
        ROUND(AVG(price_per_l), 2) AS median_price_country
    FROM ranked
    WHERE rn IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2))
    GROUP BY country
)
SELECT m.country,
    ROUND(AVG(AVG(price / capacity_liter)) OVER (), 2) AS avg_price,  -- Overall avg
    med.median_price_country,								 -- Country median
    ROUND(AVG(price / capacity_liter), 2) AS avg_price_country        -- Country avg                               
FROM main AS m
JOIN medians AS med 
	ON m.country = med.country
GROUP BY m.country, med.median_price_country
HAVING COUNT(*) > 9
ORDER BY avg_price_country DESC;

-- Average price/l per region
SELECT country,
	region,
	COUNT(*) AS nro_wines,
	ROUND(AVG(AVG(price / capacity_liter)) 
          OVER (PARTITION BY country), 2) AS avg_price_country,
    ROUND(AVG(price/capacity_liter), 2) AS avg_price_region
FROM main
WHERE region IS NOT NULL
GROUP BY country, region
HAVING COUNT(*) > 9
ORDER BY avg_price_region DESC
LIMIT 10;

SELECT appelation,
	region,
    country,
    COUNT(*) AS nro_wines,
    ROUND(AVG(AVG(price / capacity_liter)) 
          OVER (PARTITION BY country), 2) AS avg_price_country,
	ROUND(AVG(AVG(price / capacity_liter)) 
          OVER (PARTITION BY region), 2) AS avg_price_region,
	ROUND(AVG(price/capacity_liter), 2) AS avg_price_appelation
FROM main
WHERE appelation IS NOT NULL
GROUP BY appelation, region, country
HAVING COUNT(*) > 1
ORDER BY avg_price_appelation DESC
LIMIT 10;

-- Wines that have won awards vs. no awards
CREATE TEMPORARY TABLE award
SELECT wine_id,
    CASE 
        WHEN description LIKE '%award%' 
             OR description LIKE '%gold metal%' 
        THEN 'Award winning'
        ELSE 'No award'
    END AS award_status
FROM wine_info;

SELECT 
    a.award_status,
    ROUND(AVG(m.price/m.capacity_liter), 2) AS avg_price
FROM award AS a
JOIN main AS m
    ON a.wine_id = m.wine_id
GROUP BY a.award_status;