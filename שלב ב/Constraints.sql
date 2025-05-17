-- 1. הוספת אילוץ CHECK על משכורת ברמן
ALTER TABLE bartender
ADD CONSTRAINT check_wage CHECK (wage >= 0);

-- 2. הוספת אילוץ DEFAULT על shelf_life של מוצר
ALTER TABLE product
ALTER COLUMN shelf_life SET DEFAULT 12;

-- 3. הוספת אילוץ NOT NULL לשם ספק
ALTER TABLE supplier
ALTER COLUMN name SET NOT NULL;
