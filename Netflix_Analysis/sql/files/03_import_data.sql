-- ============================================================
-- 03_import_data.sql
-- Netflix Titles Analysis — CSV Import
-- ============================================================

USE netflix_db;

-- If local_infile is disabled, enable it first (needs SUPER/admin,
-- and the client must also connect with --local-infile=1):
--   SET GLOBAL local_infile = 1;

-- Update the path below to match your machine.
LOAD DATA LOCAL INFILE '/Users/princekumarsingh/netflix_cleaned.csv'
INTO TABLE netflix_titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- If LOAD DATA LOCAL is blocked on your MySQL install, use MySQL
-- Workbench's Table Data Import Wizard instead (right-click
-- netflix_titles → Table Data Import Wizard).

-- Verify the import
SELECT * FROM netflix_titles LIMIT 10;

SELECT COUNT(*) FROM netflix_titles;
-- Expected: 8797
