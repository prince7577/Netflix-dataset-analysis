-- ============================================================
-- 02_create_table.sql
-- Netflix Titles Analysis — Table Definition
-- ============================================================

USE netflix_db;

DROP TABLE IF EXISTS netflix_titles;
CREATE TABLE netflix_titles (
    show_id       VARCHAR(20),
    type          VARCHAR(20),
    title         VARCHAR(255),
    director      TEXT,
    cast          TEXT,
    country       VARCHAR(255),
    date_added    VARCHAR(50),   -- imported as text, converted to DATE in 04_data_cleaning.sql
    release_year  INT,
    rating        VARCHAR(20),
    duration      VARCHAR(50),
    listed_in     TEXT,
    description   TEXT
);

-- date_added is loaded as VARCHAR first because the source CSV stores
-- it as text ("September 25, 2021"), some with a stray leading space.
-- Loading straight into a DATE column would silently drop/zero-out any
-- row STR_TO_DATE can't parse on the first pass. Cleaning is a separate,
-- auditable step (04_data_cleaning.sql) rather than baked into the load.
