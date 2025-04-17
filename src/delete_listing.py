import pymysql
from tabulate import tabulate

def delete_listing(cur, conn, authenticated_email):
    print("\n=== Delete Property Listing ===")
    
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
        print("You must be a landlord to delete property listings.")
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
        print("You don't have any property listings to delete.")
        return
    
    # Display the properties
    column_headers = ['ID', 'Street #', 'Street Name', 'City', 'State', 'Room #', 
                      'Sq Ft', 'For Rent', 'Price', 'Bedrooms']
    
    print("\nYour property listings:")
    print(tabulate(properties, headers=column_headers, tablefmt="grid"))
    
    # Ask user which property to delete
    try:
        property_id = int(input("\nEnter the ID of the property you want to delete (or 0 to cancel): ").strip())
        if property_id == 0:
            print("Delete operation cancelled.")
            return
    except ValueError:
        print("Invalid input. Please enter a valid property ID.")
        return
    
    # Verify the property exists and belongs to the user
    cur.execute(
        "SELECT * FROM properties WHERE property_id = %s AND landlord_id = %s",
        (property_id, user_id)
    )
    property_to_delete = cur.fetchone()
    
    if not property_to_delete:
        print("Property not found or you don't have permission to delete it.")
        return
    
    # Display property details before deletion
    print("\nProperty to delete:")
    column = ['property_id', 'street_number', 'street_name', 'city', 'state', 'room_number', 
             'square_foot', 'for_rent', 'price', 'room_amount', 'landlord_id']
    print(tabulate([property_to_delete], headers=column, tablefmt="grid"))
    
    # Check if the property is currently rented
    cur.execute(
        "SELECT * FROM rent WHERE property_id = %s AND end_date > CURRENT_DATE",
        (property_id,)
    )
    active_rental = cur.fetchone()
    
    if active_rental:
        print("Warning: This property has an active rental agreement. Deleting it may affect tenant records.")
    
    # Double-confirm deletion
    confirm = input("\nAre you sure you want to delete this property? This action cannot be undone. (y/n): ").strip().lower()
    if confirm not in ['y', 'yes']:
        print("Delete operation cancelled.")
        return
    
    # Proceed with deletion
    try:
        # First delete from property_neighborhood (if exists)
        cur.execute("DELETE FROM property_neighborhood WHERE property_id = %s", (property_id,))
        
        # Delete any rent records associated with this property
        cur.execute("DELETE FROM rent WHERE property_id = %s", (property_id,))
        
        # Finally delete the property itself
        cur.execute("DELETE FROM properties WHERE property_id = %s AND landlord_id = %s", (property_id, user_id))
        
        # Check if any rows were affected
        if cur.rowcount > 0:
            conn.commit()
            print("\nProperty listing deleted successfully!")
        else:
            conn.rollback()
            print("No property was deleted. It may have been removed already.")
            
    except pymysql.Error as e:
        conn.rollback()
        print(f"Error deleting property: {e}")

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
    delete_listing(cur, conn, "test@example.com")
    
    conn.close()
