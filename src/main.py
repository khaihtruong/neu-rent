import pymysql 
from tabulate import tabulate
from os import system 
import os
from getpass import getpass

# logo
system("cat logo.txt")
column = ['street number', 'street name', 'city', 'state', 'zip', 'room number', 'square foot', 'price', 'bedrooms']

connected = False

while not connected:
    # user input user and password
    username = input('Enter username for MySQL server: ')
    pw = getpass('Enter the password for MySQL server: ')
    print('\n')

    try:
        # establish connection, db name is hardcoded
        conn = pymysql.connect( 
                    host='localhost', 
                    user=username, 
                    password = pw, 
                    db='final',) 
        connected = True
    except pymysql.Error as ex:
        print('username or password is invalid please enter again')
        print('\n')

    if connected:
        cur = conn.cursor() 
        choice = 0
        user_genre = ''

while choice != 3:
    usr_choice = input('1: View all listings\n' + 
                       '2: Filter listings\n' + 
                       '3: Disconnect from the database and close the application\n' + 
                       'Please select your choice: ')
    
    # if user select 3, close the connection and the program
    if usr_choice == '3':
        conn.close() 
        choice = 3

    # if user select 1, show all listings
    elif usr_choice == '1':
        print('\n')
        cur.execute("SELECT * FROM property")
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

            cur.execute(f"SELECT * FROM property ORDER BY {col} {asc}")
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
