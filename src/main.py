import pymysql
from tabulate import tabulate
import os
from getpass import getpass
import hashlib
import uuid
from filter import main_menu, display_logo
from login import signup, login

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
            print("3: Quit the program")
            option = input("Enter your choice: ").strip()
            if option == '1':
                authenticated_email = signup(cur, conn)
            elif option == '2':
                authenticated_email = login(cur)
            elif option == '3':
                exit()
            else:
                print("Invalid option. Please select 1, 2, or 3.\n")
        print(f"Welcome, {authenticated_email}!\n")
        main_menu(cur, conn, authenticated_email)
        # When main_menu returns, the user has logged out.
        print("You have been logged out.\n")

if __name__ == "__main__":
    main()