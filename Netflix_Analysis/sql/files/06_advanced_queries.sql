-- ============================================================
-- 06_advanced_queries.sql
-- Netflix Titles Analysis — Advanced Queries (16-33)
-- Window functions, CTEs, subqueries, views
-- Requires MySQL 8.0+ (window functions & CTEs need 8.0)
-- Verified against netflix_cleaned.csv (8,797 rows)
-- ============================================================

USE netflix_db;

-- 16. Top 5 release years by title count
SELECT release_year, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY release_year
ORDER BY total_titles DESC
LIMIT 5;

-- 17. Average movie duration (minutes)
SELECT AVG(CAST(REPLACE(duration_clean, ' min', '') AS UNSIGNED)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie';
-- ~99.5 min

-- 18. Movies by rating
SELECT rating_clean AS rating, COUNT(*) AS total
FROM netflix_titles
WHERE type = 'Movie'
GROUP BY rating_clean
ORDER BY total DESC;

-- 19. Directors ranked by title count (DENSE_RANK, ties share a rank)
WITH dir AS (
    SELECT director, COUNT(*) AS total
    FROM netflix_titles
    WHERE director <> 'Unknown'
    GROUP BY director
)
SELECT director, total,
       DENSE_RANK() OVER (ORDER BY total DESC) AS rnk
FROM dir
ORDER BY rnk
LIMIT 10;

-- 20. Running total of titles released, year over year
SELECT release_year,
       COUNT(*) AS titles_this_year,
       SUM(COUNT(*)) OVER (ORDER BY release_year) AS running_total
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- 21. Year-over-year change in titles released (LAG)
WITH yearly AS (
    SELECT release_year, COUNT(*) AS total
    FROM netflix_titles
    GROUP BY release_year
)
SELECT release_year, total,
       total - LAG(total) OVER (ORDER BY release_year) AS yoy_change
FROM yearly
ORDER BY release_year;

-- 22. Directors who have made both Movies AND TV Shows
SELECT director, COUNT(DISTINCT type) AS type_count
FROM netflix_titles
WHERE director <> 'Unknown'
GROUP BY director
HAVING COUNT(DISTINCT type) = 2
ORDER BY director
LIMIT 20;

-- 23. Countries producing more titles than the cross-country average
-- (subquery in HAVING)
SELECT country, COUNT(*) AS total
FROM netflix_titles
WHERE country <> 'Unknown'
GROUP BY country
HAVING COUNT(*) > (
    SELECT COUNT(*) * 1.0 / COUNT(DISTINCT country)
    FROM netflix_titles
    WHERE country <> 'Unknown'
)
ORDER BY total DESC;

-- 24. Each type's share of the total catalog (window function, no GROUP BY subquery needed)
SELECT type, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM netflix_titles
GROUP BY type;

-- 25. Rating distribution as a percentage, movies only
SELECT rating_clean AS rating, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM netflix_titles
WHERE type = 'Movie'
GROUP BY rating_clean
ORDER BY total DESC;

-- 26. Data-quality check: duplicate titles (same title, different show_id)
-- Returns 0 rows on this dataset — included as a standing check, not
-- because duplicates exist today.
SELECT title, COUNT(*) AS occurrences
FROM netflix_titles
GROUP BY title
HAVING COUNT(*) > 1;

-- 27. Most common listed_in combination per release year (ROW_NUMBER + PARTITION)
-- Note: this ranks the raw comma-separated listed_in string as a whole
-- (e.g. "Dramas, International Movies"), not individual genres split
-- apart — splitting a comma list into rows needs procedural SQL
-- (a recursive CTE or JSON_TABLE), which is out of scope for a
-- straight analysis script.
WITH genre_year AS (
    SELECT release_year, listed_in, COUNT(*) AS total
    FROM netflix_titles
    GROUP BY release_year, listed_in
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY release_year ORDER BY total DESC) AS rn
    FROM genre_year
)
SELECT release_year, listed_in, total
FROM ranked
WHERE rn = 1
ORDER BY release_year DESC;

-- 28. Titles bucketed into duration quartiles (movies only, NTILE)
WITH movie_durations AS (
    SELECT title, CAST(REPLACE(duration_clean, ' min', '') AS UNSIGNED) AS mins
    FROM netflix_titles
    WHERE type = 'Movie'
)
SELECT title, mins,
       NTILE(4) OVER (ORDER BY mins) AS duration_quartile
FROM movie_durations
ORDER BY mins DESC
LIMIT 20;

-- 29. First title added per country (ROW_NUMBER + PARTITION on date)
WITH ranked AS (
    SELECT title, country, date_added_clean,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY date_added_clean ASC) AS rn
    FROM netflix_titles
    WHERE country <> 'Unknown' AND date_added_clean IS NOT NULL
)
SELECT country, title, date_added_clean
FROM ranked
WHERE rn = 1
ORDER BY country
LIMIT 15;

-- 30. Rank titles by release year within each type (RANK, ties share a rank + gap)
SELECT title, type, release_year,
       RANK() OVER (PARTITION BY type ORDER BY release_year DESC) AS recency_rank
FROM netflix_titles
ORDER BY type, recency_rank
LIMIT 20;

-- ------------------------------------------------------------
-- VIEWS — reusable building blocks for a BI tool / dashboard
-- ------------------------------------------------------------

-- 31. vw_yearly_summary: one row per year, movies/TV split + total
CREATE OR REPLACE VIEW vw_yearly_summary AS
SELECT release_year,
       SUM(type = 'Movie')   AS movies,
       SUM(type = 'TV Show') AS tv_shows,
       COUNT(*)              AS total_titles
FROM netflix_titles
GROUP BY release_year;

-- Usage: SELECT * FROM vw_yearly_summary ORDER BY release_year DESC;

-- 32. vw_top_countries: countries with 50+ titles, ranked
CREATE OR REPLACE VIEW vw_top_countries AS
SELECT country, COUNT(*) AS total,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM netflix_titles
WHERE country <> 'Unknown'
GROUP BY country
HAVING COUNT(*) >= 50;

-- Usage: SELECT * FROM vw_top_countries ORDER BY country_rank;

-- 33. vw_director_portfolio: each director's output by type
CREATE OR REPLACE VIEW vw_director_portfolio AS
SELECT director,
       SUM(type = 'Movie')   AS movies,
       SUM(type = 'TV Show') AS tv_shows,
       COUNT(*)              AS total_titles
FROM netflix_titles
WHERE director <> 'Unknown'
GROUP BY director;

-- Usage: SELECT * FROM vw_director_portfolio WHERE total_titles > 5 ORDER BY total_titles DESC;
