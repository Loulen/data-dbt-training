import csv
import random
import datetime
import os

# --- Configuration ---
NUM_RESTAURANTS = 15
NUM_DISHES = 75
NUM_ORDERS = 1000

OUTPUT_DIR = "src/seeds/sample"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

RESTAURANTS_FILE = os.path.join(OUTPUT_DIR, "sample_restaurants.csv")
DISHES_FILE = os.path.join(OUTPUT_DIR, "sample_dishes.csv")
ORDERS_FILE = os.path.join(OUTPUT_DIR, "sample_orders.csv")

# --- Data Generation ---

# --- Restaurants ---
print(f"Generating {NUM_RESTAURANTS} restaurants...")
restaurants = []
restaurant_ids = set()

# Add existing restaurants
existing_restaurants = [
    {'IDENTIFIER': 3, 'NAME': 'Chez tjumeaux', 'ADDRESS': 'Avenue de la Grande Armee - Paris', 'NB_EMPLOYEES': 2, 'OPEN_ON_SUNDAY': True},
    {'IDENTIFIER': 7, 'NAME': 'Chez siribarne', 'ADDRESS': 'Allees de Tourny - Bordeaux', 'NB_EMPLOYEES': 10, 'OPEN_ON_SUNDAY': True}
]
restaurants.extend(existing_restaurants)
for r in existing_restaurants:
    restaurant_ids.add(r['IDENTIFIER'])

# Generate new restaurants
cities = ["Lyon", "Marseille", "Toulouse", "Nice", "Nantes", "Strasbourg", "Montpellier", "Lille"]
street_types = ["Rue", "Avenue", "Boulevard", "Place"]
street_names = ["de la Republique", "Victor Hugo", "Gambetta", "Jean Jaures", "Foch", "Pasteur", "Thiers"]
restaurant_prefixes = ["Le", "La", "Au", "Restaurant"]
restaurant_suffixes = ["Gourmand", "Savoyard", "Provencal", "Breton", "du Marche", "Rapide", "Traditionnel"]

next_restaurant_id = max(restaurant_ids) + 1 if restaurant_ids else 1
while len(restaurants) < NUM_RESTAURANTS:
    if next_restaurant_id not in restaurant_ids:
        name = f"{random.choice(restaurant_prefixes)} {random.choice(restaurant_suffixes)} {next_restaurant_id}"
        address = f"{random.choice(street_types)} {random.choice(street_names)} - {random.choice(cities)}"
        employees = random.randint(1, 15)
        open_sunday = random.choice([True, False])
        restaurants.append({
            'IDENTIFIER': next_restaurant_id,
            'NAME': name,
            'ADDRESS': address,
            'NB_EMPLOYEES': employees,
            'OPEN_ON_SUNDAY': open_sunday
        })
        restaurant_ids.add(next_restaurant_id)
    next_restaurant_id += 1

# Write Restaurants CSV
with open(RESTAURANTS_FILE, 'w', newline='') as csvfile:
    fieldnames = ['IDENTIFIER', 'NAME', 'ADDRESS', 'NB_EMPLOYEES', 'OPEN_ON_SUNDAY']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(restaurants)
print(f"Written {len(restaurants)} restaurants to {RESTAURANTS_FILE}")

# --- Dishes ---
print(f"Generating {NUM_DISHES} dishes...")
dishes = []
dish_details = {} # Store details for order generation {id: {price: X, cost: Y}}

# Add existing dishes
existing_dishes = [
    {'IDENTIFIER': 3, 'NAME': 'Demi peche', 'SELLING_PRICE': 4, 'PRODUCTION_COST': 2.5, 'TYPE': 'boisson'},
    {'IDENTIFIER': 9, 'NAME': 'Flammkueche au munster', 'SELLING_PRICE': 10, 'PRODUCTION_COST': 5, 'TYPE': 'plat'},
    {'IDENTIFIER': 18, 'NAME': 'Tarte au citron', 'SELLING_PRICE': 6, 'PRODUCTION_COST': 4, 'TYPE': 'dessert'}
]
dishes.extend(existing_dishes)
for d in existing_dishes:
    dish_details[d['IDENTIFIER']] = {'price': d['SELLING_PRICE'], 'cost': d['PRODUCTION_COST']}

# Generate new dishes
dish_types = ['boisson', 'plat', 'dessert', 'entree', 'accompagnement']
dish_name_parts1 = ["Soupe", "Salade", "Gratin", "Poulet", "Boeuf", "Poisson", "Legumes", "Pates", "Riz", "Cafe", "The", "Jus", "Vin", "Biere", "Tarte", "Mousse", "Glace"]
dish_name_parts2 = ["du Jour", "Verte", "Composee", "Dauphinois", "Roti", "Bourguignon", "Meuniere", "Sautes", "Carbonara", "Basmati", "Gourmand", "Vert", "Orange", "Rouge", "Blonde", "Pommes", "Chocolat", "Vanille"]

next_dish_id = max(dish_details.keys()) + 1 if dish_details else 1
while len(dishes) < NUM_DISHES:
     if next_dish_id not in dish_details:
        dish_type = random.choice(dish_types)
        name = f"{random.choice(dish_name_parts1)} {random.choice(dish_name_parts2)} {next_dish_id}"
        if dish_type == 'boisson':
            price = round(random.uniform(2, 6), 2)
            cost = round(price * random.uniform(0.3, 0.7), 2)
        elif dish_type == 'dessert' or dish_type == 'entree':
             price = round(random.uniform(5, 12), 2)
             cost = round(price * random.uniform(0.4, 0.6), 2)
        else: # plat, accompagnement
             price = round(random.uniform(10, 25), 2)
             cost = round(price * random.uniform(0.3, 0.5), 2)

        dishes.append({
            'IDENTIFIER': next_dish_id,
            'NAME': name,
            'SELLING_PRICE': price,
            'PRODUCTION_COST': cost,
            'TYPE': dish_type
        })
        dish_details[next_dish_id] = {'price': price, 'cost': cost}
     next_dish_id += 1

# Write Dishes CSV
with open(DISHES_FILE, 'w', newline='') as csvfile:
    fieldnames = ['IDENTIFIER', 'NAME', 'SELLING_PRICE', 'PRODUCTION_COST', 'TYPE']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(dishes)
print(f"Written {len(dishes)} dishes to {DISHES_FILE}")

# --- Orders ---
print(f"Generating {NUM_ORDERS} orders...")
orders = []
order_ids = set()
available_dish_ids = list(dish_details.keys())
available_restaurant_ids = list(restaurant_ids)
payment_methods = ['cash', 'card', 'online', 'voucher']

# Add existing orders
existing_orders = [
     {'IDENTIFIER': 3, 'RESTAURANT_IDENTIFIER': 7, 'DISHES_IDS': '[3]', 'PAYMENT_METHOD': 'cash', 'AMOUNT': 18, 'CREATED_AT': '2022-04-09 17:54:07'},
     {'IDENTIFIER': 40, 'RESTAURANT_IDENTIFIER': 7, 'DISHES_IDS': '[9, 18]', 'PAYMENT_METHOD': 'card', 'AMOUNT': 40, 'CREATED_AT': '2022-05-01 20:56:59'}
]
# Recalculate amount for existing orders based on current dish prices
for o in existing_orders:
    total_amount = 0
    try:
        # Attempt to parse the list string, handle potential errors
        ids_str = o['DISHES_IDS'].strip('[]')
        if ids_str:
             dish_ids_in_order = [int(x.strip()) for x in ids_str.split(',')]
             for dish_id in dish_ids_in_order:
                 if dish_id in dish_details:
                     total_amount += dish_details[dish_id]['price']
                 else:
                     print(f"Warning: Dish ID {dish_id} from existing order {o['IDENTIFIER']} not found in dishes. Skipping for amount calculation.")
        o['AMOUNT'] = round(total_amount, 2) # Update amount
    except ValueError:
         print(f"Warning: Could not parse DISHES_IDS '{o['DISHES_IDS']}' for existing order {o['IDENTIFIER']}. Amount might be incorrect.")
         # Keep original amount if parsing fails
    orders.append(o)
    order_ids.add(o['IDENTIFIER'])


# Generate new orders
start_date = datetime.datetime.now() - datetime.timedelta(days=730) # Start 2 years ago
end_date = datetime.datetime.now()

next_order_id = max(order_ids) + 1 if order_ids else 1
while len(orders) < NUM_ORDERS:
    if next_order_id not in order_ids:
        restaurant_id = random.choice(available_restaurant_ids)
        num_dishes_in_order = random.randint(1, 5)
        dishes_in_order_ids = random.choices(available_dish_ids, k=num_dishes_in_order) # Allow duplicates

        total_amount = 0
        for dish_id in dishes_in_order_ids:
            total_amount += dish_details[dish_id]['price']

        # Generate random timestamp
        random_seconds = random.randint(0, int((end_date - start_date).total_seconds()))
        created_at = start_date + datetime.timedelta(seconds=random_seconds)

        orders.append({
            'IDENTIFIER': next_order_id,
            'RESTAURANT_IDENTIFIER': restaurant_id,
            'DISHES_IDS': str(dishes_in_order_ids), # Store as string representation of list
            'PAYMENT_METHOD': random.choice(payment_methods),
            'AMOUNT': round(total_amount, 2),
            'CREATED_AT': created_at.strftime('%Y-%m-%d %H:%M:%S')
        })
        order_ids.add(next_order_id)
    next_order_id += 1

# Write Orders CSV
with open(ORDERS_FILE, 'w', newline='') as csvfile:
    fieldnames = ['IDENTIFIER', 'RESTAURANT_IDENTIFIER', 'DISHES_IDS', 'PAYMENT_METHOD', 'AMOUNT', 'CREATED_AT']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(orders)
print(f"Written {len(orders)} orders to {ORDERS_FILE}")

print("Sample data generation complete.")
