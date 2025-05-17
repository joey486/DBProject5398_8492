-- עדכון
BEGIN;
UPDATE bartender SET wage = wage + 100 WHERE mixologist >= 3;
-- בדיקה עם SELECT

-- ביטול
ROLLBACK;
-- SELECT חוזר לערכים הקודמים

-- עדכון אחר
BEGIN;
UPDATE bartender SET wage = wage + 200 WHERE mixologist >= 3;
-- בדיקה עם SELECT
COMMIT;
-- SELECT מאשר שהערכים נשמרו
