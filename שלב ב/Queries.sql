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
JOIN bartender b ON o.bartender_id = b.person_id
JOIN person p ON b.person_id = p.person_id
WHERE EXTRACT(YEAR FROM o.date) = 2025 AND EXTRACT(MONTH FROM o.date) = 4;

-- 4. מוצרים עם תוקף של פחות משנה
SELECT pr.name, pr.shelf_life, pr.type, s.location
FROM product pr
JOIN storage s ON pr.storage_id = s.storage_id
WHERE pr.shelf_life < 12;

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


-- Delete
-- 1. מחיקת ברמנים עם ניסיון של פחות משנה
DELETE FROM bartender
WHERE experience < 1;

-- 2. מחיקת משקאות עם 0% אלכוהול ובלי סוכר
DELETE FROM drink
WHERE alcohol_content = 0 AND sugar_free = 1;

-- 3. מחיקת מוצרים שתוקפם פחות מ-3 חודשים
DELETE FROM product
WHERE shelf_life < 3;


-- Update
-- 1. עדכון שכר ברמנים עם מומחיות בבירה לרמה 5 ומעלה
UPDATE bartender
SET wage = wage * 1.1
WHERE beer_expert >= 5;

-- 2. עדכון סוג מוצר לטבעוני אם הוא ללא גלוטן, ללא אגוזים וצמחוני
UPDATE product
SET vegan = 1
WHERE gluten_free = 1 AND nut_free = 1 AND vegetarian = 1;

-- 3. עדכון כתובת לאנשים מאזור קידוד מסוים
UPDATE person
SET address = 'Updated Address'
WHERE area_code = '12345';
