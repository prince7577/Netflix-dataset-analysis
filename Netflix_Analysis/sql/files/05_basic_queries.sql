-- ============================================================
-- 05_basic_queries.sql
-- Netflix Titles Analysis — Basic Queries (1-15)
-- Verified against netflix_cleaned.csv (8,797 rows)
-- ============================================================

USE netflix_db;

-- 1. Total Records
SELECT COUNT(*) AS Total_Titles
FROM netflix_titles;
-- 8797

-- 2. Movies vs TV Shows
SELECT type, COUNT(*) AS Total
FROM netflix_titles
GROUP BY type;
-- Movie 6131 | TV Show 2666

-- 3. Top 10 Countries
-- Groups by the raw country string, so co-productions like
-- "United States, Ghana, Burkina Faso" count as one distinct value
-- rather than being split across each country.
SELECT country, COUNT(*) AS Total
FROM netflix_titles
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY Total DESC
LIMIT 10;

-- 4. Content by Rating
SELECT rating_clean AS rating, COUNT(*) AS Total
FROM netflix_titles
GROUP BY rating_clean
ORDER BY Total DESC;

-- 5. Titles Released Each Year
SELECT release_year, COUNT(*) AS Total
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- 6. Top 10 Directors
SELECT director, COUNT(*) AS Total
FROM netflix_titles
WHERE director <> 'Unknown'
GROUP BY director
ORDER BY Total DESC
LIMIT 10;

-- 7. Longest Movies
SELECT title, duration_clean AS duration
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration_clean, ' min', '') AS UNSIGNED) DESC
LIMIT 10;
-- Top result: Black Mirror: Bandersnatch, 312 min

-- 8. TV Shows with Most Seasons
SELECT title, duration
FROM netflix_titles
WHERE type = 'TV Show'
ORDER BY CAST(REPLACE(duration, ' Seasons', '') AS UNSIGNED) DESC
LIMIT 10;
-- Top result: Grey's Anatomy, 17 Seasons
-- (CAST reads leading digits, so singular "1 Season" rows still parse
-- correctly even though REPLACE only targets the plural "Seasons")

-- 9. Movies Released After 2020
SELECT title, release_year
FROM netflix_titles
WHERE type = 'Movie'
  AND release_year > 2020;
-- 277 rows

-- 10. Count Movies Released Each Year
SELECT release_year, COUNT(*) AS Movies
FROM netflix_titles
WHERE type = 'Movie'
GROUP BY release_year
ORDER BY release_year;

-- 11. Count TV Shows Each Year
SELECT release_year, COUNT(*) AS TV_Shows
FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY release_year
ORDER BY release_year;

-- 12. Movies with PG-13 Rating
SELECT title
FROM netflix_titles
WHERE rating_clean = 'PG-13';
-- 490 rows

-- 13. Titles Added in 2021
SELECT title, date_added_clean AS date_added
FROM netflix_titles
WHERE YEAR(date_added_clean) = 2021;
-- 1498 rows

-- 14. Search by Genre
SELECT title, listed_in
FROM netflix_titles
WHERE listed_in LIKE '%Drama%';
-- 3189 rows

-- 15. Search by Country
SELECT title, country
FROM netflix_titles
WHERE country = 'India';
-- 972 rows
