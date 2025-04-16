import mysql.connector
from mysql.connector import Error
import getpass
import sys
from datetime import datetime, timedelta
import re

class RentalSystem:
    def __init__(self):
        self.connection = None
        self.current_user = None
        self.current_user_id = None

    def connect_to_database(self):
        """Connect to the MySQL database."""
        try:
            self.connection = mysql.connector.connect(
                host='localhost',
                database='rental_system',
                user='root',  # Replace with your MySQL username
                password='red'  # Replace with your MySQL password
            )
            if self.connection.is_connected():
                print("Connected to MySQL database")
                return True
        except Error as e:
            print(f"Error connecting to MySQL database: {e}")
            return False
        return False

    def login(self, username):
        """Login by username."""
        try:
            if not self.connection or not self.connection.is_connected():
                if not self.connect_to_database():
                    return False
                
            cursor = self.connection.cursor(dictionary=True)
            
            # Get user information from username
            query = """
            SELECT u.user_id, u.first_name, u.last_name, u.email, ua.username
            FROM user u
            JOIN user_auth ua ON u.auth_id = ua.auth_id
            WHERE ua.username = %s
            """
            cursor.execute(query, (username,))
            user_info = cursor.fetchone()
            
            if not user_info:
                print("Username not found.")
                return False
            
            self.current_user_id = user_info['user_id']
            self.current_user = f"{user_info['first_name']} {user_info['last_name']}"
            
            cursor.close()
            print(f"Welcome, {self.current_user}!")
            return True
            
        except Error as e:
            print(f"Error during login: {e}")
            return False

    def display_menu(self):
        """Display the main menu with all options."""
        print("\n===== RENTAL SYSTEM MENU =====")
        print("1. View My Profile")
        print("2. Manage Properties")
        print("3. View My Tenants")
        print("4. View My Rentals")
        print("5. View Available Properties")
        print("6. Rent a Property")
        print("7. Update My Personal Information")
        print("8. Manage Broker Activities")
        print("0. Logout")
        
        while True:
            choice = input("Enter your choice: ")
            if choice in ['0', '1', '2', '3', '4', '5', '6', '7', '8']:
                return choice
            else:
                print("Invalid choice. Please enter a number between 0 and 8.")

    def validate_ssn(self, ssn):
        """Validate Social Security Number format."""
        # Check for XXX-XX-XXXX format
        if re.match(r'^\d{3}-\d{2}-\d{4}$', ssn):
            return True
        # Check for XXXXXXXXX format
        elif re.match(r'^\d{9}$', ssn):
            return True
        else:
            print("Invalid SSN format. Please use XXX-XX-XXXX or XXXXXXXXX format.")
            return False

    def validate_phone(self, phone):
        """Validate phone number format."""
        # Remove any non-digit characters for validation
        digits_only = re.sub(r'\D', '', phone)
        
        # Check if it has 10 digits (US phone number)
        if len(digits_only) == 10:
            return True
        # Check if it has country code (e.g., +1 for US)
        elif len(digits_only) == 11 and digits_only[0] == '1':
            return True
        else:
            print("Invalid phone number format. Please use a 10-digit number or include country code.")
            return False

    def validate_email(self, email):
        """Validate email format."""
        if re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
            return True
        else:
            print("Invalid email format. Please enter a valid email address.")
            return False

    def validate_date(self, date_str, date_format="%Y-%m-%d"):
        """Validate date format and return datetime object if valid."""
        try:
            date_obj = datetime.strptime(date_str, date_format)
            return date_obj
        except ValueError:
            print(f"Invalid date format. Please use {date_format} format.")
            return None

    def get_date_input(self, prompt, date_format="%Y-%m-%d", allow_empty=False):
        """Get a valid date input from the user."""
        while True:
            date_str = input(prompt)
            if allow_empty and not date_str:
                return None
            
            date_obj = self.validate_date(date_str, date_format)
            if date_obj:
                return date_obj.date()

    def get_numeric_input(self, prompt, input_type=float, min_value=None, max_value=None, allow_empty=False):
        """Get a valid numeric input from the user."""
        while True:
            value_str = input(prompt)
            if allow_empty and not value_str:
                return None
            
            try:
                value = input_type(value_str)
                
                if min_value is not None and value < min_value:
                    print(f"Value must be at least {min_value}.")
                    continue
                    
                if max_value is not None and value > max_value:
                    print(f"Value must be at most {max_value}.")
                    continue
                    
                return value
            except ValueError:
                print(f"Invalid input. Please enter a valid {input_type.__name__}.")

    def view_profile(self):
        """View the current user's profile information."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            # Get basic user information
            query = """
            SELECT u.user_id, u.first_name, u.last_name, u.phone, u.email, 
                   ua.username, ua.last_login
            FROM user u
            JOIN user_auth ua ON u.auth_id = ua.auth_id
            WHERE u.user_id = %s
            """
            cursor.execute(query, (self.current_user_id,))
            user_info = cursor.fetchone()
            
            if not user_info:
                print("User information not found.")
                return
            
            print("\n===== USER PROFILE =====")
            print(f"Name: {user_info['first_name']} {user_info['last_name']}")
            print(f"Username: {user_info['username']}")
            print(f"Email: {user_info['email']}")
            print(f"Phone: {user_info['phone']}")
            print(f"Last Login: {user_info['last_login']}")
            
            # Check for landlord status
            query = "SELECT * FROM landlord WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            landlord_data = cursor.fetchone()
            
            if landlord_data:
                print("Registered as: Landlord")
            
            # Check for tenant status
            query = "SELECT * FROM tenant WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            tenant_data = cursor.fetchone()
            
            if tenant_data:
                print("Registered as: Tenant")
            
            # Check for US Citizen status
            query = "SELECT ssn FROM us_citizen WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            us_citizen = cursor.fetchone()
            
            if us_citizen:
                print("Status: US Citizen")
                print(f"SSN: {us_citizen['ssn']}")
            
            # Check for International Student status
            query = "SELECT passport_id FROM international_student WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            intl_student = cursor.fetchone()
            
            if intl_student:
                print("Status: International Student")
                print(f"Passport ID: {intl_student['passport_id']}")
            
            # Check for Student status
            query = "SELECT * FROM student WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            student = cursor.fetchone()
            
            if student:
                print("Status: Student")
            
            # Get occupation information
            query = """
            SELECT o.occupation_name
            FROM occupation o
            WHERE o.user_id = %s
            """
            cursor.execute(query, (self.current_user_id,))
            occupation = cursor.fetchone()
            
            if occupation:
                print(f"Occupation: {occupation['occupation_name']}")
            
            # Get financial provider information if applicable
            query = """
            SELECT fp.passport_id, fp.phone, fp.relationship
            FROM financial_provider fp
            JOIN financial_provider_user fpu ON fp.provider_id = fpu.provider_id
            WHERE fpu.user_id = %s
            """
            cursor.execute(query, (self.current_user_id,))
            providers = cursor.fetchall()
            
            if providers:
                print("\nFinancial Providers:")
                for provider in providers:
                    print(f"  Relationship: {provider['relationship']}")
                    print(f"  Passport ID: {provider['passport_id']}")
                    print(f"  Phone: {provider['phone']}")
            
            # Check broker information
            query = """
            SELECT b.broker_id, b.license_id, b.ssn, b.phone
            FROM broker b
            WHERE b.first_name = %s AND b.last_name = %s
            """
            cursor.execute(query, (user_info['first_name'], user_info['last_name']))
            broker_data = cursor.fetchone()
            
            if broker_data:
                print("\nBroker Information:")
                print(f"  Broker ID: {broker_data['broker_id']}")
                print(f"  License ID: {broker_data['license_id']}")
                print(f"  SSN: {broker_data['ssn']}")
                print(f"  Phone: {broker_data['phone']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving profile: {e}")

    def manage_properties(self):
        """Manage properties."""
        # Check if user is a landlord, if not register them
        try:
            cursor = self.connection.cursor(dictionary=True)
            query = "SELECT * FROM landlord WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            is_landlord = cursor.fetchone()
            
            if not is_landlord:
                print("You are not registered as a landlord yet.")
                while True:
                    register = input("Do you want to register as a landlord? (y/n): ").lower()
                    if register in ['y', 'n']:
                        if register == 'y':
                            query = "INSERT INTO landlord (user_id) VALUES (%s)"
                            cursor.execute(query, (self.current_user_id,))
                            self.connection.commit()
                            print("You have been registered as a landlord.")
                        else:
                            print("You need to be a landlord to manage properties.")
                            return
                        break
                    else:
                        print("Invalid input. Please enter 'y' or 'n'.")
            
            cursor.close()
            
        except Error as e:
            print(f"Error checking landlord status: {e}")
            return
        
        while True:
            print("\n===== PROPERTY MANAGEMENT =====")
            print("1. View My Properties")
            print("2. Add New Property")
            print("3. Update Property")
            print("4. Remove Property")
            print("0. Back to Main Menu")
            
            while True:
                choice = input("Enter your choice: ")
                if choice in ['0', '1', '2', '3', '4']:
                    break
                else:
                    print("Invalid choice. Please enter a number between 0 and 4.")
            
            if choice == '1':
                self.view_my_properties()
            elif choice == '2':
                self.add_property()
            elif choice == '3':
                self.update_property()
            elif choice == '4':
                self.remove_property()
            elif choice == '0':
                break

    def view_my_properties(self):
        """View properties owned by the current user."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            query = """
            SELECT p.property_id, p.street_number, p.street_name, p.city, p.state, 
                   p.room_number, p.square_foot, p.for_rent, p.price, p.room_amount
            FROM properties p
            WHERE p.landlord_id = %s
            ORDER BY p.property_id
            """
            cursor.execute(query, (self.current_user_id,))
            properties = cursor.fetchall()
            
            if not properties:
                print("You don't have any properties listed.")
                return
            
            print("\n===== MY PROPERTIES =====")
            for prop in properties:
                print(f"\nProperty ID: {prop['property_id']}")
                print(f"Address: {prop['street_number']} {prop['street_name']}, {prop['city']}, {prop['state']}")
                print(f"Room: {prop['room_number']}")
                print(f"Square Footage: {prop['square_foot']} sq ft")
                print(f"Available for Rent: {'Yes' if prop['for_rent'] else 'No'}")
                print(f"Price: ${prop['price']}")
                print(f"Number of Rooms: {prop['room_amount']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving properties: {e}")

    def add_property(self):
        """Add a new property."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            print("\n===== ADD NEW PROPERTY =====")
            
            # Validate street number
            while True:
                street_number = input("Street Number: ")
                if street_number.strip():
                    if street_number.isdigit() or re.match(r'^\d+[A-Za-z]?$', street_number):
                        break
                    else:
                        print("Invalid street number. Please enter a valid street number.")
                else:
                    print("Street number cannot be empty.")
            
            # Validate street name
            while True:
                street_name = input("Street Name: ")
                if street_name.strip():
                    break
                else:
                    print("Street name cannot be empty.")
            
            # Validate city
            while True:
                city = input("City: ")
                if city.strip():
                    if all(c.isalpha() or c.isspace() or c == '-' for c in city):
                        break
                    else:
                        print("Invalid city name. Please use only letters, spaces, and hyphens.")
                else:
                    print("City cannot be empty.")
            
            # Validate state
            while True:
                state = input("State: ")
                if state.strip():
                    if all(c.isalpha() or c.isspace() for c in state):
                        break
                    else:
                        print("Invalid state name. Please use only letters and spaces.")
                else:
                    print("State cannot be empty.")
            
            # Validate room number
            room_number = input("Room Number (leave empty if not applicable): ")
            
            # Check if property already exists
            cursor = self.connection.cursor(dictionary=True)
            query = """
            SELECT * FROM properties 
            WHERE street_number = %s AND street_name = %s AND city = %s AND state = %s AND room_number = %s
            """
            cursor.execute(query, (street_number, street_name, city, state, room_number))
            existing = cursor.fetchone()
            
            if existing:
                print("Property with this address and room number already exists.")
                return
            
            # Get additional property details with validation
            square_foot = self.get_numeric_input("Square Footage: ", float, min_value=0)
            if square_foot is None:
                return
                
            price = self.get_numeric_input("Monthly Price ($): ", float, min_value=0)
            if price is None:
                return
                
            room_amount = self.get_numeric_input("Number of Rooms: ", int, min_value=1)
            if room_amount is None:
                return
            
            while True:
                for_rent_input = input("Available for Rent (y/n): ").lower()
                if for_rent_input in ['y', 'n']:
                    for_rent = for_rent_input == 'y'
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            
            # Insert new property
            insert_query = """
            INSERT INTO properties (street_number, street_name, city, state, room_number, 
                                   square_foot, for_rent, price, room_amount, landlord_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(insert_query, (street_number, street_name, city, state, room_number, 
                                        square_foot, for_rent, price, room_amount, self.current_user_id))
            
            self.connection.commit()
            print("Property added successfully!")
            
            property_id = cursor.lastrowid
            
            # Ask if user wants to add neighborhood
            while True:
                add_neighborhood_input = input("Do you want to add this property to a neighborhood? (y/n): ").lower()
                if add_neighborhood_input in ['y', 'n']:
                    add_neighborhood = add_neighborhood_input == 'y'
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            
            if add_neighborhood:
                # Show available neighborhoods
                query = "SELECT neighborhood_id, name FROM neighborhood"
                cursor.execute(query)
                neighborhoods = cursor.fetchall()
                
                if not neighborhoods:
                    print("No neighborhoods available in the system.")
                else:
                    print("\nAvailable Neighborhoods:")
                    for hood in neighborhoods:
                        print(f"{hood['neighborhood_id']}. {hood['name']}")
                    
                    while True:
                        neighborhood_id_input = input("Enter Neighborhood ID (or 0 to skip): ")
                        if neighborhood_id_input.isdigit():
                            neighborhood_id = int(neighborhood_id_input)
                            if neighborhood_id == 0:
                                break
                                
                            # Check if neighborhood exists
                            found = False
                            for hood in neighborhoods:
                                if hood['neighborhood_id'] == neighborhood_id:
                                    found = True
                                    break
                            
                            if found:
                                # Insert property-neighborhood relation
                                query = """
                                INSERT INTO property_neighborhood (property_id, neighborhood_id)
                                VALUES (%s, %s)
                                """
                                cursor.execute(query, (property_id, neighborhood_id))
                                self.connection.commit()
                                print("Property added to neighborhood successfully.")
                                break
                            else:
                                print("Invalid neighborhood ID. Please select from the list.")
                        else:
                            print("Invalid input. Please enter a number.")
            
            cursor.close()
            
        except Error as e:
            print(f"Error adding property: {e}")

    def update_property(self):
        """Update property information."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            property_id = self.get_numeric_input("Enter the Property ID to update: ", int, min_value=1)
            if property_id is None:
                return
            
            cursor = self.connection.cursor(dictionary=True)
            
            # Check if property exists and belongs to the user
            query = """
            SELECT * FROM properties 
            WHERE property_id = %s AND landlord_id = %s
            """
            cursor.execute(query, (property_id, self.current_user_id))
            property_data = cursor.fetchone()
            
            if not property_data:
                print("Property not found or you don't have permission to update it.")
                return
            
            print("\n===== UPDATE PROPERTY =====")
            print(f"Current Address: {property_data['street_number']} {property_data['street_name']}, "
                  f"{property_data['city']}, {property_data['state']}, Room {property_data['room_number']}")
            print(f"Current Square Footage: {property_data['square_foot']} sq ft")
            print(f"Current Price: ${property_data['price']}")
            print(f"Current Room Amount: {property_data['room_amount']}")
            print(f"Currently Available for Rent: {'Yes' if property_data['for_rent'] else 'No'}")
            
            print("\nWhich field would you like to update?")
            print("1. Address Information")
            print("2. Square Footage")
            print("3. Price")
            print("4. Room Amount")
            print("5. Availability for Rent")
            
            while True:
                field_choice = input("Enter your choice (or 0 to cancel): ")
                if field_choice in ['0', '1', '2', '3', '4', '5']:
                    break
                else:
                    print("Invalid choice. Please enter a number between 0 and 5.")
            
            if field_choice == '0':
                return
            elif field_choice == '1':
                print("\nUpdating Address:")
                
                # Validate street number
                while True:
                    street_number_input = input(f"Street Number [{property_data['street_number']}]: ")
                    if not street_number_input:
                        street_number = property_data['street_number']
                        break
                    elif street_number_input.isdigit() or re.match(r'^\d+[A-Za-z]?$', street_number_input):
                        street_number = street_number_input
                        break
                    else:
                        print("Invalid street number. Please enter a valid street number.")
                
                # Validate street name
                while True:
                    street_name_input = input(f"Street Name [{property_data['street_name']}]: ")
                    if not street_name_input:
                        street_name = property_data['street_name']
                        break
                    elif street_name_input.strip():
                        street_name = street_name_input
                        break
                    else:
                        print("Street name cannot be empty.")
                
                # Validate city
                while True:
                    city_input = input(f"City [{property_data['city']}]: ")
                    if not city_input:
                        city = property_data['city']
                        break
                    elif city_input.strip() and all(c.isalpha() or c.isspace() or c == '-' for c in city_input):
                        city = city_input
                        break
                    else:
                        print("Invalid city name. Please use only letters, spaces, and hyphens.")
                
                # Validate state
                while True:
                    state_input = input(f"State [{property_data['state']}]: ")
                    if not state_input:
                        state = property_data['state']
                        break
                    elif state_input.strip() and all(c.isalpha() or c.isspace() for c in state_input):
                        state = state_input
                        break
                    else:
                        print("Invalid state name. Please use only letters and spaces.")
                
                room_number = input(f"Room Number [{property_data['room_number']}]: ") or property_data['room_number']
                
                # Check if new address already exists
                check_query = """
                SELECT * FROM properties 
                WHERE street_number = %s AND street_name = %s AND city = %s AND state = %s AND room_number = %s
                AND property_id != %s
                """
                cursor.execute(check_query, (street_number, street_name, city, state, room_number, property_id))
                if cursor.fetchone():
                    print("A property with this address already exists.")
                    return
                
                update_query = """
                UPDATE properties 
                SET street_number = %s, street_name = %s, city = %s, state = %s, room_number = %s
                WHERE property_id = %s
                """
                cursor.execute(update_query, (street_number, street_name, city, state, room_number, property_id))
                
            elif field_choice == '2':
                square_foot = self.get_numeric_input(
                    f"Square Footage [{property_data['square_foot']}]: ", 
                    float, 
                    min_value=0, 
                    allow_empty=True
                )
                
                if square_foot is None:
                    square_foot = property_data['square_foot']
                
                update_query = "UPDATE properties SET square_foot = %s WHERE property_id = %s"
                cursor.execute(update_query, (square_foot, property_id))
                
            elif field_choice == '3':
                price = self.get_numeric_input(
                    f"Price [{property_data['price']}]: ", 
                    float, 
                    min_value=0, 
                    allow_empty=True
                )
                
                if price is None:
                    price = property_data['price']
                
                update_query = "UPDATE properties SET price = %s WHERE property_id = %s"
                cursor.execute(update_query, (price, property_id))
                
            elif field_choice == '4':
                room_amount = self.get_numeric_input(
                    f"Room Amount [{property_data['room_amount']}]: ", 
                    int, 
                    min_value=1, 
                    allow_empty=True
                )
                
                if room_amount is None:
                    room_amount = property_data['room_amount']
                
                update_query = "UPDATE properties SET room_amount = %s WHERE property_id = %s"
                cursor.execute(update_query, (room_amount, property_id))
                
            elif field_choice == '5':
                while True:
                    for_rent_input = input(f"Available for Rent ({'yes' if property_data['for_rent'] else 'no'}) (y/n): ")
                    if for_rent_input.lower() in ['y', 'n']:
                        for_rent_bool = for_rent_input.lower() == 'y'
                        update_query = "UPDATE properties SET for_rent = %s WHERE property_id = %s"
                        cursor.execute(update_query, (for_rent_bool, property_id))
                        break
                    else:
                        print("Invalid input. Please enter 'y' or 'n'.")
            
            self.connection.commit()
            print("Property updated successfully!")
            cursor.close()
            
        except Error as e:
            print(f"Error updating property: {e}")

    def remove_property(self):
        """Remove a property."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            property_id = self.get_numeric_input("Enter the Property ID to remove: ", int, min_value=1)
            if property_id is None:
                return
            
            cursor = self.connection.cursor(dictionary=True)
            
            # Check if property exists and belongs to the user
            query = """
            SELECT * FROM properties 
            WHERE property_id = %s AND landlord_id = %s
            """
            cursor.execute(query, (property_id, self.current_user_id))
            property_data = cursor.fetchone()
            
            if not property_data:
                print("Property not found or you don't have permission to remove it.")
                return
            
            # Check if property has active rentals
            query = """
            SELECT * FROM rent 
            WHERE property_id = %s AND end_date >= CURRENT_DATE
            """
            cursor.execute(query, (property_id,))
            active_rentals = cursor.fetchall()
            
            if active_rentals:
                print("This property has active rental agreements and cannot be removed.")
                print("You need to wait until all rental agreements expire.")
                return
            
            # Confirm removal
            while True:
                confirm = input(f"Are you sure you want to remove property at "
                              f"{property_data['street_number']} {property_data['street_name']}, "
                              f"{property_data['city']}, {property_data['state']}, Room {property_data['room_number']}? (y/n): ")
                
                if confirm.lower() in ['y', 'n']:
                    if confirm.lower() != 'y':
                        print("Property removal cancelled.")
                        return
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            
            # Remove property-neighborhood relations first (due to foreign key constraint)
            query = "DELETE FROM property_neighborhood WHERE property_id = %s"
            cursor.execute(query, (property_id,))
            
            # Remove property
            query = "DELETE FROM properties WHERE property_id = %s"
            cursor.execute(query, (property_id,))
            
            self.connection.commit()
            print("Property removed successfully!")
            cursor.close()
            
        except Error as e:
            print(f"Error removing property: {e}")

    def view_my_tenants(self):
        """View tenants renting properties from the current user."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            # Check if user is a landlord
            cursor = self.connection.cursor(dictionary=True)
            query = "SELECT * FROM landlord WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            is_landlord = cursor.fetchone()
            
            if not is_landlord:
                print("You don't have any properties as you are not registered as a landlord.")
                return
            
            query = """
            SELECT r.rent_id, r.property_id, r.tenant_id, r.start_date, r.end_date, r.price,
                   p.street_number, p.street_name, p.city, p.state, p.room_number,
                   u.first_name, u.last_name, u.phone, u.email
            FROM rent r
            JOIN properties p ON r.property_id = p.property_id
            JOIN user u ON r.tenant_id = u.user_id
            WHERE p.landlord_id = %s
            ORDER BY r.end_date DESC
            """
            cursor.execute(query, (self.current_user_id,))
            rentals = cursor.fetchall()
            
            if not rentals:
                print("You don't have any tenants renting your properties.")
                return
            
            print("\n===== MY TENANTS =====")
            
            # Group rentals by property
            properties = {}
            for rental in rentals:
                prop_id = rental['property_id']
                if prop_id not in properties:
                    properties[prop_id] = {
                        'address': f"{rental['street_number']} {rental['street_name']}, {rental['city']}, {rental['state']}, Room {rental['room_number']}",
                        'tenants': []
                    }
                
                # Check if rental is current or past
                end_date = rental['end_date']
                is_current = end_date >= datetime.now().date()
                
                properties[prop_id]['tenants'].append({
                    'tenant_name': f"{rental['first_name']} {rental['last_name']}",
                    'phone': rental['phone'],
                    'email': rental['email'],
                    'rent_price': rental['price'],
                    'start_date': rental['start_date'],
                    'end_date': rental['end_date'],
                    'is_current': is_current
                })
            
            # Display tenants by property
            for prop_id, data in properties.items():
                print(f"\nProperty: {data['address']}")
                print("Tenants:")
                
                # Sort tenants by current status (current first, then past)
                tenants = sorted(data['tenants'], key=lambda x: x['is_current'], reverse=True)
                
                for tenant in tenants:
                    status = "CURRENT" if tenant['is_current'] else "PAST"
                    print(f"  {tenant['tenant_name']} ({status})")
                    print(f"    Contact: {tenant['phone']} / {tenant['email']}")
                    print(f"    Rental Period: {tenant['start_date']} to {tenant['end_date']}")
                    print(f"    Monthly Rent: ${tenant['rent_price']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving tenants: {e}")

    def view_my_rentals(self):
        """View properties rented by the current user."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            # Check if user is a tenant
            cursor = self.connection.cursor(dictionary=True)
            query = "SELECT * FROM tenant WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            is_tenant = cursor.fetchone()
            
            if not is_tenant:
                print("You are not registered as a tenant.")
                while True:
                    register = input("Do you want to register as a tenant? (y/n): ").lower()
                    if register in ['y', 'n']:
                        if register == 'y':
                            query = "INSERT INTO tenant (user_id) VALUES (%s)"
                            cursor.execute(query, (self.current_user_id,))
                            self.connection.commit()
                            print("You have been registered as a tenant.")
                        else:
                            return
                        break
                    else:
                        print("Invalid input. Please enter 'y' or 'n'.")
            
            query = """
            SELECT r.rent_id, r.property_id, r.start_date, r.end_date, r.price, r.broker_fee,
                   p.street_number, p.street_name, p.city, p.state, p.room_number, p.square_foot,
                   u.first_name AS landlord_first_name, u.last_name AS landlord_last_name, 
                   u.phone AS landlord_phone, u.email AS landlord_email,
                   b.first_name AS broker_first_name, b.last_name AS broker_last_name
            FROM rent r
            JOIN properties p ON r.property_id = p.property_id
            JOIN landlord l ON p.landlord_id = l.user_id
            JOIN user u ON l.user_id = u.user_id
            LEFT JOIN broker b ON r.broker_id = b.broker_id
            WHERE r.tenant_id = %s
            ORDER BY r.end_date DESC
            """
            cursor.execute(query, (self.current_user_id,))
            rentals = cursor.fetchall()
            
            if not rentals:
                print("You don't have any property rentals.")
                return
            
            print("\n===== MY RENTALS =====")
            
            today = datetime.now().date()
            
            # Separate current and past rentals
            current_rentals = [r for r in rentals if r['end_date'] >= today]
            past_rentals = [r for r in rentals if r['end_date'] < today]
            
            if current_rentals:
                print("\nCURRENT RENTALS:")
                for rental in current_rentals:
                    print(f"\nRental ID: {rental['rent_id']}")
                    print(f"Property: {rental['street_number']} {rental['street_name']}, "
                          f"{rental['city']}, {rental['state']}, Room {rental['room_number']}")
                    print(f"Square Footage: {rental['square_foot']} sq ft")
                    print(f"Rental Period: {rental['start_date']} to {rental['end_date']}")
                    print(f"Monthly Rent: ${rental['price']}")
                    
                    if rental['broker_fee'] and rental['broker_first_name']:
                        print(f"Broker: {rental['broker_first_name']} {rental['broker_last_name']}")
                        print(f"Broker Fee: ${rental['broker_fee']}")
                    
                    print(f"Landlord: {rental['landlord_first_name']} {rental['landlord_last_name']}")
                    print(f"Landlord Contact: {rental['landlord_phone']} / {rental['landlord_email']}")
            
            if past_rentals:
                print("\nPAST RENTALS:")
                for rental in past_rentals:
                    print(f"\nRental ID: {rental['rent_id']}")
                    print(f"Property: {rental['street_number']} {rental['street_name']}, "
                          f"{rental['city']}, {rental['state']}, Room {rental['room_number']}")
                    print(f"Rental Period: {rental['start_date']} to {rental['end_date']}")
                    print(f"Monthly Rent: ${rental['price']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving rentals: {e}")

    def view_available_properties(self):
        """View properties available for rent."""
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            # Prepare filters
            print("\n===== PROPERTY SEARCH FILTERS =====")
            print("(Leave blank to skip filter)")
            
            city = input("City: ")
            state = input("State: ")
            
            min_price = None
            max_price = None
            min_sqft = None
            min_rooms = None
            
            min_price_input = input("Minimum Price: ")
            if min_price_input:
                try:
                    min_price = float(min_price_input)
                    if min_price < 0:
                        print("Minimum price cannot be negative. Using 0 instead.")
                        min_price = 0
                except ValueError:
                    print("Invalid input for minimum price. Skipping this filter.")
            
            max_price_input = input("Maximum Price: ")
            if max_price_input:
                try:
                    max_price = float(max_price_input)
                    if max_price < 0:
                        print("Maximum price cannot be negative. Skipping this filter.")
                        max_price = None
                    elif min_price is not None and max_price < min_price:
                        print("Maximum price cannot be less than minimum price. Skipping this filter.")
                        max_price = None
                except ValueError:
                    print("Invalid input for maximum price. Skipping this filter.")
            
            min_sqft_input = input("Minimum Square Footage: ")
            if min_sqft_input:
                try:
                    min_sqft = float(min_sqft_input)
                    if min_sqft < 0:
                        print("Minimum square footage cannot be negative. Using 0 instead.")
                        min_sqft = 0
                except ValueError:
                    print("Invalid input for minimum square footage. Skipping this filter.")
            
            min_rooms_input = input("Minimum Number of Rooms: ")
            if min_rooms_input:
                try:
                    min_rooms = int(min_rooms_input)
                    if min_rooms < 1:
                        print("Minimum rooms cannot be less than 1. Using 1 instead.")
                        min_rooms = 1
                except ValueError:
                    print("Invalid input for minimum rooms. Skipping this filter.")
            
            # Build query with filters
            query = """
            SELECT p.property_id, p.street_number, p.street_name, p.city, p.state, 
                   p.room_number, p.square_foot, p.price, p.room_amount,
                   u.first_name AS landlord_first_name, u.last_name AS landlord_last_name,
                   n.name AS neighborhood_name
            FROM properties p
            JOIN landlord l ON p.landlord_id = l.user_id
            JOIN user u ON l.user_id = u.user_id
            LEFT JOIN property_neighborhood pn ON p.property_id = pn.property_id
            LEFT JOIN neighborhood n ON pn.neighborhood_id = n.neighborhood_id
            WHERE p.for_rent = 1
            """
            
            # Add filters to query
            params = []
            
            if city:
                query += " AND p.city = %s"
                params.append(city)
            
            if state:
                query += " AND p.state = %s"
                params.append(state)
            
            if min_price is not None:
                query += " AND p.price >= %s"
                params.append(min_price)
            
            if max_price is not None:
                query += " AND p.price <= %s"
                params.append(max_price)
            
            if min_sqft is not None:
                query += " AND p.square_foot >= %s"
                params.append(min_sqft)
            
            if min_rooms is not None:
                query += " AND p.room_amount >= %s"
                params.append(min_rooms)
            
            # Check if user is a tenant
            is_tenant = False
            if self.current_user_id:
                tenant_query = "SELECT * FROM tenant WHERE user_id = %s"
                cursor.execute(tenant_query, (self.current_user_id,))
                is_tenant = cursor.fetchone() is not None
                
                if is_tenant:
                    # Check if property is not already rented by this tenant
                    query += " AND p.property_id NOT IN (SELECT property_id FROM rent WHERE tenant_id = %s AND end_date >= CURRENT_DATE)"
                    params.append(self.current_user_id)
            
            # Order by price
            query += " ORDER BY p.price"
            
            cursor.execute(query, params)
            properties = cursor.fetchall()
            
            if not properties:
                print("No available properties found matching your criteria.")
                return
            
            print(f"\n===== AVAILABLE PROPERTIES ({len(properties)}) =====")
            
            for prop in properties:
                print(f"\nProperty ID: {prop['property_id']}")
                print(f"Address: {prop['street_number']} {prop['street_name']}, {prop['city']}, {prop['state']}")
                print(f"Room: {prop['room_number']}")
                print(f"Square Footage: {prop['square_foot']} sq ft")
                print(f"Price: ${prop['price']}")
                print(f"Number of Rooms: {prop['room_amount']}")
                print(f"Landlord: {prop['landlord_first_name']} {prop['landlord_last_name']}")
                
                if prop['neighborhood_name']:
                    print(f"Neighborhood: {prop['neighborhood_name']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving available properties: {e}")

    def rent_property(self):
        """Rent a property."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            # Check if user is a tenant
            cursor = self.connection.cursor(dictionary=True)
            query = "SELECT * FROM tenant WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            is_tenant = cursor.fetchone()
            
            if not is_tenant:
                print("You are not registered as a tenant.")
                while True:
                    register = input("Do you want to register as a tenant? (y/n): ").lower()
                    if register in ['y', 'n']:
                        if register == 'y':
                            query = "INSERT INTO tenant (user_id) VALUES (%s)"
                            cursor.execute(query, (self.current_user_id,))
                            self.connection.commit()
                            print("You have been registered as a tenant.")
                        else:
                            return
                        break
                    else:
                        print("Invalid input. Please enter 'y' or 'n'.")
            
            property_id = self.get_numeric_input("Enter the Property ID you want to rent: ", int, min_value=1)
            if property_id is None:
                return
            
            # Check if property exists and is available for rent
            query = """
            SELECT p.*, u.first_name, u.last_name
            FROM properties p
            JOIN landlord l ON p.landlord_id = l.user_id
            JOIN user u ON l.user_id = u.user_id
            WHERE p.property_id = %s AND p.for_rent = 1
            """
            cursor.execute(query, (property_id,))
            property_data = cursor.fetchone()
            
            if not property_data:
                print("Property not found or not available for rent.")
                return
            
            # Check if property is already rented by this tenant
            query = """
            SELECT * FROM rent 
            WHERE property_id = %s AND tenant_id = %s AND end_date >= CURRENT_DATE
            """
            cursor.execute(query, (property_id, self.current_user_id))
            existing_rental = cursor.fetchone()
            
            if existing_rental:
                print("You are already renting this property.")
                return
            
            print("\n===== RENT PROPERTY =====")
            print(f"Property: {property_data['street_number']} {property_data['street_name']}, "
                  f"{property_data['city']}, {property_data['state']}, Room {property_data['room_number']}")
            print(f"Landlord: {property_data['first_name']} {property_data['last_name']}")
            print(f"Monthly Rent: ${property_data['price']}")
            
            # Ask for rental details with validation
            contract_length = self.get_numeric_input("Contract Length (months): ", int, min_value=1)
            if contract_length is None:
                return
            
            # Ask if using a broker
            while True:
                use_broker_input = input("Do you want to use a broker for this rental? (y/n): ").lower()
                if use_broker_input in ['y', 'n']:
                    use_broker = use_broker_input == 'y'
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            
            broker_id = None
            broker_fee = None
            
            if use_broker:
                # Show available brokers
                query = "SELECT broker_id, first_name, last_name FROM broker"
                cursor.execute(query)
                brokers = cursor.fetchall()
                
                if not brokers:
                    print("No brokers available in the system.")
                    use_broker = False
                else:
                    print("\nAvailable Brokers:")
                    for broker in brokers:
                        print(f"{broker['broker_id']}. {broker['first_name']} {broker['last_name']}")
                    
                    while True:
                        broker_choice = input("Enter Broker ID (or 0 to skip): ")
                        if broker_choice.isdigit():
                            broker_id = int(broker_choice)
                            if broker_id == 0:
                                broker_id = None
                                break
                                
                            # Verify broker exists
                            broker_exists = False
                            for broker in brokers:
                                if broker['broker_id'] == broker_id:
                                    broker_exists = True
                                    break
                            
                            if broker_exists:
                                broker_fee = self.get_numeric_input("Broker Fee ($): ", float, min_value=0)
                                if broker_fee is None:
                                    broker_fee = 0
                                break
                            else:
                                print("Invalid broker ID. Please select from the list.")
                        else:
                            print("Invalid input. Please enter a number.")
            
            # Calculate dates
            start_date = datetime.now().date()
            end_date = start_date + timedelta(days=30 * contract_length)
            
            # Confirm rental
            print("\nRental Summary:")
            print(f"Property: {property_data['street_number']} {property_data['street_name']}, "
                  f"{property_data['city']}, {property_data['state']}, Room {property_data['room_number']}")
            print(f"Monthly Rent: ${property_data['price']}")
            print(f"Contract Length: {contract_length} months")
            print(f"Start Date: {start_date}")
            print(f"End Date: {end_date}")
            
            if broker_id:
                print(f"Broker ID: {broker_id}")
                print(f"Broker Fee: ${broker_fee}")
            
            while True:
                confirm = input("Confirm rental (y/n): ").lower()
                if confirm in ['y', 'n']:
                    if confirm != 'y':
                        print("Rental cancelled.")
                        return
                    break
                else:
                    print("Invalid input. Please enter 'y' or 'n'.")
            
            # Insert rental
            insert_query = """
            INSERT INTO rent (tenant_id, property_id, contract_length, price, broker_fee, broker_id, start_date, end_date)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(insert_query, (self.current_user_id, property_id, contract_length, 
                                         property_data['price'], broker_fee, broker_id, start_date, end_date))
            
            # Insert broker-tenant relationship if not exists and broker is used
            if broker_id:
                query = """
                SELECT * FROM broker_tenant 
                WHERE broker_id = %s AND tenant_id = %s
                """
                cursor.execute(query, (broker_id, self.current_user_id))
                if not cursor.fetchone():
                    query = """
                    INSERT INTO broker_tenant (broker_id, tenant_id)
                    VALUES (%s, %s)
                    """
                    cursor.execute(query, (broker_id, self.current_user_id))
            
            # Update property availability if it's now occupied
            query = "UPDATE properties SET for_rent = 0 WHERE property_id = %s"
            cursor.execute(query, (property_id,))
            
            self.connection.commit()
            print("Property rented successfully!")
            cursor.close()
            
        except Error as e:
            print(f"Error renting property: {e}")

    def manage_broker_activities(self):
        """Manage broker activities."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            # Check if current user is already a broker
            user_info = None
            query = "SELECT first_name, last_name FROM user WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            user_info = cursor.fetchone()
            
            if not user_info:
                print("User information not found.")
                return
            
            query = """
            SELECT * FROM broker 
            WHERE first_name = %s AND last_name = %s
            """
            cursor.execute(query, (user_info['first_name'], user_info['last_name']))
            broker_data = cursor.fetchone()
            
            if not broker_data:
                # User is not a broker, offer to register
                print("You are not registered as a broker.")
                while True:
                    register = input("Do you want to register as a broker? (y/n): ").lower()
                    if register in ['y', 'n']:
                        if register != 'y':
                            return
                        break
                    else:
                        print("Invalid input. Please enter 'y' or 'n'.")
                
                print("\n===== REGISTER AS BROKER =====")
                
                # Validate SSN
                while True:
                    ssn = input("Enter your SSN (XXX-XX-XXXX or XXXXXXXXX): ")
                    if self.validate_ssn(ssn):
                        break
                
                # Validate License ID
                while True:
                    license_id = input("Enter your License ID: ")
                    if license_id.strip():
                        break
                    else:
                        print("License ID cannot be empty.")
                
                # Validate Phone
                while True:
                    phone = input("Enter your Broker Phone: ")
                    if self.validate_phone(phone):
                        break
                
                # Check if SSN or license already exists
                query = "SELECT * FROM broker WHERE ssn = %s OR license_id = %s"
                cursor.execute(query, (ssn, license_id))
                if cursor.fetchone():
                    print("A broker with this SSN or license ID already exists.")
                    return
                
                # Insert broker record
                insert_query = """
                INSERT INTO broker (ssn, license_id, phone, first_name, last_name)
                VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(insert_query, (ssn, license_id, phone, user_info['first_name'], user_info['last_name']))
                self.connection.commit()
                print("Registered as broker successfully!")
                
                # Get the new broker ID
                query = "SELECT broker_id FROM broker WHERE ssn = %s"
                cursor.execute(query, (ssn,))
                broker_data = cursor.fetchone()
            
            broker_id = broker_data['broker_id']
            
            while True:
                print("\n===== BROKER ACTIVITIES =====")
                print("1. View My Clients")
                print("2. View My Deals")
                print("3. Update Broker Information")
                print("0. Back to Main Menu")
                
                while True:
                    choice = input("Enter your choice: ")
                    if choice in ['0', '1', '2', '3']:
                        break
                    else:
                        print("Invalid choice. Please enter a number between 0 and 3.")
                
                if choice == '1':
                    self.view_broker_clients(broker_id)
                elif choice == '2':
                    self.view_broker_deals(broker_id)
                elif choice == '3':
                    self.update_broker_info(broker_id)
                elif choice == '0':
                    break
            
            cursor.close()
            
        except Error as e:
            print(f"Error managing broker activities: {e}")
            
    def view_broker_clients(self, broker_id):
        """View tenants associated with the broker."""
        if not broker_id:
            print("Invalid broker ID.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            query = """
            SELECT u.first_name, u.last_name, u.phone, u.email
            FROM broker_tenant bt
            JOIN tenant t ON bt.tenant_id = t.user_id
            JOIN user u ON t.user_id = u.user_id
            WHERE bt.broker_id = %s
            ORDER BY u.last_name, u.first_name
            """
            cursor.execute(query, (broker_id,))
            clients = cursor.fetchall()
            
            if not clients:
                print("You don't have any clients registered.")
                return
            
            print("\n===== MY CLIENTS =====")
            for client in clients:
                print(f"Name: {client['first_name']} {client['last_name']}")
                print(f"Contact: {client['phone']} / {client['email']}")
                print()
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving broker clients: {e}")
            
    def view_broker_deals(self, broker_id):
        """View rental deals associated with the broker."""
        if not broker_id:
            print("Invalid broker ID.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            query = """
            SELECT r.rent_id, r.start_date, r.end_date, r.price, r.broker_fee,
                   p.street_number, p.street_name, p.city, p.state, p.room_number,
                   tenant.first_name AS tenant_first_name, tenant.last_name AS tenant_last_name,
                   landlord.first_name AS landlord_first_name, landlord.last_name AS landlord_last_name
            FROM rent r
            JOIN properties p ON r.property_id = p.property_id
            JOIN user tenant ON r.tenant_id = tenant.user_id
            JOIN landlord l ON p.landlord_id = l.user_id
            JOIN user landlord ON l.user_id = landlord.user_id
            WHERE r.broker_id = %s
            ORDER BY r.start_date DESC
            """
            cursor.execute(query, (broker_id,))
            deals = cursor.fetchall()
            
            if not deals:
                print("You don't have any deals recorded.")
                return
            
            today = datetime.now().date()
            
            # Separate current and past deals
            current_deals = [d for d in deals if d['end_date'] >= today]
            past_deals = [d for d in deals if d['end_date'] < today]
            
            total_fees = sum(d['broker_fee'] for d in deals if d['broker_fee'] is not None)
            
            print("\n===== MY DEALS =====")
            print(f"Total Deals: {len(deals)}")
            print(f"Total Broker Fees: ${total_fees:.2f}")
            
            if current_deals:
                print("\nCURRENT DEALS:")
                for deal in current_deals:
                    print(f"\nRental ID: {deal['rent_id']}")
                    print(f"Property: {deal['street_number']} {deal['street_name']}, "
                          f"{deal['city']}, {deal['state']}, Room {deal['room_number']}")
                    print(f"Tenant: {deal['tenant_first_name']} {deal['tenant_last_name']}")
                    print(f"Landlord: {deal['landlord_first_name']} {deal['landlord_last_name']}")
                    print(f"Period: {deal['start_date']} to {deal['end_date']}")
                    print(f"Monthly Rent: ${deal['price']}")
                    print(f"Broker Fee: ${deal['broker_fee']}")
            
            if past_deals:
                print("\nPAST DEALS:")
                for deal in past_deals:
                    print(f"\nRental ID: {deal['rent_id']}")
                    print(f"Property: {deal['street_number']} {deal['street_name']}, "
                          f"{deal['city']}, {deal['state']}, Room {deal['room_number']}")
                    print(f"Period: {deal['start_date']} to {deal['end_date']}")
                    print(f"Broker Fee: ${deal['broker_fee']}")
            
            cursor.close()
            
        except Error as e:
            print(f"Error retrieving broker deals: {e}")
            
    def update_broker_info(self, broker_id):
        """Update broker information."""
        if not broker_id:
            print("Invalid broker ID.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            # Get current broker information
            query = "SELECT * FROM broker WHERE broker_id = %s"
            cursor.execute(query, (broker_id,))
            broker_data = cursor.fetchone()
            
            if not broker_data:
                print("Broker information not found.")
                return
            
            print("\n===== UPDATE BROKER INFORMATION =====")
            print(f"Current SSN: {broker_data['ssn']}")
            print(f"Current License ID: {broker_data['license_id']}")
            print(f"Current Phone: {broker_data['phone']}")
            
            print("\nWhich field would you like to update?")
            print("1. SSN")
            print("2. License ID")
            print("3. Phone")
            
            while True:
                field_choice = input("Enter your choice (or 0 to cancel): ")
                if field_choice in ['0', '1', '2', '3']:
                    break
                else:
                    print("Invalid choice. Please enter a number between 0 and 3.")
            
            if field_choice == '0':
                return
            elif field_choice == '1':
                # Validate SSN
                while True:
                    ssn_input = input(f"SSN [{broker_data['ssn']}]: ")
                    if not ssn_input:
                        ssn = broker_data['ssn']
                        break
                    elif self.validate_ssn(ssn_input):
                        ssn = ssn_input
                        break
                
                # Check if SSN already exists
                query = "SELECT * FROM broker WHERE ssn = %s AND broker_id != %s"
                cursor.execute(query, (ssn, broker_id))
                if cursor.fetchone():
                    print("This SSN is already in use by another broker.")
                    return
                
                update_query = "UPDATE broker SET ssn = %s WHERE broker_id = %s"
                cursor.execute(update_query, (ssn, broker_id))
                
            elif field_choice == '2':
                while True:
                    license_id_input = input(f"License ID [{broker_data['license_id']}]: ")
                    if not license_id_input:
                        license_id = broker_data['license_id']
                        break
                    elif license_id_input.strip():
                        license_id = license_id_input
                        break
                    else:
                        print("License ID cannot be empty.")
                
                # Check if license ID already exists
                query = "SELECT * FROM broker WHERE license_id = %s AND broker_id != %s"
                cursor.execute(query, (license_id, broker_id))
                if cursor.fetchone():
                    print("This license ID is already in use by another broker.")
                    return
                
                update_query = "UPDATE broker SET license_id = %s WHERE broker_id = %s"
                cursor.execute(update_query, (license_id, broker_id))
                
            elif field_choice == '3':
                while True:
                    phone_input = input(f"Phone [{broker_data['phone']}]: ")
                    if not phone_input:
                        phone = broker_data['phone']
                        break
                    elif self.validate_phone(phone_input):
                        phone = phone_input
                        break
                
                # Check if phone already exists
                query = "SELECT * FROM broker WHERE phone = %s AND broker_id != %s"
                cursor.execute(query, (phone, broker_id))
                if cursor.fetchone():
                    print("This phone is already in use by another broker.")
                    return
                
                update_query = "UPDATE broker SET phone = %s WHERE broker_id = %s"
                cursor.execute(update_query, (phone, broker_id))
                
            else:
                print("Invalid choice.")
                return
            
            self.connection.commit()
            print("Broker information updated successfully!")
            cursor.close()
            
        except Error as e:
            print(f"Error updating broker information: {e}")

    def update_personal_info(self):
        """Update personal information."""
        if not self.current_user_id:
            print("You need to login first.")
            return
        
        try:
            cursor = self.connection.cursor(dictionary=True)
            
            # Get current user information
            query = """
            SELECT u.user_id, u.first_name, u.last_name, u.phone, u.email, ua.username
            FROM user u
            JOIN user_auth ua ON u.auth_id = ua.auth_id
            WHERE u.user_id = %s
            """
            cursor.execute(query, (self.current_user_id,))
            user_info = cursor.fetchone()
            
            if not user_info:
                print("User information not found.")
                return
            
            print("\n===== UPDATE PERSONAL INFORMATION =====")
            print(f"Current Name: {user_info['first_name']} {user_info['last_name']}")
            print(f"Current Phone: {user_info['phone']}")
            print(f"Current Email: {user_info['email']}")
            
            print("\nWhich field would you like to update?")
            print("1. Name")
            print("2. Phone")
            print("3. Email")
            
            # Check for additional user statuses
            # Check for US Citizen status
            query = "SELECT * FROM us_citizen WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            us_citizen_data = cursor.fetchone()
            
            if us_citizen_data:
                print("4. SSN (US Citizen)")
            
            # Check for International Student status
            query = "SELECT * FROM international_student WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            intl_student_data = cursor.fetchone()
            
            if intl_student_data:
                print("5. Passport ID (International Student)")
            
            # Check for Student status
            query = "SELECT * FROM student WHERE user_id = %s"
            cursor.execute(query, (self.current_user_id,))
            student_data = cursor.fetchone()
            
            if student_data:
                print("6. Transcript (Student)")
                
            # Offer additional registration options
            if not us_citizen_data and not intl_student_data:
                print("7. Register as US Citizen or International Student")
            
            if not student_data:
                print("8. Register as Student")
            
            while True:
                field_choice = input("Enter your choice (or 0 to cancel): ")
                if field_choice.isdigit() and 0 <= int(field_choice) <= 8:
                    field_choice = int(field_choice)
                    
                    # Check if choice is valid for the user's status
                    if field_choice == 4 and not us_citizen_data:
                        print("You are not registered as a US Citizen.")
                        continue
                    if field_choice == 5 and not intl_student_data:
                        print("You are not registered as an International Student.")
                        continue
                    if field_choice == 6 and not student_data:
                        print("You are not registered as a Student.")
                        continue
                    if field_choice == 7 and (us_citizen_data or intl_student_data):
                        print("You are already registered as a US Citizen or International Student.")
                        continue
                    if field_choice == 8 and student_data:
                        print("You are already registered as a Student.")
                        continue
                    
                    break
                else:
                    print("Invalid choice. Please enter a valid number.")
            
            if field_choice == 0:
                return
            elif field_choice == 1:
                while True:
                    first_name_input = input(f"First Name [{user_info['first_name']}]: ")
                    if not first_name_input:
                        first_name = user_info['first_name']
                        break
                    elif first_name_input.strip() and all(c.isalpha() or c.isspace() for c in first_name_input):
                        first_name = first_name_input
                        break
                    else:
                        print("Invalid first name. Please use only letters and spaces.")
                
                while True:
                    last_name_input = input(f"Last Name [{user_info['last_name']}]: ")
                    if not last_name_input:
                        last_name = user_info['last_name']
                        break
                    elif last_name_input.strip() and all(c.isalpha() or c.isspace() or c == '-' for c in last_name_input):
                        last_name = last_name_input
                        break
                    else:
                        print("Invalid last name. Please use only letters, spaces, and hyphens.")
                
                update_query = """
                UPDATE user 
                SET first_name = %s, last_name = %s
                WHERE user_id = %s
                """
                cursor.execute(update_query, (first_name, last_name, self.current_user_id))
                self.current_user = f"{first_name} {last_name}"
                
                # If there's a broker record with the same name, update it too
                query = """
                SELECT * FROM broker 
                WHERE first_name = %s AND last_name = %s
                """
                cursor.execute(query, (user_info['first_name'], user_info['last_name']))
                broker_data = cursor.fetchone()
                
                if broker_data:
                    update_query = """
                    UPDATE broker 
                    SET first_name = %s, last_name = %s
                    WHERE broker_id = %s
                    """
                    cursor.execute(update_query, (first_name, last_name, broker_data['broker_id']))
                
            elif field_choice == 2:
                while True:
                    phone_input = input(f"Phone [{user_info['phone']}]: ")
                    if not phone_input:
                        phone = user_info['phone']
                        break
                    elif self.validate_phone(phone_input):
                        phone = phone_input
                        break
                
                # Check if phone already exists
                query = "SELECT * FROM user WHERE phone = %s AND user_id != %s"
                cursor.execute(query, (phone, self.current_user_id))
                if cursor.fetchone():
                    print("This phone number is already in use by another user.")
                    return
                
                update_query = "UPDATE user SET phone = %s WHERE user_id = %s"
                cursor.execute(update_query, (phone, self.current_user_id))
                
            elif field_choice == 3:
                while True:
                    email_input = input(f"Email [{user_info['email']}]: ")
                    if not email_input:
                        email = user_info['email']
                        break
                    elif self.validate_email(email_input):
                        email = email_input
                        break
                
                # Check if email already exists
                query = "SELECT * FROM user WHERE email = %s AND user_id != %s"
                cursor.execute(query, (email, self.current_user_id))
                if cursor.fetchone():
                    print("This email is already in use by another user.")
                    return
                
                update_query = "UPDATE user SET email = %s WHERE user_id = %s"
                cursor.execute(update_query, (email, self.current_user_id))
                
            elif field_choice == 4 and us_citizen_data:
                while True:
                    ssn_input = input(f"SSN [{us_citizen_data['ssn']}]: ")
                    if not ssn_input:
                        ssn = us_citizen_data['ssn']
                        break
                    elif self.validate_ssn(ssn_input):
                        ssn = ssn_input
                        break
                
                # Check if SSN already exists
                query = "SELECT * FROM us_citizen WHERE ssn = %s AND user_id != %s"
                cursor.execute(query, (ssn, self.current_user_id))
                if cursor.fetchone():
                    print("This SSN is already in use by another user.")
                    return
                
                update_query = "UPDATE us_citizen SET ssn = %s WHERE user_id = %s"
                cursor.execute(update_query, (ssn, self.current_user_id))
                
            elif field_choice == 5 and intl_student_data:
                while True:
                    passport_id_input = input(f"Passport ID [{intl_student_data['passport_id']}]: ")
                    if not passport_id_input:
                        passport_id = intl_student_data['passport_id']
                        break
                    elif passport_id_input.strip():
                        passport_id = passport_id_input
                        break
                    else:
                        print("Passport ID cannot be empty.")
                
                # Check if passport ID already exists
                query = "SELECT * FROM international_student WHERE passport_id = %s AND user_id != %s"
                cursor.execute(query, (passport_id, self.current_user_id))
                if cursor.fetchone():
                    print("This passport ID is already in use by another user.")
                    return
                
                update_query = "UPDATE international_student SET passport_id = %s WHERE user_id = %s"
                cursor.execute(update_query, (passport_id, self.current_user_id))
                
            elif field_choice == 6 and student_data:
                # In a real application, you would have a file upload mechanism
                # For this example, we'll just update a placeholder
                update_query = "UPDATE student SET transcript = 'UPDATED_PDF' WHERE user_id = %s"
                cursor.execute(update_query, (self.current_user_id,))
                print("Transcript updated. (In a real application, you would upload a file.)")
                
            elif field_choice == 7 and not us_citizen_data and not intl_student_data:
                print("\nRegister as:")
                print("1. US Citizen")
                print("2. International Student")
                
                while True:
                    citizen_choice = input("Enter your choice (or 0 to cancel): ")
                    if citizen_choice in ['0', '1', '2']:
                        break
                    else:
                        print("Invalid choice. Please enter 0, 1, or 2.")
                
                if citizen_choice == '0':
                    return
                elif citizen_choice == '1':
                    while True:
                        ssn = input("Enter your SSN (XXX-XX-XXXX or XXXXXXXXX): ")
                        if self.validate_ssn(ssn):
                            break
                    
                    # Check if SSN already exists
                    query = "SELECT * FROM us_citizen WHERE ssn = %s"
                    cursor.execute(query, (ssn,))
                    if cursor.fetchone():
                        print("This SSN is already in use by another user.")
                        return
                    
                    # Insert US citizen record
                    insert_query = "INSERT INTO us_citizen (user_id, ssn) VALUES (%s, %s)"
                    cursor.execute(insert_query, (self.current_user_id, ssn))
                    print("Registered as US Citizen successfully.")
                    
                elif citizen_choice == '2':
                    while True:
                        passport_id = input("Enter your Passport ID: ")
                        if passport_id.strip():
                            break
                        else:
                            print("Passport ID cannot be empty.")
                    
                    # Check if passport ID already exists
                    query = "SELECT * FROM international_student WHERE passport_id = %s"
                    cursor.execute(query, (passport_id,))
                    if cursor.fetchone():
                        print("This passport ID is already in use by another user.")
                        return
                    
                    # Insert international student record
                    insert_query = "INSERT INTO international_student (user_id, passport_id) VALUES (%s, %s)"
                    cursor.execute(insert_query, (self.current_user_id, passport_id))
                    
                    # Also insert student record if not already student
                    query = "SELECT * FROM student WHERE user_id = %s"
                    cursor.execute(query, (self.current_user_id,))
                    if not cursor.fetchone():
                        insert_query = "INSERT INTO student (user_id, transcript) VALUES (%s, 'PDF')"
                        cursor.execute(insert_query, (self.current_user_id,))
                    
                    print("Registered as International Student successfully.")
                
            elif field_choice == 8 and not student_data:
                # In a real application, you would have a file upload mechanism
                # For this example, we'll just insert a placeholder
                insert_query = "INSERT INTO student (user_id, transcript) VALUES (%s, 'PDF')"
                cursor.execute(insert_query, (self.current_user_id,))
                print("Registered as Student successfully.")
                print("Transcript placeholder added. (In a real application, you would upload a file.)")
            
            self.connection.commit()
            print("Information updated successfully!")
            cursor.close()
            
        except Error as e:
            print(f"Error updating information: {e}")

    def logout(self):
        """Logout current user."""
        self.current_user = None
        self.current_user_id = None
        print("Logged out successfully.")
        
    def close_connection(self):
        """Close the database connection."""
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("Database connection closed.")
     
    def run(self):
        """Run the application."""
        print("Welcome to Property Rental System")
        
        if not self.connect_to_database():
            print("Failed to connect to database. Exiting...")
            return
        
        while True:
            if not self.current_user:
                print("\n===== LOGIN =====")
                print("1. Login")
                print("0. Exit")
                
                while True:
                    choice = input("Enter your choice: ")
                    if choice in ['0', '1']:
                        break
                    else:
                        print("Invalid choice. Please enter 0 or 1.")
                
                if choice == '1':
                    username = input("Username: ")
                    if self.login(username):
                        continue
                elif choice == '0':
                    break
            else:
                choice = self.display_menu()
                
                if choice == '0':
                    self.logout()
                elif choice == '1':
                    self.view_profile()
                elif choice == '2':
                    self.manage_properties()
                elif choice == '3':
                    self.view_my_tenants()
                elif choice == '4':
                    self.view_my_rentals()
                elif choice == '5':
                    self.view_available_properties()
                elif choice == '6':
                    self.rent_property()
                elif choice == '7':
                    self.update_personal_info()
                elif choice == '8':
                    self.manage_broker_activities()
        
        self.close_connection()
        print("Thank you for using NEU RENTALS. Goodbye!")


if __name__ == "__main__":
   rental_system = RentalSystem()
   rental_system.run()