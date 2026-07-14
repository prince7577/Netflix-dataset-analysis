-- ============================================================
-- 04_data_cleaning.sql
-- Netflix Titles Analysis — Cleaning & Indexing
-- ============================================================

USE netflix_db;

-- ------------------------------------------------------------
-- 1. Convert date_added to a real DATE column
-- ------------------------------------------------------------
-- 88 rows in this dataset have a leading space before the date
-- (" August 4, 2017" instead of "August 4, 2017"), which breaks
-- STR_TO_DATE if you don't TRIM first — always TRIM before parsing.

ALTER TABLE netflix_titles ADD COLUMN date_added_clean DATE;

UPDATE netflix_titles
SET date_added_clean = STR_TO_DATE(TRIM(date_added), '%M %d, %Y');

-- Sanity check: this should return 0 rows. If it doesn't, some dates
-- used a format STR_TO_DATE didn't expect and need a look before you
-- trust the column.
SELECT date_added, date_added_clean
FROM netflix_titles
WHERE date_added IS NOT NULL
  AND date_added <> ''
  AND date_added_clean IS NULL;

-- Once verified, you can swap it in as the primary column:
-- ALTER TABLE netflix_titles DROP COLUMN date_added;
-- ALTER TABLE netflix_titles CHANGE date_added_clean date_added DATE;
-- (Kept as a separate column here rather than overwriting in place,
-- so the original text is still there to check against if needed.)

-- ------------------------------------------------------------
-- 2. Fix the 3 rows where rating/duration got shifted
-- ------------------------------------------------------------
-- 3 movies ("Louis C.K. 2017", "Louis C.K.: Hilarious",
-- "Louis C.K.: Live at the Comedy Store") have a runtime like
-- '74 min' sitting in the `rating` column and 'Unknown' in
-- `duration`. Add cleaned columns rather than overwrite the raw
-- import, so both the original and corrected values are on hand.

ALTER TABLE netflix_titles ADD COLUMN rating_clean VARCHAR(20);
ALTER TABLE netflix_titles ADD COLUMN duration_clean VARCHAR(50);

UPDATE netflix_titles
SET rating_clean   = IF(rating LIKE '%min%', 'Not Rated', rating),
    duration_clean = IF(rating LIKE '%min%', rating, duration);

-- ------------------------------------------------------------
-- 3. Indexes for common filter/group columns
-- ------------------------------------------------------------
CREATE INDEX idx_type ON netflix_titles(type);
CREATE INDEX idx_release_year ON netflix_titles(release_year);
CREATE INDEX idx_country ON netflix_titles(country(100));  -- prefix index keeps the key small regardless of collation/row-format limits
CREATE INDEX idx_rating ON netflix_titles(rating_clean);
