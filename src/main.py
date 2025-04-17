import pymysql
from tabulate import tabulate
import os
from getpass import getpass
import hashlib
import uuid

def display_logo():
    # Display logo.txt. On Windows, 'type' is used (or fallback to Python file I/O).
    try:
        os.system("cat logo.txt")
    except Exception:
        try:
            with open("logo.txt", "r") as file:
                print(file.read())
        except Exception:
            print("Logo not available.")

def signup(cursor, conn):
    print("\n=== Signup ===")
    email = input("Enter your email: ").strip()
    # Verify that the email is unique by checking the user table.
    cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
    if cursor.fetchone() is not None:
        print("An account with this email already exists. Please log in instead or use a different email.\n")
        return None

    password = getpass("Enter your password: ")
    confirm_password = getpass("Confirm your password: ")
    if password != confirm_password:
        print("Passwords do not match. Please try again.\n")
        return None

    first_name = input("Enter your first name: ").strip()
    last_name = input("Enter your last name: ").strip()
    phone = input("Enter your phone number: ").strip()

    # Generate a salt and hash the password using SHA-256.
    salt = uuid.uuid4().hex
    password_hash = hashlib.sha256((salt + password).encode()).hexdigest()

    # Insert authentication record into user_auth (using email as username).
    cursor.execute(
        "INSERT INTO user_auth (username, password_hash, salt) VALUES (%s, %s, %s)",
        (email, password_hash, salt)
    )
    auth_id = cursor.lastrowid

    # Insert into the user table.
    cursor.execute(
        "INSERT INTO user (auth_id, first_name, last_name, phone, email) VALUES (%s, %s, %s, %s, %s)",
        (auth_id, first_name, last_name, phone, email)
    )
    conn.commit()
    print("Signup successful! You can now log in.\n")
    return email

def login(cursor):
    print("\n=== Login ===")
    email = input("Enter your email: ").strip()
    password = getpass("Enter your password: ")

    # Retrieve the user record using the email.
    cursor.execute("SELECT * FROM user WHERE email = %s", (email,))
    user_record = cursor.fetchone()
    if user_record is None:
        print("No account found with that email. Please sign up first.\n")
        return None

    # The user table is expected to have: user_id, auth_id, first_name, last_name, phone, email.
    auth_id = user_record[1]
    cursor.execute("SELECT * FROM user_auth WHERE auth_id = %s", (auth_id,))
    auth_record = cursor.fetchone()
    stored_password_hash = auth_record[2]
    salt = auth_record[3]
    
    # Hash the provided password with the retrieved salt.
    password_hash = hashlib.sha256((salt + password).encode()).hexdigest()
    if password_hash == stored_password_hash:
        print("Login successful!\n")
        return email
    else:
        print("Incorrect password. Please try again.\n")
        return None

def main_menu(cur, conn, authenticated_email):
    logged_in = True
    # These column headers are used when displaying listings.
    column = ['property_id', 'address', 'room_number', 'square_foot', 
              'for_rent', 'price', 'room_amount', 'landord_id']
    while logged_in:
        print("\nMain Menu:")
        usr_choice = input('1: View all listings\n' + 
                       '2: Filter listings\n' + 
                       '3: Edit listings\n' + 
                       '4: Delete listings\n' + 
                       '5: Disconnect from the database and close the application\n' +
                       'Please select your choice: ')
    
        if usr_choice == '3':
            print('edit function')
            #edit_listing function

        if usr_choice == '4':
            # delete listing
            print('edit function')

        # if user select 5, close the connection and the program
        if usr_choice == '5':
            conn.close() 
            logged_in = False

        # if user select 1, show all listings
        elif usr_choice == '1':
            print('\n')
            cur.execute("SELECT * FROM properties")
            output = cur.fetchall()
            table = []
            for item in output:
                table.append(list(item))
            result = list(row[0] for row in output)
            columns = os.get_terminal_size().columns
            print(tabulate(table, headers = column, tablefmt="grid", maxcolwidths=[None, None, columns // 3]))
            print('\n')

        # if user select 2, ask for filter
        elif usr_choice == '2':
            print('\n')
            filter = ''
            while filter not in ["1", "2"]:
                filter = input('1. Sort by column\n' +
                    '2. Filter by value\nPlease select your filter: ')
                if filter not in ["1", "2"]:
                    print('Please enter valid value!\n')

            if filter == '1':
                print('\n')
                col = ''
                asc = ''
                while col not in column:
                    col = input('Name of columns: street number, street name, city, \nstate, zip, room number, square foot, price, bedrooms\n' \
                    'Select column you want to sort by: ').lower()
                    if col not in column:
                        print('Column not exist, please enter a valid value! \n')
                print('\n')
                
                while asc not in ['1', '2']:
                    asc = input('1. low to high\n2. high to low\nPlease select how you want to sort: ')
                if asc == '1':
                    asc = 'asc'
                else:
                    asc = 'desc'
                print('\n')

                cur.execute(f"SELECT * FROM properties ORDER BY {col} {asc}")
                output = cur.fetchall()
                table = []
                for item in output:
                    table.append(list(item))
                result = list(row[0] for row in output)
                columns = os.get_terminal_size().columns
                print(tabulate(table, headers = column, tablefmt="grid", maxcolwidths=[None, None, columns // 3]))
                print('\n')
            
            if filter == '2':
                print('\n')
                option = ''
                while option not in ['1', '2']:
                    option = input('1. Search by value\n2. Search by range\nPlease select how you want to search: ')

                # search by value
                if option == '1':
                    col = ''
                    asc = ''
                    while col not in column:
                        col = input('Name of columns: street number, street name, city, \nstate, zip, room number, square foot, price, bedrooms\n' \
                        'Select column you want to sort by: ').lower()
                        if col not in column:
                            print('Column not exist, please enter a valid value! \n')
                    print('\n')

                    cur.execute(f'SELECT {col} FROM properties')
                    output = cur.fetchall()
                    table = []
                    for item in output:
                        table.extend(list(item))

                    for i in range(len(table)):
                        table[i] = str(table[i])
                    print(table)
                    print(type(table[0]))
                    
                    while asc not in table:
                        asc = str(input('Please enter value you are searching for: '))
                        if asc not in table:
                            print('Value is not found')
                    
                    cur.execute(f"SELECT * FROM properties WHERE {col} = {asc}")
                    output = cur.fetchall()
                    table = []
                    for item in output:
                        table.append(list(item))
                    result = list(row[0] for row in output)
                    columns = os.get_terminal_size().columns
                    print(tabulate(table, headers = column, tablefmt="grid", maxcolwidths=[None, None, columns // 3]))
                    print('\n')
                if option == '2':
                    col = ''
                    low = ''
                    high = ''
                    while col not in ['square foot', 'price', 'bedrooms']:
                        col = input('\nName of columns: square foot, price, bedrooms\n' \
                        'Select column you want to sort by: ').lower()
                        if col not in column:
                            print('Column not exist, please enter a valid value! \n')
                    print('\n')

                    while type(low) != int and type(high) != int:
                        low = input('Range starting from: ')
                        high = input('Range go up to: ')

                        try:
                            low = int(low)
                            high = int(high)
                        except ValueError:
                            print('Value is invalid please enter again')
                    
                    print(f'range from {low} to {high}')
                    cur.execute(f"SELECT * FROM properties WHERE {col} >= {low} AND {col} <= {high}")
                    output = cur.fetchall()
                    table = []
                    for item in output:
                        table.append(list(item))
                    result = list(row[0] for row in output)
                    columns = os.get_terminal_size().columns
                    print(tabulate(table, headers = column, tablefmt="grid", maxcolwidths=[None, None, columns // 3]))
                    print('\n')

        else:
            print("Error! Please enter a valid choice!")
            print("\n")

def main():
    # Display the logo at the start.
    display_logo()

    # Database connection loop.
    connected = False
    while not connected:
        db_username = input("Enter username for MySQL server: ")
        db_pw = getpass("Enter the password for MySQL server: ")
        print()
        try:
            conn = pymysql.connect(
                host="localhost",
                user=db_username,
                password=db_pw,
                db="rental_system"
            )
            connected = True
        except pymysql.Error as ex:
            print("Username or password is invalid, please enter again.\n")
    cur = conn.cursor()
    
    # Outer loop for authentication, so a user can log out and a new user can log in.
    while True:
        authenticated_email = None
        while authenticated_email is None:
            print("Welcome! Please select an option:")
            print("1: Signup")
            print("2: Login")
            option = input("Enter your choice (1 or 2): ").strip()
            if option == '1':
                authenticated_email = signup(cur, conn)
            elif option == '2':
                authenticated_email = login(cur)
            else:
                print("Invalid option. Please select 1 or 2.\n")
        print(f"Welcome, {authenticated_email}!\n")
        main_menu(cur, conn, authenticated_email)
        # When main_menu returns, the user has logged out.
        print("You have been logged out.\n")

if __name__ == "__main__":
    main()