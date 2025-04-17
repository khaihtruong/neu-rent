import pymysql
from tabulate import tabulate
import re

def edit_listing(cur, conn, authenticated_email):
    print("\n=== Edit Property Listing ===")
    
    # Get the user's ID using their email
    cur.execute("SELECT user_id FROM user WHERE email = %s", (authenticated_email,))
    user_result = cur.fetchone()
    
    if not user_result:
        print("Error: User not found.")
        return
    
    user_id = user_result[0]
    
    # Check if user is a landlord
    cur.execute("SELECT user_id FROM landlord WHERE user_id = %s", (user_id,))
    if not cur.fetchone():
        print("You must be a landlord to edit property listings.")
        return
    
    # Show user's properties
    cur.execute(
        """
        SELECT property_id, street_number, street_name, city, state, room_number, 
               square_foot, for_rent, price, room_amount
        FROM properties 
        WHERE landlord_id = %s
        """,
        (user_id,)
    )
    
    properties = cur.fetchall()
    
    if not properties:
        print("You don't have any property listings to edit.")
        return
    
    # Display the properties
    column_headers = ['ID', 'Street #', 'Street Name', 'City', 'State', 'Room #', 
                      'Sq Ft', 'For Rent', 'Price', 'Bedrooms']
    
    print("\nYour property listings:")
    print(tabulate(properties, headers=column_headers, tablefmt="grid"))
    
    # Ask user which property to edit
    try:
        property_id = int(input("\nEnter the ID of the property you want to edit (or 0 to cancel): ").strip())
        if property_id == 0:
            print("Edit operation cancelled.")
            return
    except ValueError:
        print("Invalid input. Please enter a valid property ID.")
        return
    
    # Verify the property exists and belongs to the user
    cur.execute(
        "SELECT * FROM properties WHERE property_id = %s AND landlord_id = %s",
        (property_id, user_id)
    )
    property_to_edit = cur.fetchone()
    
    if not property_to_edit:
        print("Property not found or you don't have permission to edit it.")
        return
    
    # Display current values
    print("\nCurrent property details:")
    column = ['property_id', 'street_number', 'street_name', 'city', 'state', 'room_number', 
             'square_foot', 'for_rent', 'price', 'room_amount', 'landlord_id']
    print(tabulate([property_to_edit], headers=column, tablefmt="grid"))
    
    # Collect and validate new values
    print("\nEnter new values (press Enter to keep current value):")
    
    # Street number
    current_street_number = property_to_edit[1]
    street_number = input(f"Street number [{current_street_number}]: ").strip()
    if not street_number:
        street_number = current_street_number
    
    # Street name
    current_street_name = property_to_edit[2]
    street_name = input(f"Street name [{current_street_name}]: ").strip()
    if not street_name:
        street_name = current_street_name
    
    # City
    current_city = property_to_edit[3]
    city = input(f"City [{current_city}]: ").strip()
    if not city:
        city = current_city
    
    # State
    current_state = property_to_edit[4]
    state = input(f"State (2-letter code) [{current_state}]: ").strip()
    if not state:
        state = current_state
    elif not re.match(r'^[A-Za-z]{2}$', state):
        print("State must be a valid 2-letter code. Keeping current value.")
        state = current_state
    else:
        state = state.upper()  # Standardize to uppercase
    
    # Room number
    current_room_number = property_to_edit[5]
    room_number = input(f"Room number [{current_room_number}]: ").strip()
    if not room_number:
        room_number = current_room_number
    
    # Check if the updated address and room would conflict with existing property
    if (street_number != current_street_number or 
        street_name != current_street_name or 
        city != current_city or 
        state != current_state or 
        room_number != current_room_number):
        
        cur.execute(
            """
            SELECT * FROM properties 
            WHERE street_number = %s AND street_name = %s AND city = %s AND state = %s 
            AND room_number = %s AND property_id != %s
            """,
            (street_number, street_name, city, state, room_number, property_id)
        )
        
        if cur.fetchone():
            print("A property with this address and room number already exists. Changes not saved.")
            return
    
    # Square footage
    current_square_foot = property_to_edit[6]
    square_foot_input = input(f"Square footage [{current_square_foot}]: ").strip()
    if not square_foot_input:
        square_foot = current_square_foot
    else:
        try:
            square_foot = float(square_foot_input)
            if square_foot <= 0:
                print("Square footage must be greater than zero. Keeping current value.")
                square_foot = current_square_foot
        except ValueError:
            print("Invalid input for square footage. Keeping current value.")
            square_foot = current_square_foot
    
    # For rent status
    current_for_rent = "Yes" if property_to_edit[7] else "No"
    for_rent_input = input(f"Is this property for rent? (y/n) [{current_for_rent}]: ").strip().lower()
    if not for_rent_input:
        for_rent = property_to_edit[7]
    elif for_rent_input in ['y', 'yes']:
        for_rent = True
    elif for_rent_input in ['n', 'no']:
        for_rent = False
    else:
        print("Invalid input for rental status. Keeping current value.")
        for_rent = property_to_edit[7]
    
    # Price
    current_price = property_to_edit[8]
    price_input = input(f"Price [{current_price}]: ").strip()
    if not price_input:
        price = current_price
    else:
        try:
            price = float(price_input)
            if price <= 0:
                print("Price must be greater than zero. Keeping current value.")
                price = current_price
        except ValueError:
            print("Invalid input for price. Keeping current value.")
            price = current_price
    
    # Number of bedrooms
    current_room_amount = property_to_edit[9]
    room_amount_input = input(f"Number of bedrooms [{current_room_amount}]: ").strip()
    if not room_amount_input:
        room_amount = current_room_amount
    else:
        try:
            room_amount = int(room_amount_input)
            if room_amount <= 0:
                print("Number of bedrooms must be greater than zero. Keeping current value.")
                room_amount = current_room_amount
        except ValueError:
            print("Invalid input for number of bedrooms. Keeping current value.")
            room_amount = current_room_amount
    
    # Confirm before updating
    confirm = input("\nUpdate this property with the new values? (y/n): ").strip().lower()
    if confirm not in ['y', 'yes']:
        print("Update cancelled.")
        return
    
    # Update the property in the database
    try:
        cur.execute(
            """
            UPDATE properties 
            SET street_number = %s, street_name = %s, city = %s, state = %s, room_number = %s,
                square_foot = %s, for_rent = %s, price = %s, room_amount = %s
            WHERE property_id = %s AND landlord_id = %s
            """,
            (
                street_number, street_name, city, state, room_number,
                square_foot, for_rent, price, room_amount,
                property_id, user_id
            )
        )
        
        conn.commit()
        print("\nProperty listing updated successfully!")
        
        # Show the updated property
        cur.execute("SELECT * FROM properties WHERE property_id = %s", (property_id,))
        updated_property = cur.fetchone()
        
        if updated_property:
            print("\nUpdated property details:")
            print(tabulate([updated_property], headers=column, tablefmt="grid"))
            
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error updating property: {e}")

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
    edit_listing(cur, conn, "test@example.com")
    
    conn.close()
