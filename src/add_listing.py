import pymysql
from tabulate import tabulate
import re

def add_listing(cur, conn, authenticated_email):
    print("\n=== Add New Property Listing ===")
    
    # First, verify that the user exists and get their user_id
    cur.execute("SELECT user_id FROM user WHERE email = %s", (authenticated_email,))
    user_result = cur.fetchone()
    if not user_result:
        print("Error: User not found.")
        return

    user_id = user_result[0]
    
    # Check if the user is a landlord (the user should have an entry in the landlord table)
    cur.execute("SELECT user_id FROM landlord WHERE user_id = %s", (user_id,))
    landlord_result = cur.fetchone()
    
    if not landlord_result:
        # If the user is not already a landlord, add them to the landlord table
        try:
            cur.execute("INSERT INTO landlord (user_id) VALUES (%s)", (user_id,))
            conn.commit()
            print("You have been registered as a landlord.")
        except pymysql.Error as e:
            print(f"Error registering as landlord: {e}")
            return
    
    # Now collect property information with validation
    street_number = input("Enter street number: ").strip()
    if not street_number:
        print("Street number cannot be empty.")
        return
    
    street_name = input("Enter street name: ").strip()
    if not street_name:
        print("Street name cannot be empty.")
        return
    
    city = input("Enter city: ").strip()
    if not city:
        print("City cannot be empty.")
        return
    
    state = input("Enter state (2-letter code): ").strip()
    if not re.match(r'^[A-Za-z]{2}$', state):
        print("State must be a valid 2-letter code.")
        return
    state = state.upper()  # Standardize to uppercase
    
    room_number = input("Enter room number: ").strip()
    if not room_number:
        print("Room number cannot be empty.")
        return
    
    # Check if property with same address and room already exists
    cur.execute(
        "SELECT * FROM properties WHERE street_number = %s AND street_name = %s AND city = %s AND state = %s AND room_number = %s",
        (street_number, street_name, city, state, room_number)
    )
    if cur.fetchone():
        print("A property with this address and room number already exists.")
        return
    
    # Validate and collect numeric values
    try:
        square_foot = float(input("Enter square footage: ").strip())
        if square_foot <= 0:
            print("Square footage must be greater than zero.")
            return
    except ValueError:
        print("Square footage must be a valid number.")
        return
    
    for_rent_input = input("Is this property for rent? (y/n): ").strip().lower()
    if for_rent_input not in ['y', 'n', 'yes', 'no']:
        print("Please enter 'y' or 'n'.")
        return
    for_rent = for_rent_input in ['y', 'yes']
    
    try:
        price = float(input("Enter price: ").strip())
        if price <= 0:
            print("Price must be greater than zero.")
            return
    except ValueError:
        print("Price must be a valid number.")
        return
    
    try:
        room_amount = int(input("Enter number of bedrooms: ").strip())
        if room_amount <= 0:
            print("Number of bedrooms must be greater than zero.")
            return
    except ValueError:
        print("Number of bedrooms must be a valid integer.")
        return
    
    # Optional: Associate with a neighborhood
    add_neighborhood = input("Would you like to associate this property with a neighborhood? (y/n): ").strip().lower()
    neighborhood_id = None
    
    if add_neighborhood in ['y', 'yes']:
        # Show available neighborhoods
        cur.execute("SELECT neighborhood_id, name FROM neighborhood")
        neighborhoods = cur.fetchall()
        
        if not neighborhoods:
            print("No neighborhoods found in the database.")
        else:
            neighborhood_table = []
            for n in neighborhoods:
                neighborhood_table.append([n[0], n[1]])
            
            print("\nAvailable Neighborhoods:")
            print(tabulate(neighborhood_table, headers=["ID", "Name"], tablefmt="grid"))
            
            try:
                neighborhood_id = int(input("\nEnter neighborhood ID (or 0 to skip): ").strip())
                if neighborhood_id != 0:
                    # Verify neighborhood exists
                    cur.execute("SELECT neighborhood_id FROM neighborhood WHERE neighborhood_id = %s", (neighborhood_id,))
                    if not cur.fetchone():
                        print("Invalid neighborhood ID. Property will be added without neighborhood association.")
                        neighborhood_id = None
            except ValueError:
                print("Invalid input. Property will be added without neighborhood association.")
                neighborhood_id = None
    
    # Insert the new property into the database
    try:
        cur.execute(
            """
            INSERT INTO properties 
            (street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, landlord_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (street_number, street_name, city, state, room_number, square_foot, for_rent, price, room_amount, user_id)
        )
        
        # Get the property_id of the newly inserted property
        property_id = cur.lastrowid
        
        # If a neighborhood was selected, add the association
        if neighborhood_id:
            cur.execute(
                "INSERT INTO property_neighborhood (property_id, neighborhood_id) VALUES (%s, %s)",
                (property_id, neighborhood_id)
            )
        
        conn.commit()
        print("\nProperty listing added successfully!")
        
        # Display the added property
        cur.execute("SELECT * FROM properties WHERE property_id = %s", (property_id,))
        new_property = cur.fetchone()
        
        if new_property:
            column = ['property_id', 'street_number', 'street_name', 'city', 'state', 'room_number', 
                     'square_foot', 'for_rent', 'price', 'room_amount', 'landlord_id']
            
            print("\nYour new property listing:")
            print(tabulate([new_property], headers=column, tablefmt="grid"))
        
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error adding property: {e}")

if __name__ == "__main__":
    # This is just for testing in isolation
    import getpass
    
    conn = pymysql.connect(
        host="localhost",
        user=input("Enter username for MySQL server: "),
        password=getpass.getpass("Enter the password for MySQL server: "),
        db="rental_system"
    )
    
    cur = conn.cursor()
    add_listing(cur, conn, "test@example.com")
    
    conn.close()
