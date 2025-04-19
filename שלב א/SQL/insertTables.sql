-- Insert into Person
INSERT INTO Person (Person_ID, Age, Name, Date_of_birth, Address, Area_code, Phone_number) 
VALUES (1, 30, 'John Doe', TO_DATE('1994-05-15', 'YYYY-MM-DD'), '123 Main St', '10001', '123-456-7890');

INSERT INTO Person (Person_ID, Age, Name, Date_of_birth, Address, Area_code, Phone_number) 
VALUES (2, 28, 'Jane Smith', TO_DATE('1996-08-22', 'YYYY-MM-DD'), '456 Oak St', '10002', '987-654-3210');

INSERT INTO Person (Person_ID, Age, Name, Date_of_birth, Address, Area_code, Phone_number) 
VALUES (3, 35, 'Alice Brown', TO_DATE('1989-12-10', 'YYYY-MM-DD'), '789 Pine St', '10003', '456-789-1234');

-- Insert into Storage
INSERT INTO Storage (Storage_ID, Number_of_cells, Capacity, Type, Location, Name) 
VALUES (1, 10, 500, 'Cold', 'Warehouse A', 'Fridge');

INSERT INTO Storage (Storage_ID, Number_of_cells, Capacity, Type, Location, Name) 
VALUES (2, 20, 1000, 'Dry', 'Warehouse B', 'Shelf');

INSERT INTO Storage (Storage_ID, Number_of_cells, Capacity, Type, Location, Name) 
VALUES (3, 5, 300, 'Frozen', 'Warehouse C', 'Freezer');

-- Insert into Orders
INSERT INTO Orders (Order_ID, Bartender_name, Date, Tip, Price, Time, Payment_method) 
VALUES (1, 'John Doe', SYSDATE, 5.50, 25.00, '18:30', 'Credit Card');

INSERT INTO Orders (Order_ID, Bartender_name, Date, Tip, Price, Time, Payment_method) 
VALUES (2, 'Jane Smith', SYSDATE, 3.00, 15.00, '19:00', 'Cash');

INSERT INTO Orders (Order_ID, Bartender_name, Date, Tip, Price, Time, Payment_method) 
VALUES (3, 'Alice Brown', SYSDATE, 4.00, 20.00, '20:00', 'Debit Card');

-- Insert into Bartender
INSERT INTO Bartender (Person_ID, Beer_Expert, Wage, Wine_Specialist, Experience, Mixologist) 
VALUES (1, 1, 2500.00, 0, 5, 1);

INSERT INTO Bartender (Person_ID, Beer_Expert, Wage, Wine_Specialist, Experience, Mixologist) 
VALUES (2, 0, 2300.00, 1, 3, 0);

INSERT INTO Bartender (Person_ID, Beer_Expert, Wage, Wine_Specialist, Experience, Mixologist) 
VALUES (3, 1, 2800.00, 1, 7, 1);

-- Add similar INSERT statements for other tables...
