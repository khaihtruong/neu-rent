import pymysql
from tabulate import tabulate
import os
from getpass import getpass
import hashlib
import uuid
from filter import main_menu

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