from functools import reduce
import random
import pandas as pd
import names
from datetime import datetime

random.seed(42)

NUM_RECORDS = 150
OUTPUT_FILE = "updateQuery.sql"

def calcOneDigit(c, i):
    k = [1, 2, 1, 2, 1, 2, 1, 2]
    d = int(c) * k[i]
    return d if d < 10 else d // 10 + d % 10

def calcID2(personalID):
    total = sum(calcOneDigit(c, i) for i, c in enumerate(personalID))
    return str((10 - total) % 10)

def generate_dob(age):
    year = 2024 - age
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    return f"{year:04d}-{month:02d}-{day:02d}"

def generate_address():
    return f"{random.randint(1, 999)} {names.get_last_name()} St."

def generate_phone():
    return f"05{random.randint(0,9)}-{random.randint(1000000,9999999)}"

def generate_person_records():
    persons = []
    for i in range(1, NUM_RECORDS + 1):
        age = random.randint(18, 70)
        name = names.get_full_name()
        dob = generate_dob(age)
        address = generate_address()
        area_code = str(random.randint(1000000, 9999999))
        phone = generate_phone()
        persons.append((i, age, name, dob, address, area_code, phone))
    return persons

def generate_storage_records():
    return [
        (i, random.randint(10, 100), random.randint(500, 2000), random.choice(["Fridge", "Dry", "Freezer"]),
         f"{random.randint(1, 999)} {names.get_last_name()} St.", f"Storage_{i}")
        for i in range(1, NUM_RECORDS + 1)
    ]

def generate_orders_records(bartender_names):
    return [
        (bartender_names[i], f"2024-{random.randint(1, 12):02d}-{random.randint(1, 28):02d}",
         round(random.uniform(0, 100), 2), round(random.uniform(20, 300), 2),
         f"{random.randint(10,23)}:{random.randint(0,59):02d}",
         random.choice(["Cash", "Credit", "Online"]), i + 1)
        for i in range(NUM_RECORDS)
    ]

def generate_bartender_records(person_ids):
    return [
        (random.randint(0, 1), round(random.uniform(30, 80), 2), random.randint(0, 1),
         random.randint(1, 20), random.randint(0, 1), pid)
        for pid in person_ids
    ]

def generate_supplier_records(person_ids):
    return [
        (random.choice(["Kosher", "Non-Kosher", "Strict-Kosher"]), random.randint(1, 30), pid)
        for pid in person_ids
    ]

def generate_academic_institution_records(person_ids):
    institutions = ["Bar-Ilan", "Tel Aviv University", "Technion", "Ben Gurion", "Hebrew University"]
    return [(random.choice(institutions), pid) for pid in person_ids]

def generate_product_records(storage_ids, supplier_ids):
    return [
        (random.randint(0, 1), random.randint(10, 500), f"Product_{i}", random.randint(1, 10),
         round(random.uniform(5, 100), 2), i + 1,
         random.randint(0, 1), random.randint(0, 1), random.randint(0, 1),
         f"Brand_{random.randint(1, 10)}", random.randint(30, 365),
         random.choice(["Liquor", "Mixer", "Ingredient"]), storage_ids[i], supplier_ids[i])
        for i in range(NUM_RECORDS)
    ]

def generate_drink_records(bartender_ids):
    return [
        (random.choice(["Cocktail", "Beer", "Wine", "Soda"]), f"Drink_{i}",
         round(random.uniform(10, 60), 2), random.choice(["Sweet", "Bitter", "Sour"]),
         random.randint(0, 1), i + 1, random.randint(0, 1),
         random.randint(100, 500), round(random.uniform(0.0, 40.0), 2),
         random.randint(1, 10), bartender_ids[i])
        for i in range(NUM_RECORDS)
    ]

def generate_orders_drink_records(order_ids, drink_ids):
    return [(drink_ids[i], order_ids[i]) for i in range(NUM_RECORDS)]

def generate_drink_products_records(drink_ids, product_ids):
    return [(drink_ids[i], product_ids[i]) for i in range(NUM_RECORDS)]

def to_sql_insert(table, columns, rows):
    sql_statements = []
    for row in rows:
        values = ", ".join(f"'{v}'" if isinstance(v, str) else str(v) for v in row)
        sql_statements.append(f"INSERT INTO {table}({', '.join(columns)}) VALUES ({values});")
    return sql_statements

# Generating data
person_data = generate_person_records()
person_ids = [p[0] for p in person_data]
bartender_data = generate_bartender_records(person_ids)
supplier_data = generate_supplier_records(person_ids)
academic_data = generate_academic_institution_records(person_ids)
storage_data = generate_storage_records()
storage_ids = [i[0] for i in storage_data]
product_data = generate_product_records(storage_ids, person_ids)
product_ids = [p[5] for p in product_data]
drink_data = generate_drink_records(person_ids)
drink_ids = [d[5] for d in drink_data]
orders_data = generate_orders_records([p[2] for p in person_data])
order_ids = [o[6] for o in orders_data]
orders_drink_data = generate_orders_drink_records(order_ids, drink_ids)
drink_products_data = generate_drink_products_records(drink_ids, product_ids)

# Writing to SQL file
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.writelines("\n".join(to_sql_insert("Person",
        ["Person_ID", "Age", "Name", "Date_of_birth", "Address", "Area_code", "Phone_number"], person_data)) + "\n")
    
    f.writelines("\n".join(to_sql_insert("Bartender",
        ["Beer_Expert", "Wage", "Wine_Specialist", "Experience", "Mixologist", "Person_ID"], bartender_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Supplier",
        ["Kosher_type", "Frequency", "Person_ID"], supplier_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Bartender_Academic_Institution",
        ["Academic_Institution", "Person_ID"], academic_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Storage",
        ["Storage_ID", "Number_of_cells", "Capacity", "Type", "Location", "Name"], storage_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Product",
        ["Vegetarian", "Quantity", "Name", "Storage_space", "Price", "Product_ID",
         "Nut_free", "Gluten_free", "Vegan", "Brand", "Shelf_life", "Type", "Storage_ID", "Person_ID"], product_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Drink",
        ["Type", "Name", "Price", "Flavor", "Sugar_Free", "Drink_ID", "Carbonation",
         "Serving_Size", "Alcohol_Content", "Prep_time", "Person_ID"], drink_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("Orders",
        ["Bartender_name", "Date", "Tip", "Price", "Time", "Payment_method", "Order_ID"], orders_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("OrdersDrink",
        ["Drink_ID", "Order_ID"], orders_drink_data)) + "\n")

    f.writelines("\n".join(to_sql_insert("DrinkProducts",
        ["Drink_ID", "Product_ID"], drink_products_data)) + "\n")

OUTPUT_FILE
