-- Select
-- 1. רשימת ברמנים עם השכר, שם ותאריך לידה
SELECT p.name, p.date_of_birth, b.wage
FROM person p
JOIN bartender b ON p.person_id = b.person_id
ORDER BY b.wage DESC;

-- 2. משקאות עם אלכוהול מעל 5%, כולל שם, סוג, תכולת אלכוהול ושם ברמן שאחראי
SELECT d.name, d.type, d.alcohol_content, p.name AS bartender_name
FROM drink d
JOIN person p ON d.person_id = p.person_id
WHERE d.alcohol_content > 5
ORDER BY d.alcohol_content DESC;

-- 3. הזמנות שבוצעו בחודש אפריל 2025
SELECT o.order_id, o.date, EXTRACT(MONTH FROM o.date) AS month, o.payment_method, p.name
FROM orders o
JOIN bartender b ON o."bartender_ID" = b.person_id
JOIN person p ON b.person_id = p.person_id
WHERE EXTRACT(YEAR FROM o.date) = 2025 AND EXTRACT(MONTH FROM o.date) = 4;

-- 4. מוצרים עם תוקף של פחות משנה
SELECT pr.name, pr.shelf_life, pr.type, s.location
FROM product pr
JOIN storage s ON pr.storage_id = s.storage_id
WHERE pr.shelf_life < 365;

-- 5. ממוצע משכורות ברמנים לפי רמת מומחיות בבירה
SELECT beer_expert, AVG(wage) as avg_wage
FROM bartender
GROUP BY beer_expert
ORDER BY avg_wage DESC;

-- 6. רשימת אנשים שאינם ברמנים
SELECT name, age
FROM person
WHERE person_id NOT IN (SELECT person_id FROM bartender);

-- 7. כמות משקאות שנמכרו בכל הזמנה
SELECT o.order_id, COUNT(od.drink_id) AS total_drinks
FROM orders o
JOIN ordersdrink od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY total_drinks DESC;

-- 8. פירוט מוצרים המכילים גם גלוטן וגם אגוזים
SELECT name, gluten_free, nut_free
FROM product
WHERE gluten_free = 0 AND nut_free = 0;


--------------------
-- Delete
--------------------

-- 1. מחיקת ברמנים עם ניסיון של פחות משנה
BEGIN;

-- Step 1: Delete from ordersdrink
DELETE FROM ordersdrink
WHERE drink_id IN (
  SELECT d.drink_id
  FROM drink d
  JOIN bartender b ON d.person_id = b.person_id
  WHERE b.experience < 365
);

-- Step 2: Delete from drinkproducts
DELETE FROM drinkproducts
WHERE drink_id IN (
  SELECT d.drink_id
  FROM drink d
  JOIN bartender b ON d.person_id = b.person_id
  WHERE b.experience < 365
);

-- Step 3: Delete from drink
DELETE FROM drink
WHERE person_id IN (
  SELECT person_id FROM bartender WHERE experience < 365
);

-- Step 4: Delete from bartender_academic_institution
DELETE FROM bartender_academic_institution
WHERE person_id IN (
  SELECT person_id FROM bartender WHERE experience < 365
);

-- Step 5: Finally delete from bartender
DELETE FROM bartender
WHERE experience < 365;

COMMIT;

-- 2. מחיקת מוצרים שתוקפם פחות מ-3 חודשים
BEGIN;

-- Step 1: Delete from drinkproducts first
DELETE FROM drinkproducts
WHERE product_id IN (
  SELECT product_id FROM product WHERE shelf_life < 84
);

-- Step 2: Now it's safe to delete the products
DELETE FROM product
WHERE shelf_life < 84;

COMMIT;


-- 3. מחיקת משקאות עם 0% אלכוהול ובלי סוכר
BEGIN;

-- Step 1: Delete from ordersdrink
DELETE FROM ordersdrink
WHERE drink_id IN (
  SELECT drink_id FROM drink
  WHERE alcohol_content = 0 AND sugar_free = 1
);

-- Step 2: Delete from drinkproducts
DELETE FROM drinkproducts
WHERE drink_id IN (
  SELECT drink_id FROM drink
  WHERE alcohol_content = 0 AND sugar_free = 1
);

-- Step 3: Delete the drinks
DELETE FROM drink
WHERE alcohol_content = 0 AND sugar_free = 1;

COMMIT;


--------------------
-- Update
--------------------
-- 1. עדכון שכר ברמנים עם מומחיות בבירה 
UPDATE bartender
SET wage = wage * 1.1
WHERE beer_expert == 1;

-- 2. עדכון סוג מוצר לטבעוני אם הוא ללא גלוטן, ללא אגוזים וצמחוני
UPDATE product
SET vegan = 1
WHERE gluten_free = 1 AND nut_free = 1 AND vegetarian = 1;

-- עדכון התאריכי לידה שיתאימו לגיל
UPDATE person
SET date_of_birth = MAKE_DATE(
    EXTRACT(YEAR FROM CURRENT_DATE)::INT - age,
    EXTRACT(MONTH FROM date_of_birth)::INT,
    EXTRACT(DAY FROM date_of_birth)::INT
)