import pymysql
from tabulate import tabulate
import os
from add_listing import add_listing
from edit_listing import edit_listing
from delete_listing import delete_listing

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

def main_menu(cur, conn, authenticated_email):
    logged_in = True
    # These column headers are used when displaying listings.
    column = ['property_id', 'street_number', 'street_name', 'city', 'room_number', 'square_foot', 
              'for_rent', 'price', 'room_amount', 'landord_id']
    while logged_in:
        print("\nMain Menu:")
        usr_choice = input('1: View all listings\n' + 
                       '2: Filter listings\n' + 
                       '3: Edit listings\n' + 
                       '4: Delete listings\n' + 
                       '5: Add new listing\n' + 
                       '6: Logout\n' +
                       'Please select your choice: ')
    
        if usr_choice == '3':
            edit_listing(cur, conn, authenticated_email)

        elif usr_choice == '4':
            delete_listing(cur, conn, authenticated_email)
            
        elif usr_choice == '5':
            add_listing(cur, conn, authenticated_email)

        # if user select 6, close the connection and the program
        elif usr_choice == '6':
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
                    col = input('Name of columns: street_number, street_name, city, \nstate, zip, room_number, square_foot, price, room_amount\n' \
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
                        col = input('Name of columns: street_number, street_name, city, \nstate, zip, room_number, square_foot, price, room_amount\n' \
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
                    while col not in ['square_foot', 'price', 'room_amount']:
                        col = input('\nName of columns: square_foot, price, room_amount\n' \
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