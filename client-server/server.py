import os
import socket
import threading
import mysql.connector
import hashlib

# MySQL database setup
db_config = {
    'user': os.getenv('DB_USER', 'aakash'),
    'password': os.getenv('DB_PASSWORD', 'db_pass'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'quiz_game')
}
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

def handle_client(client_socket, addr):
    print(f"[NEW CONNECTION] {addr} connected.")
    authenticated = False
    username = None
    while True:
        try:
            message = client_socket.recv(1024).decode('utf-8')
            if message:
                command, *args = message.split('|')
                if command == 'REGISTER':
                    response = register_user(*args)
                elif command == 'LOGIN':
                    response, authenticated, username = login_user(*args)
                elif authenticated:
                    if command == 'ADD_QUESTION':
                        response = add_question(*args, username)
                    elif command == 'ANSWER_QUESTION':
                        response = answer_question(*args, username)
                    elif command == 'VIEW_QUESTIONS':
                        response = view_questions()
                    elif command == 'VIEW_LEADERBOARD':
                        response = view_leaderboard()
                    else:
                        response = "Invalid command."
                else:
                    response = "Please log in first."
                client_socket.send(response.encode('utf-8'))
            else:
                break
        except Exception as e:
            print(f"Exception in handling client: {e}")
            break
    client_socket.close()

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def register_user(username, password):
    hashed_password = hash_password(password)
    try:
        cursor.execute('INSERT INTO users (username, password) VALUES (%s, %s)', (username, hashed_password))
        conn.commit()
        return "Registration successful."
    except mysql.connector.IntegrityError:
        return "Username already taken."

def login_user(username, password):
    hashed_password = hash_password(password)
    cursor.execute('SELECT password FROM users WHERE username = %s', (username,))
    result = cursor.fetchone()
    if result and result[0] == hashed_password:
        return "Login successful.", True, username
    else:
        return "Invalid username or password.", False, None

def add_question(question, options, answer, username):
    cursor.execute('INSERT INTO questions (question, options, answer, created_by) VALUES (%s, %s, %s, %s)', 
                  (question, options, answer, username))
    conn.commit()
    return "Question added successfully."

def answer_question(question_id, answer, username):
    # Check if user created the question
    cursor.execute('SELECT created_by FROM questions WHERE id = %s', (question_id,))
    created_by = cursor.fetchone()[0]
    if created_by == username:
        return "You cannot answer your own question."

    # Check if user has already answered the question
    cursor.execute('SELECT COUNT(*) FROM answered_questions WHERE username = %s AND question_id = %s', (username, question_id))
    if cursor.fetchone()[0] > 0:
        return "You have already answered this question."

    # Check the answer
    cursor.execute('SELECT answer FROM questions WHERE id = %s', (question_id,))
    correct_answer = cursor.fetchone()[0]
    if correct_answer == answer:
        cursor.execute('INSERT INTO leaderboard (username, points) VALUES (%s, %s) ON DUPLICATE KEY UPDATE points = points + 1', (username, 1))
        cursor.execute('INSERT INTO answered_questions (username, question_id) VALUES (%s, %s)', (username, question_id))
        conn.commit()
        return "Correct answer! Points added."
    else:
        return "Incorrect answer."

def view_questions():
    cursor.execute('SELECT id, question FROM questions')
    questions = cursor.fetchall()
    questions_str = '\n'.join([f"ID: {row[0]}, Question: {row[1]}" for row in questions])
    return questions_str

def view_leaderboard():
    cursor.execute('SELECT * FROM leaderboard ORDER BY points DESC')
    leaderboard = cursor.fetchall()
    leaderboard_str = '\n'.join([f"{row[0]}: {row[1]} points" for row in leaderboard])
    return leaderboard_str

def start():
    server.listen()
    print("[LISTENING] Server is listening...")
    while True:
        client_socket, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(client_socket, addr))
        thread.start()
        print(f"[ACTIVE CONNECTIONS] {threading.active_count() - 1}")

# Main server setup
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("0.0.0.0", 5555))

print("[STARTING] Server is starting...")
start()
