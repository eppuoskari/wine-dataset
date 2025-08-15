USE wine;

SELECT * FROM wine.characteristics;

SELECT *
FROM characteristics c
INNER JOIN main m
ON c.wine_id = m.wine_id;


-- Wines that are expensive 
SELECT wine_id
FROM main
WHERE price > 50; 


-- Characteristics and type
SELECT c.*, t.type_name
FROM main m
JOIN characteristics c ON m.wine_id = c.wine_id
JOIN type t ON m.type_id = t.type_id
WHERE m.price > 50;


-- Number of expensive wines by type
SELECT 
    t.type_name,
    COUNT(*) AS nb_expensive_wines
FROM main m
JOIN type t ON m.type_id = t.type_id
WHERE m.price > 50  -- threshold for "expensive wines"
GROUP BY t.type_name
ORDER BY nb_expensive_wines DESC;


-- Top 10 characteristics of expensive wines
SELECT 
    characteristics,
    COUNT(*) AS nb_expensive_wines
FROM characteristics c
JOIN main m ON m.wine_id = c.wine_id
WHERE m.price > 50  -- threshold for "expensive wines"
GROUP BY c.characteristics
ORDER BY nb_expensive_wines DESC
LIMIT 5;


-- Top 5 style of expensive wines
SELECT 
    style,
    COUNT(*) AS nb_expensive_wines
FROM (
    SELECT 
        m.wine_id,
        c.style,
        m.price
    FROM main m
    JOIN characteristics c ON m.wine_id = c.wine_id
    WHERE m.price > 50
    GROUP BY m.wine_id, c.style, m.price
) AS unique_wines
WHERE style IS NOT NULL
GROUP BY style
ORDER BY nb_expensive_wines DESC
LIMIT 5;


-- Percentage of expensive wines 
SELECT wine_id FROM wine.main;

SELECT COUNT(DISTINCT wine_id) AS nb_expensive_wines
FROM main
WHERE price > 50;

