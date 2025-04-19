CREATE TABLE Storage
(
  Number_of_cells INT NOT NULL,
  Storage_ID INT NOT NULL,
  Capacity INT NOT NULL,
  Type VARCHAR(50) NOT NULL,
  Location VARCHAR(100) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  PRIMARY KEY (Storage_ID)
);

CREATE TABLE Orders
(
  Bartender_name VARCHAR(100) NOT NULL,
  Date DATE NOT NULL,
  Tip NUMERIC(10,2) NOT NULL,
  Price NUMERIC(10,2) NOT NULL,
  Time VARCHAR(10) NOT NULL, 
  Payment_method VARCHAR(50) NOT NULL,
  Order_ID INT NOT NULL,
  PRIMARY KEY (Order_ID)
);

CREATE TABLE Person
(
  Person_ID INT NOT NULL,
  Age INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Date_of_birth DATE NOT NULL,
  Address VARCHAR(255) NOT NULL,
  Area_code VARCHAR(10) NOT NULL,
  Phone_number VARCHAR(20) NOT NULL,
  PRIMARY KEY (Person_ID)
);

CREATE TABLE Bartender
(
  Beer_Expert INT NOT NULL,
  Wage NUMERIC(10,2) NOT NULL,
  Wine_Specialist INT NOT NULL,
  Experience INT NOT NULL,
  Mixologist INT NOT NULL,
  Person_ID INT NOT NULL,
  PRIMARY KEY (Person_ID),
  FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
);

CREATE TABLE Supplier
(
  Kosher_type VARCHAR(50) NOT NULL,
  Frequency INT NOT NULL,
  Person_ID INT NOT NULL,
  PRIMARY KEY (Person_ID),
  FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
);

CREATE TABLE Bartender_Academic_Institution
(
  Academic_Institution VARCHAR(255) NOT NULL,
  Person_ID INT NOT NULL,
  PRIMARY KEY (Academic_Institution, Person_ID),
  FOREIGN KEY (Person_ID) REFERENCES Bartender(Person_ID)
);

CREATE TABLE Product
(
  Vegetarian INT NOT NULL,
  Quantity INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Storage_space INT NOT NULL,
  Price NUMERIC(10,2) NOT NULL,
  Product_ID INT NOT NULL,
  Nut_free INT NOT NULL,
  Gluten_free INT NOT NULL,
  Vegan INT NOT NULL,
  Brand VARCHAR(100) NOT NULL,
  Shelf_life INT NOT NULL,
  Type VARCHAR(50) NOT NULL,
  Storage_ID INT NOT NULL,
  Person_ID INT NOT NULL,
  PRIMARY KEY (Product_ID),
  FOREIGN KEY (Storage_ID) REFERENCES Storage(Storage_ID),
  FOREIGN KEY (Person_ID) REFERENCES Supplier(Person_ID)
);

CREATE TABLE Drink
(
  Type VARCHAR(50) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Price NUMERIC(10,2) NOT NULL,
  Flavor VARCHAR(50) NOT NULL,
  Sugar_Free INT NOT NULL,
  Drink_ID INT NOT NULL,
  Carbonation INT NOT NULL,
  Serving_Size INT NOT NULL,
  Alcohol_Content NUMERIC(5,2) NOT NULL,
  Prep_time INT NOT NULL,
  Person_ID INT NOT NULL,
  PRIMARY KEY (Drink_ID),
  FOREIGN KEY (Person_ID) REFERENCES Bartender(Person_ID)
);

CREATE TABLE OrdersDrink
(
  Drink_ID INT NOT NULL,
  Order_ID INT NOT NULL,
  PRIMARY KEY (Drink_ID, Order_ID),
  FOREIGN KEY (Drink_ID) REFERENCES Drink(Drink_ID),
  FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

CREATE TABLE DrinkProducts
(
  Drink_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  PRIMARY KEY (Drink_ID, Product_ID),
  FOREIGN KEY (Drink_ID) REFERENCES Drink(Drink_ID),
  FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);
