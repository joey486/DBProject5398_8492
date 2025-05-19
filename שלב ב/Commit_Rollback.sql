-- ROLLBACK
BEGIN;

UPDATE bartender
SET wage = wage + 100
WHERE mixologist = 1;

SELECT person_ID, wage, mixologist
FROM bartender
WHERE mixologist = 1;

ROLLBACK;

SELECT person_ID, wage, mixologist
FROM bartender
WHERE mixologist = 1;

-- COMMIT
BEGIN;
UPDATE bartender SET wage = wage + 200 WHERE mixologist >= 3;
-- בדיקה עם SELECT
COMMIT;
-- SELECT מאשר שהערכים נשמרו
