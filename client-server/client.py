import socket

def connect_to_server():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect(("localhost", 5555))
    return client

def register(client):
    username = input("Enter a username: ")
    password = input("Enter a password: ")
    message = f"REGISTER|{username}|{password}"
    client.send(message.encode('utf-8'))
    response = client.recv(1024).decode('utf-8')
    print(response)

def login(client):
    username = input("Enter your username: ")
    password = input("Enter your password: ")
    message = f"LOGIN|{username}|{password}"
    client.send(message.encode('utf-8'))
    response = client.recv(1024).decode('utf-8')
    print(response)
    return "successful" in response

def add_question(client):
    question = input("Enter the question: ")
    options = input("Enter the options (comma separated): ")
    answer = input("Enter the correct answer: ")
    message = f"ADD_QUESTION|{question}|{options}|{answer}"
    client.send(message.encode('utf-8'))
    response = client.recv(1024).decode('utf-8')
    print(response)

def answer_question(client):
    question_id = input("Enter the question ID you want to answer: ")
    answer = input("Enter your answer: ")
    message = f"ANSWER_QUESTION|{question_id}|{answer}"
    client.send(message.encode('utf-8'))
    response = client.recv(1024).decode('utf-8')
    print(response)

def view_questions(client):
    message = "VIEW_QUESTIONS"
    client.send(message.encode('utf-8'))
    response = client.recv(4096).decode('utf-8')
    print(response)

def view_leaderboard(client):
    message = "VIEW_LEADERBOARD"
    client.send(message.encode('utf-8'))
    response = client.recv(4096).decode('utf-8')
    print(response)

def main():
    client = connect_to_server()
    authenticated = False
    while True:
        if not authenticated:
            print("1. Register")
            print("2. Login")
            choice = input("Enter your choice: ")
            if choice == '1':
                register(client)
            elif choice == '2':
                authenticated = login(client)
            else:
                print("Invalid choice. Please try again.")
        else:
            print("1. Add Question")
            print("2. Answer Question")
            print("3. View Questions")
            print("4. View Leaderboard")
            print("5. Quit")
            choice = input("Enter your choice: ")
            if choice == '1':
                add_question(client)
            elif choice == '2':
                answer_question(client)
            elif choice == '3':
                view_questions(client)
            elif choice == '4':
                view_leaderboard(client)
            elif choice == '5':
                break
            else:
                print("Invalid choice. Please try again.")
    client.close()

if __name__ == "__main__":
    main()
