-- -- Cell 6 (SQL string) --
INSERT IGNORE INTO closure(closure_id, closure_name)
        SELECT DISTINCT closure_id, Closure
        FROM staging_wine WHERE closure_id IS NOT NULL
;

-- -- Cell 6 (SQL string) --
INSERT IGNORE INTO primary_grape(primary_grape_id, primary_grape_name)
        SELECT DISTINCT grape_id, Grape
        FROM staging_wine WHERE grape_id IS NOT NULL
;

-- -- Cell 7 (read_sql/execute) --
SELECT * FROM staging_wine
;

-- -- Cell 10 (SQL string) --
SELECT country,
       COUNT(*) AS n_wines,
       ROUND(AVG(price),2) AS avg_price,
       ROUND(MAX(price),2) AS max_price
FROM main
WHERE price IS NOT NULL AND price > 0
GROUP BY country
ORDER BY avg_price DESC
LIMIT 10;

-- -- Cell 11 (SQL string) --
SELECT wi.title, m.country, m.region, m.price
FROM main m
JOIN wine_info wi ON wi.wine_id = m.wine_id
WHERE m.price IS NOT NULL
ORDER BY m.price DESC
LIMIT 5;

-- -- Cell 12 (SQL string) --
SELECT cc.continent,
       COUNT(*) AS n_wines,
       ROUND(AVG(m.price),2) AS avg_price
FROM main m
LEFT JOIN country_continent cc
 ON LOWER(cc.country) = LOWER(m.country)
WHERE m.price IS NOT NULL AND m.price > 0
GROUP BY cc.continent
ORDER BY avg_price DESC;

-- -- Cell 13 (SQL string) --
SELECT c.closure_name,
       COUNT(*) AS n_wines,
       ROUND(AVG(m.price),2) AS avg_price,
       ROUND(MIN(m.price),2) AS min_price,
       ROUND(MAX(m.price),2) AS max_price
FROM main m
LEFT JOIN closure c ON m.closure_id = c.closure_id
GROUP BY c.closure_name
ORDER BY avg_price DESC;

-- -- Cell 17 (SQL string) --
SELECT country, region,
       COUNT(*) AS n_wines,
       ROUND(AVG(price),2) AS avg_price,
       ROUND(MAX(price),2) AS max_price
FROM main
WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
GROUP BY country, region
HAVING COUNT(*) >= 5
ORDER BY avg_price DESC
LIMIT 20;

-- -- Cell 18 (SQL string) --
WITH region_stats AS (
  SELECT country, region,
         COUNT(*) AS n_wines,
         AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
)
SELECT country, region, n_wines, ROUND(avg_price,2) AS avg_price
FROM ranked
WHERE q = 4
ORDER BY avg_price DESC;

-- -- Cell 19 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
),
premium_regions AS (
  SELECT country, region FROM ranked WHERE q = 4
)
SELECT wi.title, m.country, m.region, m.price
FROM main m
JOIN premium_regions pr ON pr.country = m.country AND pr.region = m.region
LEFT JOIN wine_info wi   ON wi.wine_id = m.wine_id
WHERE m.price IS NOT NULL
ORDER BY m.price DESC
LIMIT 15;

-- -- Cell 20 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
),
premium_regions AS (
  SELECT country, region FROM ranked WHERE q = 4
),
premium_wines AS (
  SELECT m.wine_id
  FROM main m
  JOIN premium_regions pr ON pr.country = m.country AND pr.region = m.region
)
SELECT c.characteristic_name,
       COUNT(*) AS n_wines
FROM premium_wines pw
JOIN wine_characteristic wc ON wc.wine_id = pw.wine_id
JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
GROUP BY c.characteristic_name
ORDER BY n_wines DESC
LIMIT 25;

-- -- Cell 21 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
)
SELECT country, region, n_wines, ROUND(avg_price,2) AS avg_price
FROM ranked
WHERE q = 4
ORDER BY avg_price DESC
LIMIT 15;

-- -- Cell 22 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
),
premium_regions AS (
  SELECT country, region FROM ranked WHERE q = 4
),
premium_wines AS (
  SELECT m.wine_id, m.region
  FROM main m
  JOIN premium_regions pr ON pr.country = m.country AND pr.region = m.region
),
region_top AS (
  SELECT region, COUNT(*) AS n
  FROM premium_wines
  GROUP BY region
  ORDER BY n DESC
  LIMIT 10
),
char_top AS (
  SELECT c.characteristic_name, COUNT(*) AS n
  FROM premium_wines pw
  JOIN wine_characteristic wc ON wc.wine_id = pw.wine_id
  JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
  GROUP BY c.characteristic_name
  ORDER BY n DESC
  LIMIT 12
)
SELECT pw.region, c.characteristic_name, COUNT(*) AS n
FROM premium_wines pw
JOIN wine_characteristic wc ON wc.wine_id = pw.wine_id
JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
JOIN region_top rt ON rt.region = pw.region
JOIN char_top   ct ON ct.characteristic_name = c.characteristic_name
GROUP BY pw.region, c.characteristic_name
ORDER BY pw.region, n DESC;

-- -- Cell 26 (SQL string) --
SELECT Wine_ID AS wine_id, Characteristics
           FROM staging_wine
           WHERE Characteristics IS NOT NULL AND TRIM(Characteristics) <> ''
;

-- -- Cell 30 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
)
SELECT country, region, n_wines, ROUND(avg_price,2) AS avg_price
FROM ranked
WHERE q = 4
ORDER BY avg_price DESC;

-- -- Cell 31 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
),
premium_regions AS (
  SELECT country, region FROM ranked WHERE q = 4
),
premium_wines AS (
  SELECT m.wine_id
  FROM main m
  JOIN premium_regions pr ON pr.country = m.country AND pr.region = m.region
)
SELECT c.characteristic_name, COUNT(*) AS n_wines
FROM premium_wines pw
JOIN wine_characteristic wc ON wc.wine_id = pw.wine_id
JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
GROUP BY c.characteristic_name
ORDER BY n_wines DESC
LIMIT 20;

-- -- Cell 35 (SQL string) --
SELECT country,
       region,
       CAST(price AS DOUBLE) AS price
FROM main
WHERE price IS NOT NULL AND price > 0
  AND region IS NOT NULL AND TRIM(region) <> ''
;

-- -- Cell 38 (SQL string) --
SELECT c.characteristic_name AS characteristic,
       m.price
FROM wine_characteristic wc
JOIN characteristic c ON c.characteristic_id = wc.characteristic_id
JOIN main m ON m.wine_id = wc.wine_id
WHERE m.price IS NOT NULL AND m.price > 0
;

-- -- Cell 41 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
ranked AS (
  SELECT country, region, n_wines, avg_price,
         NTILE(4) OVER (ORDER BY avg_price) AS q
  FROM region_stats
)
SELECT country, region FROM ranked WHERE q = 4
;

-- -- Cell 42 (SQL string) --
WITH premium_regions AS (
  WITH region_stats AS (
    SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
    FROM main
    WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
    GROUP BY country, region
    HAVING COUNT(*) >= 5
  )
  SELECT country, region
  FROM (
    SELECT country, region, avg_price,
           NTILE(4) OVER (ORDER BY avg_price) AS q
    FROM region_stats
  ) x WHERE q = 4
)
SELECT c.characteristic_name AS characteristic,
       COUNT(*) AS n_wines
FROM main m
JOIN premium_regions pr
  ON pr.country = m.country AND pr.region = m.region
JOIN wine_characteristic wc ON wc.wine_id = m.wine_id
JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
GROUP BY c.characteristic_name
ORDER BY n_wines DESC
LIMIT 20;

-- -- Cell 45 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(price) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0 AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
top_regions AS (
  SELECT country, region
  FROM region_stats
  ORDER BY avg_price DESC
  LIMIT {top_k_regions}
),
char_counts AS (
  SELECT m.country, m.region, c.characteristic_name, COUNT(*) AS n
  FROM main m
  JOIN wine_characteristic wc ON wc.wine_id = m.wine_id
  JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
  JOIN top_regions tr ON tr.country = m.country AND tr.region = m.region
  GROUP BY m.country, m.region, c.characteristic_name
),
top_chars AS (
  SELECT characteristic_name
  FROM char_counts
  GROUP BY characteristic_name
  ORDER BY SUM(n) DESC
  LIMIT {top_k_chars}
)
SELECT CONCAT(cc.country,' — ',cc.region) AS region,
       cc.characteristic_name,
       cc.n
FROM char_counts cc
JOIN top_chars tc ON tc.characteristic_name = cc.characteristic_name
ORDER BY region, n DESC;

-- -- Cell 47 (SQL string) --
WITH base AS (
  SELECT CAST(price AS DOUBLE) price
  FROM main WHERE price IS NOT NULL AND price>0
),
r AS (
  SELECT price,
         ROW_NUMBER() OVER(ORDER BY price DESC) AS rn,
         COUNT(*)    OVER() AS n,
         SUM(price)  OVER() AS total,
         SUM(price)  OVER(ORDER BY price DESC) AS cum_price
  FROM base
)
SELECT ROUND(rn/n,3) AS cum_wines_share,
       ROUND(cum_price/total,3) AS cum_price_share
FROM r
ORDER BY rn;

-- -- Cell 48 (SQL string) --
WITH base AS (
  SELECT CAST(price AS DOUBLE) AS price
  FROM main
  WHERE price IS NOT NULL AND price > 0
),
r AS (
  SELECT price,
         ROW_NUMBER() OVER (ORDER BY price ASC) AS rn,
         COUNT(*)    OVER () AS n,
         SUM(price)  OVER () AS total,
         SUM(price)  OVER (ORDER BY price ASC) AS cum_price
  FROM base
)
SELECT ROUND(rn/n, 4) AS cum_wines_share,
       ROUND(cum_price/total, 4) AS cum_price_share
FROM r
ORDER BY rn;

-- -- Cell 52 (SQL string) --
WITH region_stats AS (
  SELECT country, region, COUNT(*) AS n_wines, AVG(CAST(price AS DOUBLE)) AS avg_price
  FROM main
  WHERE price IS NOT NULL AND price > 0
    AND region IS NOT NULL AND TRIM(region) <> ''
  GROUP BY country, region
  HAVING COUNT(*) >= 5
),
top_regions AS (
  SELECT country, region
  FROM region_stats
  ORDER BY avg_price DESC
  LIMIT {top_k_regions}
),
char_counts AS (
  SELECT m.country, m.region, c.characteristic_name, COUNT(*) AS n
  FROM main m
  JOIN wine_characteristic wc ON wc.wine_id = m.wine_id
  JOIN characteristic c       ON c.characteristic_id = wc.characteristic_id
  JOIN top_regions tr ON tr.country = m.country AND tr.region = m.region
  GROUP BY m.country, m.region, c.characteristic_name
),
top_chars AS (
  SELECT characteristic_name
  FROM char_counts
  GROUP BY characteristic_name
  ORDER BY SUM(n) DESC
  LIMIT {top_k_chars}
)
SELECT CONCAT(cc.country,' — ',cc.region) AS region,
       cc.characteristic_name,
       cc.n
FROM char_counts cc
JOIN top_chars tc ON tc.characteristic_name = cc.characteristic_name
ORDER BY region, n DESC;

-- -- Cell 54 (SQL string) --
WITH exp AS (
  SELECT m.wine_id, m.country, m.region, m.price, cl.closure_name
  FROM main m
  LEFT JOIN closure cl ON cl.closure_id=m.closure_id
  WHERE m.price IS NOT NULL AND m.price>50
    AND m.region IS NOT NULL AND TRIM(m.region) <> ''
),
top_regions AS (
  SELECT CONCAT(country,' — ',region) AS reg, COUNT(*) n
  FROM exp GROUP BY 1 ORDER BY n DESC LIMIT 6
),
top_chars AS (
  SELECT c.characteristic_name, COUNT(*) n
  FROM exp e
  JOIN wine_characteristic wc ON wc.wine_id=e.wine_id
  JOIN characteristic c ON c.characteristic_id=wc.characteristic_id
  GROUP BY 1 ORDER BY n DESC LIMIT 8
)
SELECT CONCAT(e.country,' — ',e.region) AS region,
       e.closure_name AS closure,
       c.characteristic_name AS characteristic
FROM exp e
JOIN top_regions tr ON tr.reg = CONCAT(e.country,' — ',e.region)
JOIN wine_characteristic wc ON wc.wine_id=e.wine_id
JOIN characteristic c ON c.characteristic_id=wc.characteristic_id
JOIN top_chars tc ON tc.characteristic_name=c.characteristic_name;

-- -- Cell 55 (SQL string) --
SELECT m.wine_id,
       m.country,
       m.region,
       CAST(m.price AS DOUBLE) AS price,
       LOWER(c.closure_name) AS closure_name
FROM main m
LEFT JOIN closure c ON c.closure_id = m.closure_id
WHERE m.price IS NOT NULL AND m.price > 0
  AND m.region IS NOT NULL AND TRIM(m.region) <> ''
;

-- -- Cell 55 (SQL string) --
SELECT wc.wine_id, c.characteristic_name
FROM wine_characteristic wc
JOIN characteristic c ON c.characteristic_id = wc.characteristic_id
;

-- -- Cell 56 (SQL string) --
SELECT m.wine_id,
       m.country, m.region,
       CAST(m.price AS DOUBLE) AS price,
       LOWER(c.closure_name) AS closure_name
FROM main m
LEFT JOIN closure c ON c.closure_id = m.closure_id
WHERE m.price IS NOT NULL AND m.price > 0
  AND m.region IS NOT NULL AND TRIM(m.region) <> ''
;

-- -- Cell 57 (SQL string) --
SELECT m.wine_id, m.country, m.region,
       CAST(m.price AS DOUBLE) AS price,
       LOWER(c.closure_name) AS closure_name
FROM main m
LEFT JOIN closure c ON c.closure_id = m.closure_id
WHERE m.price IS NOT NULL AND m.price > {EXP}
  AND m.region IS NOT NULL AND TRIM(m.region) <> ''
;

-- -- Cell 58 (SQL string) --
SELECT m.wine_id, CAST(m.price AS DOUBLE) AS price, LOWER(c.closure_name) AS closure_name,
       m.country, m.region
FROM main m LEFT JOIN closure c ON c.closure_id=m.closure_id
WHERE m.price IS NOT NULL AND m.price>0 AND m.region IS NOT NULL AND TRIM(m.region) <> ''
;

-- -- Cell 59 (SQL string) --
SELECT m.wine_id, m.country, m.region,
       CAST(m.price AS DOUBLE) AS price,
       LOWER(c.closure_name) AS closure_name
FROM main m
LEFT JOIN closure c ON c.closure_id = m.closure_id
WHERE m.price IS NOT NULL AND m.price > 0
  AND m.region IS NOT NULL AND TRIM(m.region) <> ''
;
